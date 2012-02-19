cronJob = require('cron').CronJob
mailer = require('./mailer')

lunches = require('./models/lunches')
Lunch = lunches.Lunch
todayLunch = lunches.todayLunch

console.log 'Defining cron jobs'
cronJob '00 30 10 * * 2-6', ->
#cronJob '00 08 23 * * *', ->
	#  Runs every weekday (Monday through Friday)
	# at 10:30:00 AM. It does not run on Saturday or Sunday.
	console.log 'good morning. Time to choose a restaurant...'

	todayLunch (err, lunches) ->
		lunch = lunches[0]

		for teammate in lunch.teammates
			mailer.sendDaily teammate


cronJob '00 30 11 * * 2-6', ->
#cronJob '00 25 23 * * *', ->
	#  Runs every weekday (Monday through Friday)
	# at 11:30:00 AM. It does not run on Saturday or Sunday.
	console.log 'restaurant chosen. time to reserve!'

	todayLunch (err, lunches) ->
		lunch = lunches[0]

		resto = Lunch.winner(lunch)
		luckyGuy = lunch.teammates[ Math.floor (Math.random() * lunch.teammates.length )]
		mailer.sendWinner luckyGuy, resto

