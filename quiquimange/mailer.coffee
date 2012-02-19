nodemailer = require("nodemailer")
jade = require("jade")

host = "http://localhost:3000"
# SMTP Configuration
smtpOptions = 
	host: "smtp.gmail.com"	# hostname
	secureConnection: true	# use SSL
	port: 465				# port for secure SMTP
	auth: 
		user: "gmail.user@gmail.com"
		pass: "userpass"

# Mailer Configuration
dailyMailOptions = 
	from: "Qui-qui-mange <daily@quiquimange.com>"
	subject: "[Qui-qui-mange] Daily vote reminder"
	generateTextFromHTML: yes

winnerMailOptions = 
	from: "Qui-qui-mange <daily@quiquimange.com>"
	subject: "[Qui-qui-mange] And the winner is..."
	generateTextFromHTML: yes


smtpTransport = nodemailer.createTransport "SMTP", smtpOptions
dailyMailOptions.transport = smtpTransport
winnerMailOptions.transport = smtpTransport

module.exports = 

	sendDaily: (teammate) ->

		mailTpl = "#{__dirname}/../views/quiquimange/emails/daily.jade"
		mailData = 
			mail: teammate.email
			link: "#{host}/vote/#{teammate._id}"

		console.log "sendDaily:" , mailTpl, mailData

		jade.renderFile mailTpl, mailData, (err, mailBody) ->

			dailyMailOptions.to = teammate.email
			dailyMailOptions.html = mailBody

			nodemailer.sendMail dailyMailOptions, (error, responseStatus) ->
				if not error
					console.log "Daily mail sent to #{teammate.email} with response #{responseStatus.message}"
				else
					console.log "Daily mail error: ", error
	
	sendWinner: (teammate, resto) ->

		mailTpl = "#{__dirname}/../views/quiquimange/emails/winner.jade"
		mailData = 
			mail: teammate.email
			restaurant: resto

		console.log "sendWinner:" , mailTpl, mailData

		jade.renderFile mailTpl, mailData, (err, mailBody) ->

			winnerMailOptions.to = teammate.email
			winnerMailOptions.html = mailBody

			nodemailer.sendMail winnerMailOptions, (error, responseStatus) ->
				if not error
					console.log "Winner mail sent to #{teammate.email} with response #{responseStatus.message}"
				else
					console.log "Winner mail error: ", error



