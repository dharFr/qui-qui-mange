db = require('../../lib/db').db()

db.bind 'teammates'

class Teammate

	@create: (email, callback) ->
    	db.teammates.insert(email, {}, callback)

	@findByEmail: (email, callback) ->
		db.teammates.findOne(email: email, {}, callback)
	
	@get: (teammateId, callback) ->
		db.teammates.findById(teammateId, {}, callback)
	
module.exports =
	Teammate: Teammate