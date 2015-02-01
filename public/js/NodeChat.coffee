deliver = (cb) ->
  try
    cb()
  catch
    setTimeout(20, ->
      deliver(cb)
    )

class NodeChat
  constructor: ($, User, Ui, io) ->
    @io = io()
      .on('connect', =>
        window.console.log('connected')
        @window = window
        @$ = $
        @_initUi(Ui)
        @_initUser()
        if !@user.loggedIn
          @showLoginWindow()
        @io
          .on('user.join', (data) =>
              deliver(=>
                data = JSON.parse(data)
                console.log(data)
                @_ui.addUser(data.users)
                @_ui.addMessage('[чат]', "К нам пришел &quot;#{data.nick}&quot;")
              )
          )
          .on('user.changeNick', (data) =>
            data = JSON.parse(data)
            @_ui.addUser(data.oldNick)
            @_ui.removeUser(data.newNick)
            @_ui.addMessage('[чат]', "Участника #{data.oldNick} теперь зовут #{data.newNick}")
          )
          .on('user.leave', (nick) =>
            @_ui.removeUser(nick)
            @_ui.addMessage('[чат]', "Участника #{nick} бабайка забрала")
          )
      )
  _initUi: (Ui) ->
    @_ui = new Ui(@$)
  _initUser: ->
    opts =
      onChangeNick: (oldNick, newNick) =>
        @_ui.addMessage('[чат]', "Вы вошли под ником &quot;#{newNick}&quot;")
        if oldNick?
          @io.emit('changeNick', newNick)
        else
          @io.emit('login', newNick)
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