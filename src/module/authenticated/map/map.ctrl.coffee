angular.module "picstreet.map"

.controller "mapCtrl", ($cordovaDialogs, $ionicLoading, $picstreet, photographers, monuments, $cordovaGeolocation, $scope, $rootScope) ->
	
	$scope.monuments = monuments
	$scope.center = $picstreet.center

	console.info '[ PHOTOGRAPHERS ]', photographers
	console.info '[ MONUMENTS ]', monuments
	
	$scope.reserve = $picstreet.reserve
		
	$cordovaGeolocation
	.getCurrentPosition()
	.then (position) ->
		
		$picstreet.setCurrentPosition
			lat: position.coords.latitude
			lng: position.coords.longitude
		
		$picstreet.createMap
			center: 
				lat: position.coords.latitude
				lng: position.coords.longitude
			zoom: 12

		$picstreet.createPhotographers photographers
		$picstreet.createMonuments monuments
		
		$picstreet.createCustomer
			center:
				lat: position.coords.latitude
				lng: position.coords.longitude

	$scope.$on "$ionicSlides.sliderInitialized", (event, data) ->
		$scope.slider = data.slider

	$scope.$on "$ionicSlides.slideChangeEnd", (event, data) ->

		console.log 'SLIDE CHANGED : ', data.slider.activeIndex - 1
		if data.slider.activeIndex
			$scope.center($scope.monuments[data.slider.activeIndex - 1])
		else
			$scope.center $picstreet.getCurrentPosition()

	$rootScope.$on 'customer:position:update', (e, position) ->
		$picstreet.updateCustomerPosition position
		$picstreet.center position.coord

	$rootScope.$on 'photographer:position:update', (e, position) ->

 		$picstreet.updatePhotographerPosition
 			photographerId: position.photographerId
 			position: position
			
