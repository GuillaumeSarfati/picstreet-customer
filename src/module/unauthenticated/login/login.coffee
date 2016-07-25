angular.module "picstreet.login", []

.config ($stateProvider) ->

	$stateProvider

	.state 'login',
		url: '/login'
		templateUrl: 'login.view.html'
		controller: 'loginCtrl'

.run ->
	return
