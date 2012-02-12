mongo = require('../../lib/db')
db = mongo.db()

db.bind 'teammates'

class Teammate

	@create: (email, callback) ->
    	db.teammates.insert(email: email, {}, callback)

	@findByEmail: (email, callback) ->
		db.teammates.findOne(email: email, {}, callback)
	
	@findAll: (callback) ->
		db.teammates.find().toArray callback

	@get: (teammateId, callback) ->

		# OK, I guess it's not the cleanest way of doing this.
		# I expected the 'findById' method to check the ID (mongoskin bug?)
		if teammateId.length != 24
			# Reminder: Some options to be explored:
			# ObjectID = db.db.bson_serializer.ObjectID
			# teammateId = db.teammates.id(teammateId)
			callback('bad Id', null) if callback
			return
		else
			db.teammates.findById(teammateId, {}, callback)
	
module.exports =
	Teammate: Teammate