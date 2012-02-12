express = require 'express'
assets = require 'connect-assets'
app = null

module.exports =
	app: -> app

	startup: ->

		if app is not null 
			console.log 'app already started'
			return

		console.log 
		# Database config
		mongoUrl = process.env.MONGOLAB_URI || "localhost:27017/db"
		mongoUrl = mongoUrl + '?auto_reconnect'
		console.log "Using mongo URL #{mongoUrl}"

		# init DB
		require('./lib/db').init mongoUrl

		# Server config
		app = express.createServer()

		coffeeDir = "#{__dirname}/coffee"
		publicDir = "#{__dirname}/public"

		app.configure ->
			app.set 'views',  "#{__dirname}/views"
			app.set 'view engine', 'jade'
			
			app.use express.bodyParser()
			app.use express.methodOverride()

			app.use app.router			
			app.use express.static publicDir
			app.use assets()
			
		app.configure 'development', ->
			app.use express.errorHandler
				dumpExceptions: true
				showStack: true

		app.configure 'production', ->
			app.use express.errorHandler()
		
		# 404 Page
		app.use (req, res, next) ->
			# seems the header isn't correctly sent (client receives 200)
			# Need to find a better way...
			res.header('Status', '404');
			res.sendfile "#{publicDir}/404.html"

		# Routes
		app.get '/', (req, res) ->
			res.redirect '/subscribe/'

		return app