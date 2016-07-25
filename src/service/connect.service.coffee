angular.module 'picstreet'

.service '$connect', ($popup, $ionicPlatform, $socket, LoopBackAuth, Customer, $ionicNativeTransitions, $rootScope, $cordovaDialogs) ->
		
	$connect = 

		signup: (me, opts={}, callback) ->
			console.log 'signup : ', me
			Customer.create me
			.$promise
			.then (customer) ->
				$connect.login me, (accessToken) ->
					console.log 'customer : ', customer
					$rootScope.me = customer
					$popup.welcome me
					
					callback customer

			.catch (err) -> 
				console.log 'err : ', err
				
				$cordovaDialogs.alert "This email already use with another account.", "PicStreet", "Ok" if err.data.error.details.codes.email[0] is 'uniqueness'
				$cordovaDialogs.alert "Bad email format.", "PicStreet", "Ok" if err.data.error.details.codes.email[0] is 'format'

		login: (opts={}, callback=->) ->
			console.log 'login : ', opts
			Customer.login

				email: opts.email
				password: opts.password
				rememberMe: true

			.$promise
			.then (accessToken) ->
					

					LoopBackAuth.setUser(accessToken.id, accessToken.userId, accessToken.user)
					LoopBackAuth.rememberMe = true
					LoopBackAuth.save()

					callback accessToken


			.catch (err) -> 
				$cordovaDialogs.alert "Bad Email / Password", "PicStreet", "Ok"
				callback false


		logout: (callback)->
			# Intercom 'shutdown'
			Customer.logout()
			callback()

		remember: (callback=->) ->
			
			if window.localStorage.getItem '$LoopBack$accessTokenId'
				
				console.log '$connect:localStorage'
				
				Customer.remember
					filter:
						include: [
							{
								relation: 'albums'
								scope: {
									include: 'pictures'
								}
							}
							{
								relation: 'creditCards'
							}
							{
								relation: 'defaultCreditCard'
							}

						]

				.$promise
				.then (me) ->
					
					$popup.welcome me

					$ionicPlatform.ready ->
						if window.analytics
							
							window.analytics.debugMode()
							window.analytics.startTrackerWithId('UA-80835235-1')
							window.analytics.setUserId(me)

							console.log 'ANALYTICS ENABLE'
						else
							console.log 'ANALYTICS DISABLE'
					
					Intercom 'boot',
						app_id: "t1fie9we"
						widget:
					   	activator: "#intercom" 
					  
					setTimeout ->
						Intercom "update", {

							user_id: me.id
							email: me.email
							# name: "#{me.firstname} #{me.lastname}"
							firstname: me.firstname
							lastname: me.lastname
							created_at: 1234567890
						}
					, 1000

					$rootScope.me = me

					$socket.instance()

					console.info '[ ME ]', me
					callback me
				.catch (err) -> callback false
			else
				callback false
				

