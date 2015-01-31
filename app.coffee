express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)
nconf = require('nconf')
config = nconf.file({file: 'config.json'})

indexCtrl = require('./controllers/index.coffee')

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
sockets = {}
socketToUser = {}

io
  .on('connection', (socket) ->
    console.log('a user connected')
    sockets[socket.id] = socket

    socket
      .on('disconnect', ->
        delete sockets[socket.id]
        if socketToUser[socket.id]
          nick = socketToUser[socket.id]
          delete users[nick]
          delete socketToUser[socket.id]
          io.emit('user.leave', nick)
      )
      .on('login', (nick) ->
        if !nick? || nick is ''
          socket.emit('login.error', 'Недопустимый ник')
        if users[nick]
          socket.emit('login.error', "#{nick} уже тут")
        else
          users[nick] = socket
          socketToUser[socket.id] = nick
          socket.emit('login.ok')
          io.emit('user.join', nick)
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