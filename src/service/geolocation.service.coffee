angular.module 'picstreet'

.service '$geolocation', ($rootScope, Position) ->
	init: ->
		if window.cordova
			backgroundGeolocation.configure (currentPosition) ->

			

				console.log 'BACKGROUND SUCCESS : ', currentPosition
				Position.create
					customerId: $rootScope.me.id
					coord:
						lat: currentPosition.latitude
						lng: currentPosition.longitude
				.$promise
				.then (position) -> 
					console.log 'SUCCESS SEND BACKGROUND POSITION : ', position
					$rootScope.$emit 'customer:position:update', position
					backgroundGeolocation.finish();

				.catch (err) -> 
					console.log 'ERROR SEND BACKGROUND POSITION : ', err
					backgroundGeolocation.finish();

			, (err) -> 
				console.log 'BACKGROUND ERR : ', err
			, 
				desiredAccuracy: 100,
				stationaryRadius: 20,
				distanceFilter: 10,
				activityType: 'AutomotiveNavigation',
				debug: false,
				stopOnTerminate: false

	watch: ->
		if window.cordova

			console.log 'START BACKGROUND GEOLOC'
			backgroundGeolocation.start()

		else
			
			console.log 'CANNOT START BACKGROUND GEOLOC'
