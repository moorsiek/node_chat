COOKIE_NAME = 'nodeChatUser'

class User
  constructor: (opts) ->
    opts = window.$.extend({}, opts)
    @_onChangeNick = opts.onChangeNick
    @_init(opts.nick)
  _init: (nick) ->
    @loggedIn = false
    cookie = @loadCookie()
    if cookie
      @setNick(cookie.nick, false)
      @loggedIn = true
    else
      @setNick(nick ? 'Аноним', false)
  loadCookie: ->
    cookie = $.cookie(COOKIE_NAME)
    if cookie
      cookie = JSON.parse(cookie)
    else
      cookie = null
  saveCookie: ->
    cookie =
      nick: @nick
    $.cookie(COOKIE_NAME, JSON.stringify(cookie))
  setNick: (nick, saveCookie = true) ->
    @nick = nick
    @saveCookie() if saveCookie
    @_onChangeNick(nick) if @_onChangeNick

window.User = User