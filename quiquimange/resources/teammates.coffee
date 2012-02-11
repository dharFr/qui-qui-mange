Teammate = require('../models/teammates').Teammate

module.exports = 
    
	create: (req, res) ->

		console.log 'res.teammates.create'
		Teammate.findByEmail req.body.email, (err, existing) ->

			if not existing
				Teammate.create email: req.body.email, (err, inserted) ->
					res.send inserted[0]

			else #Conflict
        		res.send(existing, 409)
