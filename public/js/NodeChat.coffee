class NodeChat
  constructor: ($, User) ->
    @window = window
    @$ = $
    @_initUser()
    if !@user.loggedIn
      @showLoginWindow()
  _initUser: ->
    opts =
      onChangeNick: (nick) ->
        $('.b-info-bar__nick').text(nick)
    @user = new User(opts)
  _setupUi: ->
    @node = $('<div/>')
  showLoginWindow: ->
    title = 'Введите ник'
    template = """
                <div class="j-popup b-popup">
                  <a class="j-popup__close b-popup__close" href="#"></a>
                  <div class="b-popup__title">#{title}</div>
                  <input type="text" class="j-popup__nick b-popup__nick">
                  <button class="j-popup__ok b-popup__ok">ok</button>
                </div>
                """
    $node = $(template)
      .on('click.popup', '.j-popup__close, .j-popup__ok', (e) =>
        e.preventDefault()

        nick = $node.find('.j-popup__nick').val()
        if nick
          @user.setNick(nick)

        $node.remove()
      )
      .appendTo('body')

window.NodeChat = NodeChat