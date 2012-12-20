#create global messages collection
@ChatMessages = new Meteor.Collection('chatMessages')

#allow logged in members to send messages
@ChatMessages.allow(
	insert: (userId, entry) ->
		return true
)