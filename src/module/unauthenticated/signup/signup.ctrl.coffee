angular.module "picstreet.signup"

.controller "signupCtrl", ($ionicNativeTransitions, $scope, $state, $connect) ->

	$scope.signup = (me) ->
		$connect.signup me
		, {}
		, (me) ->
			console.log 'me : ', me
			$ionicNativeTransitions.stateGo 'authenticated.map'
			, {}
			, 
				type: "flip"
				direction: "left"
				duration: 400

	$scope.back = ->
		$state.go 'login'
