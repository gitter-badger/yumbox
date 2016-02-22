Boom =    require 'boom'
Q =       require 'q'
_ =       require 'lodash'
moment =  require 'moment'

module.exports = (server, options) ->
  return class UserTimeline extends server.methods.model.Base()
    PREFIX: false
    POSTFIX: ':timeline'

    props:
      list:true

    constructor: (key, doc, all) ->
      key = @_key key
      super

    before_create: ->
      @doc.list = [] unless @doc.list?
      true

    @get_or_create: (doc_key) ->
      timeline_key = @_key doc_key
      @get(timeline_key)
        .then (timeline) =>
          if timeline instanceof Error
            timeline = new UserTimeline timeline_key,{}
            timeline.create()
              .then -> timeline
          else
            timeline

    add: (activity, type) ->
      @doc.list.unshift
        doc_key: activity.doc_key
        name: activity.title
        type: type
        at: moment().format()
      @update()

    _key: (id) ->
      UserTimeline._key id
    
    @_key: (id) ->
      if id.indexOf(UserTimeline::POSTFIX) > -1
        id
      else
        "#{id}#{UserTimeline::POSTFIX}"
