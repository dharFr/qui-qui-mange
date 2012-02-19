$ ->
	$form = $('#todayForm')
	$message = $('#message')

	message = (type) ->

		type = 'error' if not type in ['error', 'warning', 'success']
		$message.removeClass().addClass("alert alert-#{type}").show('slow')


	$form.submit (e) ->

		e.preventDefault()

		$message.hide('slow')

		# sending form
		jqXhr = $.post $form.attr('action'), $form.serialize()

		jqXhr.done (data)->
			console.log 'done', data
			if data?.msg == 'ok' 
				message('success')
				$form.hide()
			else
				message 'error'

		jqXhr.fail (jqXhr, txtStatus, errThrown)->
			console.log 'fail', arguments
			if jqXhr.status == 409 and jqXhr.statusText == 'Conflict'
				message 'warning'
				$form.hide()
			else
				message 'error'

		return false
