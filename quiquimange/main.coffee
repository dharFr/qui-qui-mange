require('express-resource')

app = require('../application').app()
lunches = require('./models/lunches')
Lunch = lunches.Lunch
todayLunch = lunches.todayLunch

Teammate = require('./models/teammates').Teammate
restos = require('./restos-data')

routePrefix = ''

# cron jobs
require('./jobs')

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

