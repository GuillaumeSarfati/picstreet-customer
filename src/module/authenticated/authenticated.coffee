angular.module 'picstreet.authenticated', [
	'picstreet.map'
	'picstreet.payment'
	'picstreet.pictures'
]

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated',
    abstract: true
    templateUrl: 'authenticated.view.html'
    controller: "authenticatedCtrl"

