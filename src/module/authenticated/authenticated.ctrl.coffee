angular.module 'picstreet.authenticated'

.controller 'authenticatedCtrl', ($rootScope, $scope, $state, $connect, $pxModal) ->
	
	$scope.api = __API_URL__
	


	$scope.logout = ->
		$connect.logout ->
			$state.go 'login'

	$scope.openModalPaymentMethods = ->
		$pxModal.getPaymentMethods {}
		, (modal, modalScope) ->
			modalScope.show()

	$scope.openModalMyPictures = ->
		$pxModal.getMyPictures {}
		, (modal, modalScope) ->
			modalScope.show()

	$scope.showIntercom = ->
		console.log 'SHOW INTERCOM'

		Intercom 'show'