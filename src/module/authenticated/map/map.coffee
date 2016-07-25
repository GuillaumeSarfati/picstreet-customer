angular.module "picstreet.map", ['leaflet-directive']

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.map',
		url: '/map'
    
		views:
			'menuContent' :
				templateUrl: 'map.view.html'
				controller: 'mapCtrl'



		resolve:

			photographers: (Photographer) ->
				Photographer.find
					filter:
						include: 
							relation: 'positions'
							scope:
								order: 'date DESC'
				.$promise

			monuments: (Location) ->
				Location.find {}
				.$promise

	return

.run ->
	return
