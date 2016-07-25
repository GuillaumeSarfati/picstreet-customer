
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
						
						console.log '$notification:request : ', permission
						callback permission

				else
					PushNotification = undefined
					console.log '$notification:request psuhnotification is undefined'


		register: ->
			$ionicPlatform.ready ->
				
				if window.cordova and PushNotification
					
					console.log 'Push Plugin is present'

					$localStorage.device = {} unless $localStorage.device
					$localStorage.device.info = $cordovaDevice.getDevice()

					push = PushNotification.init
						android:
							senderID: "12345679"
						ios:
							alert: true
							badge: true
							sound: true

					push.on 'registration', (data) -> 
						console.log "*************************************"
						console.log "*************************************"
						console.log "*************************************"
						console.log "data : ", data.registrationId
						console.log "*************************************"
						console.log "*************************************"
						console.log "*************************************"
						console.log '$notification:register : ', data
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
								console.log 'DEVICE BEFORE SEND : ', $localStorage.device[me.id]
								console.log 'DEVICE SUCCESS : ', success
								$localStorage.device[me.id] = success unless success.error
							.catch (err) -> console.log 'err save device: ', err

				else
					console.log 'Push Plugin is not present'

		watch: ->

			handlerNotification = (notification) ->
				console.log '\n\n-----------------------------------------------'
				console.log '| New Notification', notification
				console.log '-----------------------------------------------'
				console.log '| types : ', types
				console.log '-----------------------------------------------'

				for typeName, typeValue of types

					console.log '| -> try : ' + typeName + ' equal ' + notification.additionalData.type


					if notification.additionalData.type.match ///^#{typeName}///

						console.log '| ** notification match ** ', typeName

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
					
					console.log 'WATCH :)'

					push.on 'notification', (notification) -> 
						handlerNotification notification

				else

					console.log 'NOT WATCH :('
				
			# else
			# 	# Mock Notification
			# 	setTimeout ->
			# 		fn 
			# 			message: 'Fake Notification'
			# 			additionalData: 
			# 				roomId: "56db8318538cc94d86623ddb"
			# 				foreground: true
			# 				type: "chat:text"
			# 				data: 
			# 					type: "text"
			# 					description: "gjhgj"
			# 	, 5000


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

