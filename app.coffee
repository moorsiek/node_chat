express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)
nconf = require('nconf')
config = nconf.file({file: 'config.json'})

indexCtrl = require('./controllers/index.coffee')
User = require('./models/User.coffee')




#configure application
app.set('view engine', 'jade')
app.set('views', __dirname + '/views')

#nconf.argv().env();

#add middlewares
app.use(express.static(__dirname + '/public'))

app.get('/', (req, res) ->
  indexCtrl.view(req, res)
)

users = {}
socketToUser = {}
id = 0

io
  .on('connection', (socket) ->
    console.log('a user connected')

    user =x
      id: ++id
      socket: socket
      loggedIn: false

    users[user.id] = user
    socketToUser[socket.id] = user.id

    socket
      .on('disconnect', ->
        delete users[user.id]
        delete socketToUser[socket.id]
        io.emit('user.leave', user.nick) if user.loggedIn
      )
      .on('login', (nick) ->
        if !nick? || nick is ''
          socket.emit('login.error', 'Недопустимый ник')
        if user
          socket.emit('login.error', "#{nick} уже тут")
        else
          user.nick = nick
          socketToUser[socket.id] = nick
          socket.emit('login.ok')
          data =
            nick: nick
            users: Object.getOwnPropertyNames(users)
          io.emit('user.join', JSON.stringify(data))
      )
      .on('changeNick', (nick) ->
        oldNick = socketToUser[socket.id]
        if oldNick?
          socketToUser[socket.id] = nick
          users[nick] = socket
          delete users[oldNick]
        else
          socketToUser[socket.id] = nick
          users[nick] = socket
        data =
          oldNick: oldNick
          newNick: nick
        io.emit('user.changeNick', JSON.stringify(data))
      )
  )





http.listen(config.get('server:port'), ->
  console.log("listening on *:#{config.get('server:port')}")
)