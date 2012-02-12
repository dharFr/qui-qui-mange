require('express-resource')

app = require('../app').app()
Lunch = require('./models/lunches').Lunch

routePrefix = ''

# API
teammates = app.resource("#{routePrefix}teammates", require('./resources/teammates'))

# Pages
app.get "/#{routePrefix}subscribe", (req, res) ->

	res.render 'quiquimange/subscribe', 
		title: 'Qui qui mange?'
		subtitle: 'Abonnement'

app.get "/#{routePrefix}vote/:teammateId", (req, res, next) ->

	Teammate.get req.params.teammateId, (err, existing) ->

		if err != null or existing == null
			next() # lead to 404
			return
		else

			res.render 'quiquimange/vote',
				title: 'Qui qui mange?'
				subtitle: 'Vote du Jour',
				teammate: existing
				places: restos

app.post "/#{routePrefix}vote/:teammateId", (req, res, next) ->

	todayLunch  (err, lunches) ->
		lunch = lunches[0]
		console.log 'today lunch:', err, lunch

		theVote = {teammate: req.params.teammateId, resto: req.body.resto}
		console.log 'vote:', theVote

		votes = lunch.votes or []

		for vote in votes
			if theVote.teammate == vote.teammate
				res.json(err: 'already done', 409) 
				return
		
		votes.push {teammate: req.params.teammateId, resto: req.body.resto}
		lunch.votes = votes

		Lunch.update lunch, (err) ->
			if not err
				res.json(msg: 'ok', 200)
			else
				res.json(err:'Something went wrong', 500)

		#for teammate in lunch.teammates
		#	console.log "http://#{req.headers.host}/vote/#{teammate._id}"


restos = require('./restos-data')
Teammate = require('./models/teammates').Teammate

todayLunch = (callback) ->

	Lunch.findTodayLunch (err, existing) ->

		if existing #Conflict

    		console.log 'Lunch already exists'
    		callback(null, [existing]) if callback
		else
			Teammate.findAll (err, teammates) ->
		
				if err != null
					console.log 'handle error', err
				else
					Lunch.createTodayLunch(restos, teammates, callback)



