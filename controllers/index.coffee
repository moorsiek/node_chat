IndexController =
  view: (req, res) ->
    res.render('index.jade', {
      pageTitle: 'Node Chat',
      desc: 'Welcome to the Node Chat'
    })

module.exports = IndexController