_ = require 'lodash'
uuid   = require 'node-uuid'
moment = require 'moment'
Boom   = require 'boom'
Q      = require 'q'
Path   = require 'path'

module.exports = (server, options, User) ->
  UserEmail = require('./user_email') server, options

  PASSPORT_PATH = "#{server.methods.file.root()}/user/passport/"
  IMAGE_SIZE =
    MEDIUM: [600, 400]
    SMALL:  [300, 200]
  IMAGE_BLUR = [10, 3]

  return class UserProfile extends server.methods.model.Base()
    PREFIX: false
    POSTFIX: ':profile'
    PASSPORT_STATUS:
      PENDING:  'pending'
      APPROVED: 'approved'
      REJECTED: 'rejected'

    props:
      verification_progress:  false
      interests:              true
      analysed_interests:     false
      dob:                    true
      email:                  false
      device_verification:    false
      passport:               true
      insurance_dismissed_at: true
      fb_token:               true
      g_token:                true

    _mask: 'verification_progress,interests,dob,email,passport(number,expires_at,updated_at,review(status)),insurance_dismissed_at'
    
    constructor: (key, doc, all) ->
      key = @_key key
      super
      @passport_scan = doc.passport.scan if doc? and doc.passport? and doc.passport.scan?

    calculate_verification_progress: () ->
      @doc.verification_progress = 0
      @doc.verification_progress += 45 if @doc.passport.updated_at? or @doc.passport.scan?
      @doc.verification_progress += 5 if @doc.fb_token?
      @doc.verification_progress += 5 if @doc.g_token?
      
      UserEmail.get_by_email(@doc.email)
        .then (user_email) =>
          if user_email.doc.verification? and user_email.doc.verification.verified_at?
            @doc.verification_progress +=15
          @doc.verification_progress
    
    @verify_email: (email_address, code) ->
      UserEmail.get_by_email(email_address)
        .then (email) =>
          return new Error 'CantVerify' if email instanceof Error
          email.verify(code)
            .then (verified) =>
              return verified if verified instanceof Error
              @get_by_user(email.doc.user_key)
                .then (profile) ->
                  profile.update()
    @is_updatable: (passport) ->
      is_expired = moment(passport.expires_at).isBefore moment()
      is_expired or passport.review.status isnt UserProfile::PASSPORT_STATUS.APPROVED

    update_age: ->
      if @doc.dob?
        User.get(@get_base_key @key).then (user)=>
          return Boom.notFound "Can't find User" if user instanceof Error
          user.doc.age = moment().diff(@doc.dob, 'years')
          user.update()

    get_full_path: (name='')->
      Path.join "#{server.methods.file.root()}/user/", server.methods.file.safe_path(@key.replace 'profile', 'passport'), name

    save_passport_scan: ->
      @save_image( @passport_scan, @doc.passport.uid, IMAGE_SIZE.MEDIUM)
        .then (saved_file_path) =>
          @save_image(saved_file_path, "blurred", { size: IMAGE_SIZE.SMALL, blur: IMAGE_BLUR })
    
    before_create: ->
      @create_passport().then -> true

    before_save: ->
      delete @doc.passport.scan if @doc.passport?
      @doc.email = @doc.email.toLowerCase() if @doc.email?
      Q.all([
        @update_age(),
        @calculate_verification_progress()
      ]).then -> true

    check_and_update: (new_doc) ->
      @update_passport(new_doc.passport).then =>
        @doc.dob = new_doc.dob if new_doc.dob?
        @doc.fb_token =  new_doc.fb_token if new_doc.fb_token?
        @doc.g_token =  new_doc.g_token if new_doc.g_token?

        (if new_doc.email?
          UserEmail.change(@get_base_key(@key), @doc.email, new_doc.email)
            .then (data) =>
              @doc.email = new_doc.email unless data instanceof Error
              @doc
        else
          Q(@doc)).then => @update()

    create_passport: ->
      @doc.passport = {} unless @doc.passport?
      _.assign @doc.passport, { uid: uuid.v4(), review: { status: @PASSPORT_STATUS.PENDING } }

      if @passport_scan?
        @doc.passport.updated_at = moment().format()
        @save_passport_scan()
      else
        Q(@doc)

    update_passport: (new_passport) ->
      return Q() unless new_passport?
      current  = new_passport
      old      = @doc.passport
      user_key = @get_base_key @key
      @passport_scan = new_passport.scan if new_passport.scan?
      is_updatable = UserProfile.is_updatable old

      if current? and is_updatable
        @doc.passport.uid = uuid.v4()
        @doc.passport.number = current.number if current.number?
        @doc.passport.expires_at = current.expires_at if current.expires_at?
        if @passport_scan?
          @doc.passport.updated_at = moment().format()
          @save_passport_scan()
        else
          Q true
      else
        Q true

    confirm_passport: (hostel_key, confirmation_status) ->
      status = @PASSPORT_STATUS.APPROVED if confirmation_status is yes
      status = @PASSPORT_STATUS.REJECTED if confirmation_status is no

      if status?
        @doc.passport.review =
          status: status
          by: hostel_key
          at: moment().format()
        @update()
          .then =>
            if status is "approved"
              @notify_passport_approval(hostel_key)
            else
              @notify_passport_rejection(hostel_key)
      else
        Boom.notAcceptable "confirmation status is not valid"

    notify_passport_approval: (hostel_key) ->
      notification =
        doc:
          user_key: @key.split(UserProfile::POSTFIX)[0]
          data:
            type: "passport_approval"
            hostel_key: hostel_key
          title: "Passport is approved"
          message: "Congratulations! Your identity is approved in Tipi."
        data:{}
      server.methods.users.notify notification

    notify_passport_rejection: (hostel_key) ->
      notification =
        doc:
          user_key: @key.split(UserProfile::POSTFIX)[0]
          data:
            type: "passport_rejection"
            hostel_key: hostel_key
          title: "Passport is rejected"
          message: "Your passport scan is rejected"
        data:{}
      server.methods.users.notify notification

    @get_for_edit: (user_key) ->
      @get_with_user(user_key)
        .then (profile) ->
          profile.passport.is_updatable = UserProfile.is_updatable profile.passport
          UserEmail.get_by_email(profile.email)
            .then (email) ->
              profile.is_email_verified = email.doc.verification?.verified_at?
              profile

    @get_with_user: (user_key, profile_mask, user_mask=["doc_key","gender","age"]) ->
      @get_by_user(user_key)
        .then (profile) ->
          User.get(user_key)
            .then (user) ->
              return if user instanceof Error
              _.extend {}, profile.mask(profile_mask), user.mask(user_mask)

    @get_by_user: (user_key, raw=false) ->
      @get UserProfile._key(user_key), raw
    
    _key: (id) -> UserProfile._key id
    
    @_key: (id) ->
      if id.indexOf(UserProfile::POSTFIX) > -1
        id
      else
        "#{id}#{UserProfile::POSTFIX}"
