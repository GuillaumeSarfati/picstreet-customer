#------------------------------------------------

__API_URL__ = "http://api.picstreet.io"
__API_URL__ = "http://localhost:3000" if window.location.href.match 'localhost'

console.log "%c[Pixer API] : #{__API_URL__}" , 'color: green;'

#------------------------------------------------
__rights =
	everyone: 0
	guest: 1
	member: 2
	admin: 3

__uptime = moment()

angular.module 'picstreet', [

	'ngResource'
	'ngCordova'
	'ngStorage'

	'ionic'
	'ionic.service.core'
	'ionic.service.push'
	'ionic-native-transitions'

	'lbServices'

	'ngIOS9UIWebViewPatch'
	'cwill747.phonenumber'

	'picstreet.translate'
	'picstreet.directives'

	'picstreet.authenticated'
	'picstreet.unauthenticated'

]
.config ($ionicNativeTransitionsProvider, $ionicConfigProvider, $cordovaFacebookProvider, $urlRouterProvider, LoopBackResourceProvider, $httpProvider) ->

	$ionicConfigProvider.views.swipeBackEnabled(false)

	$ionicNativeTransitionsProvider.setDefaultOptions
		duration: 400, # in milliseconds (ms), default 400,
		slowdownfactor: 4, # overlap views (higher number is more) or no overlap (1), default 4
		iosdelay: -1, # ms to wait for the iOS webview to update before animation kicks in, default -1
		androiddelay: -1, # same as above but for Android, default -1
		winphonedelay: -1, # same as above but for Windows Phone, default -1,
		fixedPixelsTop: 0, # the number of pixels of your fixed header, default 0 (iOS and Android)
		fixedPixelsBottom: 0, # the number of pixels of your fixed footer (f.i. a tab bar), default 0 (iOS and Android)
		triggerTransitionEvent: '$ionicView.afterEnter', # internal ionic-native-transitions option
		backInOppositeDirection: false # Takes over default back transition and state back transition to use the opposite direction transition to go back
	 
	$ionicNativeTransitionsProvider.setDefaultTransition
		type: 'slide'
		direction: 'left'

	$ionicNativeTransitionsProvider.setDefaultBackTransition
		type: 'slide',
		direction: 'right'

	$urlRouterProvider.otherwise '/login'

	LoopBackResourceProvider.setAuthHeader 'X-Access-Token'
	LoopBackResourceProvider.setUrlBase "#{__API_URL__}/api"

	$httpProvider.interceptors.push 'loader'
	$httpProvider.defaults.useXDomain = true
	
	delete $httpProvider.defaults.headers.common['X-Requested-With']


.run ($geolocation, $ionicHistory, $ionicNativeTransitions, $rootScope, $state, $ionicPlatform, $cordovaStatusbar, $cordovaDialogs, $filter, $connect, $localStorage, $cordovaSplashscreen) ->

	$connect.remember (me) -> 
		setInterval ->
			navigator.splashscreen.hide() if window.cordova
		, 500
		if me
				
			if $state.current.name is 'login'
				$ionicNativeTransitions.stateGo 'authenticated.map'
				, {}
				, 
					type: "flip"
					direction: "left"
					duration: 400
				
				$geolocation.init()
				$geolocation.watch()

		else

			if $state.current.name isnt 'login'
				$ionicNativeTransitions.stateGo 'login'
				, {}
				, 
					type: "flip"
					direction: "left"
					duration: 400

			

	$ionicPlatform.ready ->

		document.addEventListener "pause", ->
			console.log 'pause'

		document.addEventListener "resume", ->
			console.log 'resume'
			__uptime = moment()

		if window.cordova
			$cordovaStatusbar.styleColor('white')
		
			if window.cordova.plugins.Keyboard
				cordova.plugins.Keyboard.disableScroll true

		

		