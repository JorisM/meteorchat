if Meteor.isClient


	class MessageView extends Backbone.View

		initialize: (options) ->
			console.log "created MessageView"
			@scrollToBottom()
			#set chatrom number if no chatroom is selected
			if not Session.get "chatroom_id"
				Session.set "chatroom_id", 0

			#subscribe to others so your view scrolls when others enter messages. todo: only autosubscribe to new, not existing entries.
			Meteor.autosubscribe =>
				ChatMessages.find(chatroom_id: Session.get "chatroom_id").observe added: (item) =>
					@scrollToBottom()


		Template.messages.messages = ->
			#find all chatmessages belonging to selected chatroom and sort descending
			ChatMessages.find {chatroom_id: Session.get "chatroom_id"},
				sort:
					time: 1

		events:
			'click .send': 'send'
			'keyup :input' : 'evalKeypress'

		send: ->
			#insert a new chatmessage
			ChatMessages.insert({ name: Meteor.user().username, message: $(document).find('#message').val(), time: Date.now(), color: Meteor.users.findOne({_id: Meteor.userId()}).profile.color, chatroom_id: Session.get "chatroom_id"})
			@$el.find('#message').val('').focus()

		evalKeypress: (e) ->
			if e.keyCode == 13
				@send()


		#scroll to bottom of message container
		scrollToBottom: ->
			if $(".messages-container")[0]
				$(".messages-container").scrollTop($(".messages-container")[0].scrollHeight);


	class ChatRouter extends Backbone.Router
		routes:
			"chatroom/:chatroom_id": "chatroom"

		chatroom: (chatroom_id) ->
			Session.set "chatroom_id", chatroom_id


	Meteor.startup ->
		Router = new ChatRouter
		Backbone.history.start pushState: true
		Accounts.ui.config
			passwordSignupFields: "USERNAME_AND_OPTIONAL_EMAIL"

		myView = new MessageView({el: $('.container')})



