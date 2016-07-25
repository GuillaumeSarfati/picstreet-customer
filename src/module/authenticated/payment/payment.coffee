angular.module "picstreet.payment", []

.config ($stateProvider) ->

  $stateProvider

  .state 'authenticated.payment',
    url: '/payment'
    views:
      menuContent:
        templateUrl: 'payment.view.html'
        controller: 'paymentCtrl'

  return

.run ->
  return
