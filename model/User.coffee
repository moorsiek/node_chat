lastUserId = 0
class User
  constructor: (nick) ->
    @id = lastUserId++
    @nick = nick ? User.defaultNick
    @loggedIn = false
  setNick: (nick) ->
    @nick = nick

User.defaultNick = "Anonymous"

module.exports = User
