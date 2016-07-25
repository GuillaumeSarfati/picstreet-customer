
push = undefined

angular.module 'picstreet'

.service '$notification', ($q, $ionicNativeTransitions, $cordovaDialogs, Device, $ionicPlatform, $rootScope, $localStorage, $cordovaDevice, $state, $stateParams) ->
	
	
	types = {}
	
	customerIsInTheNotificationState = (notification, type) ->
		deferred = $q.defer()
		unless type.state
			deferred.reject type 
			return deferred.promise

		if type.state.name is $state.current.name
			
			if type.state.paramsLink

				for param, link of type.state.paramsLink
					
					if $stateParams[param] isnt notification.additionalData[link]
						deferred.reject type
						return deferred.promise

					deferred.resolve type
			else
				deferred.resolve type
		else
			deferred.reject type

		return deferred.promise

	

	service = 

		request: (callback=->) ->

			$ionicPlatform.ready ->

				if window.cordova and PushNotification

					PushNotification.hasPermission (permission) ->
						
						callback permission

				else
					PushNotification = undefined


		register: ->
			$ionicPlatform.ready ->
				
				if window.cordova and PushNotification
					

					$localStorage.device = {} unless $localStorage.device
					$localStorage.device.info = $cordovaDevice.getDevice()

					push = PushNotification.init
						android:
							senderID: "1014176575540"
						ios:
							alert: true
							badge: true
							sound: true

					push.on 'registration', (data) -> 
						console.log "*************************************"
						console.log "data : ", data.registrationId
						console.log "*************************************"

						$localStorage.deviceToken = data.registrationId

					$rootScope.$on 'request:connect', (e, me) ->
						
						if me 

							$localStorage.device = {} unless $localStorage.device
							$localStorage.device[me.id] = {} unless $localStorage.device[me.id]
							$localStorage.device[me.id].info = $cordovaDevice.getDevice()
							$localStorage.device[me.id].token = $localStorage.deviceToken
							$localStorage.device[me.id].customerId = me.id


							Device.upsert $localStorage.device[me.id]
							.$promise
							.then (success) -> 
								$localStorage.device[me.id] = success unless success.error
							.catch (err) -> console.log 'err save device: ', err

				else
					console.log 'Push Plugin is not present'

		watch: ->

			handlerNotification = (notification) ->
				console.log '\n\n'
				console.log '-----------------------------------------------'
				console.log '| New Notification', notification
				console.log '-----------------------------------------------'
				console.log '| types : ', types
				console.log '-----------------------------------------------'
				console.log '\n\n'

				for typeName, typeValue of types

					if notification.additionalData.type.match ///^#{typeName}///

						if moment() - __uptime < 3000

							customerIsInTheNotificationState notification, types[typeName]
							
							.then (type) ->

								type.update notification if typeof type.update is 'function'

							.catch (type) ->

								type.deep notification if typeof type.deep is 'function'

						else

							customerIsInTheNotificationState notification, types[typeName]

							.then (type) ->

								type.update notification if typeof type.update is 'function'

							.catch (type) ->

								type.notify notification if typeof type.notify is 'function'

			$ionicPlatform.ready ->
				
				if window.cordova and PushNotification
					
					push.on 'notification', (notification) -> 
						handlerNotification notification

				else

					console.log 'NOT WATCH :('

		type: (typeName, opts={}) ->

			types[typeName] = {}

			types[typeName].state = opts.state if typeof opts.state is 'object'
			types[typeName].deep = opts.deep if typeof opts.deep is 'function'
			types[typeName].notify = opts.notify if typeof opts.notify is 'function'
			types[typeName].update = opts.update if typeof opts.update is 'function'

			@

		show: (notification, opts={}, clickCallback) ->

			$rootScope.$broadcast '$notification:show'
			, notification
			, opts
			, clickCallback

.run ($notification) ->

	$notification
	#---------------------------------------------------
	# Album Notification Configuration
	#---------------------------------------------------
	.type 'album:new',

		state:
			#this param determine if notify or update
			name: ''

			#link $stateParams.id to notification.additionalData.roomId
			paramsLink: id: 'albumId'
		
		# when the app is close or in background
		deep: (notification) ->
			console.log '----------------------'
			console.log 'deep : ', notification
			console.log '----------------------'

		# when the app isn't in the good state
		notify: (notification) ->
			console.log '----------------------'
			console.log 'notify : ', notification
			console.log '----------------------'

		# when the app is in the good state
		update: (notification) ->
			console.log '----------------------'
			console.log 'update : ', notification
			console.log '----------------------'
			
			



