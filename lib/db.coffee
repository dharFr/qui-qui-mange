mongo = require('mongoskin')

db = null

module.exports = 
	init: (url) -> 
		db = mongo.db(url)
		return
		
	db: -> db
