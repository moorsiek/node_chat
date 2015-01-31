class Ui
  constructor: ($) ->
    @$ = $
    @_init()
  _init: ->
    @_prepareDom()
  _prepareDom: ->
    @_$node = @$(Ui._appTemplate)
      .appendTo('body')
  addMessage: (user, msg) ->
    $message = @$(Ui._messageTemplate)
      .find('.j-message__user')
        .text(user)
        .end()
      .find('.j-message__text')
        .html(msg)
        .end()
      .appendTo(@_$node.find('.j-chatBox'))
  addUser: (user) ->
    $user = @$(Ui._userTemplate)
    .text(user)
    .prop('id', user)
    .appendTo(@_$node.find('.j-usersList'))
  removeUser: (userId) ->
    @$('#'+userId)
      .remove()

Ui._appTemplate = """
<div class="j-nodeChat b-nodeChat">
  <div class="j-chatBox b-chatBox"></div>
  <div class="j-usersBox b-usersBox">
    <ul class="j-usersList b-usersList"></ul>
  </div>
  <div class="j-messageBox b-messageBox">
    <textarea class="j-messageBox__message b-messageBox__message"></textarea>
  </div>
</div>
"""

Ui._messageTemplate = """
<div class="j-message b-message">
  <div class="j-message__user b-message__user"></div>
  <div class="j-message__text b-message__text"></div>
</div>
"""

Ui._userTemplate = """
<div class="j-user b-user j-user"></div>
"""

window.Ui = Ui

###
  chatPane
  messageBox
  userList
###
