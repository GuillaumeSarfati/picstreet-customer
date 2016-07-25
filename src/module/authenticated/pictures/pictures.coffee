angular.module "picstreet.pictures", []

.config ($stateProvider) ->

  $stateProvider

  .state 'authenticated.pictures',
    url: '/pictures'
    views:
      menuContent:
        templateUrl: 'pictures.view.html'
        controller: 'picturesCtrl'

  return

.run ->
  return
