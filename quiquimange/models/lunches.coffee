db = require('../../lib/db').db()
moment = require('moment');

db.bind 'lunches'

class Lunch

	@createTodayLunch: (places, teammates, callback) ->
		@create Date.now(), places, teammates, callback

	@create: (date, places, teammates, callback) ->
		db.lunches.insert(
			{
				date: moment(date).sod().format("MM-DD-YYYY")
				places: places
				teammates: teammates
			}, 
			{}, callback)

	@findTodayLunch: (callback) ->
		@findByDate Date.now(), callback

	@findByDate: (date, callback) ->

		date = moment(date).sod().format("MM-DD-YYYY")
		db.lunches.findOne({date: date}, {}, callback)
	
	@get: (lunchId, callback) ->
		db.lunches.findById(lunchId, {}, callback)
	
	@update: (lunch, callback) ->
		db.lunches.save(lunch, {}, callback)
	
	@winner: (lunch) ->

		count = {}
		for vote in lunch.votes
			count[vote.resto] = if count[vote.resto] then count[vote.resto] + 1 else 1
		
		console.log '>>> Votes results:', count
		
		winners = []
		nbVotes = 0
		for resto, value of count
			
			if count[resto] > nbVotes
				winners = [resto]
				nbVotes = count[resto]
			else if count[resto] == nbVotes
				winners.push resto

		console.log ">> winners =", winners
		
		winner = winners[ Math.floor (Math.random() * winners.length )]
		console.log ">> winner =", winner

		thePlace = null
		for place in lunch.places 
			
			thePlace = place if place._id is winner

		console.log 'And the winner is: ', thePlace
		thePlace

# imports for todayLunch method
Teammate = require('./teammates').Teammate
restos = require('../restos-data')

module.exports =
	Lunch: Lunch
	todayLunch: (callback) ->

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
