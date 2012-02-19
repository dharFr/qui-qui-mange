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
	
module.exports =
	Lunch: Lunch