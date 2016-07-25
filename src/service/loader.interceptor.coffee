angular.module 'picstreet'

.constant '$ionicLoadingConfig',
	animation: 'fade-in'
	showBackdrop: false
	template: '<ion-spinner>Loading...</ion-spinner>'
	hideOnStateChange: true

.factory 'loader', ($rootScope, $q) ->

	request: (config) ->
		unless config.url.match /// /api/Positions ///
			$rootScope.$broadcast('loading:show')
		return config
	
	requestError: (err) -> 
		$rootScope.$broadcast('loading:hide') 
		return $q.reject(err)

	response: (response) ->
		$rootScope.$broadcast('loading:hide')
		return response
	
	responseError: (err) ->
		$rootScope.$broadcast('loading:hide') 
		return $q.reject(err)
 
.run ($rootScope, $ionicLoading) ->

	$rootScope.$on 'loading:show', (e, opts={})->
		$ionicLoading.show() 

	$rootScope.$on 'loading:hide', (e, opts={}) ->
		$ionicLoading.hide() 
	