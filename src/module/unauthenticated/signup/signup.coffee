angular.module "picstreet.signup", []

.config ($stateProvider) ->

	$stateProvider

	.state 'signup',
		url: '/signup'
		templateUrl: 'signup.view.html'
		controller: 'signupCtrl'

	return

.run ->
	return
