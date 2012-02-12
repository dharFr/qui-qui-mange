$ ->
	$form = $('#subscribeForm')
	$icon = $form.find 'span.add-on i'
	$submit = $form.find '#submit'

	$message = $form.find '#message'

	# Initial state
	formState = (state) ->

		message = (type) ->

			type = 'error' if not type in ['error', 'warning', 'success']
			$message.removeClass().addClass("alert alert-#{type}").show('slow')

		switch state
			when 'init', 'fail'
				$icon.removeClass().addClass('icon-envelope')
				$submit.removeClass('disabled').removeAttr('disabled')

				if state is 'fail'
					message('error')
				else
					$message.hide('slow')

			when 'load'
				$icon.removeClass().addClass('icon-refresh rotate')
				$submit.attr('disabled', 'disabled').addClass('disabled')
				
				$message.hide('slow')

			when 'done', 'dual'
				$icon.removeClass().addClass('icon-ok')
				$submit
					.attr('disabled', 'disabled').addClass('disabled')
					.removeClass('btn-primary').addClass('btn')
		
				if state is 'dual'
					message('warning')
				else
					message('success')
		return

	
	formState 'init'

	$form.submit (e) ->

		e.preventDefault()
		
		formState 'load'

		# sending form
		jqXhr = $.post $form.attr('action'), $form.serialize()
		jqXhr.done (data)->
			console.log 'done', data
			if data?.email and data?._id
				formState 'done'
			else 
				formState 'fail'
		
		jqXhr.fail (jqXhr, txtStatus, errThrown)->
			console.log 'fail', arguments
			if jqXhr.status == 409 and jqXhr.statusText == 'Conflict'
				formState 'dual'
			else
				formState 'fail'

		return false
