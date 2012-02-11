app = require('../app').app()
require('express-resource')

routePrefix = ''

# API
teammates = app.resource("#{routePrefix}teammates", require('./resources/teammates'))

# Pages
app.get "/#{routePrefix}subscribe", (req, res) ->

	res.render 'quiquimange/subscribe', 
		title: 'Qui qui mange?'
		subtitle: 'Abonnement'
	

