module = window.sys.modules.guests

service = ->
  guests =
    checkins: []
    checkouts: []

  findGuest = (list, guest_key) ->
    guest = null
    angular.forEach list, (value, key) ->
      if @doc_key = guest_key
        guest = value
        return false
    guest

  return {
    setCheckins: (list) -> guests.checkins = list
    setCheckouts: (list) -> guests.checkouts = list
    getCheckin: (guest_key) -> findGuest guests.checkins, guest_key
    getCheckout: (guest_key) -> findGuest guests.checkouts, guest_key
    getGuest: (guest_key) ->
      guest = findGuest guests.checkins, guest_key
      guest = findGuest guests.checkouts, guest_key if guest is null
      guest
  }

service.$inject = module.services.guests.inject

angular.module( module.name ).factory module.services.guests.name, service
