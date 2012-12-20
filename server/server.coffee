if Meteor.isServer
	Meteor.startup ->

	#create a random color per user once he creates his account
	Accounts.onCreateUser (options, user) ->
		randomColor = ->
			"#" + Math.floor(Math.random() * 16777215).toString(16)

		# We still want the default hook's 'profile' behavior.
		options.profile = {}
		user.profile = options.profile  if options.profile
		user.profile.color = randomColor()
		user