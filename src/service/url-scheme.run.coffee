# handleOpenURL = undefined

# angular.module 'picstreet'

# .run ($state, $ionicModal, $rootScope, Event, $bbModal, $ionicNativeTransitions)->

# 	console.log '$urlSchemes'

# 	urlSchemes = [
# 		{name: 'EAC1', pattern: ///picstreet://([A-Z0-9]{5}$) /// , fn: 'enterActivationCode'}
# 	]

# 	# START FN WHEN URL MATCH TO URLSCHEME PATTERN
# 	handleOpenURL = (url) ->
# 		setTimeout ->
# 			alert 'handleopenurl'
# 			for urlScheme in urlSchemes
# 				if match = urlScheme.pattern.exec url 
# 					handleOpenURL[urlScheme.fn](match, url, urlScheme)
# 		, 0

# 	# ENTER ACTIVATION CODE URL EXAMPLE bb://AZX83
# 	handleOpenURL.enterActivationCode = (match) ->

# 		$bbModal.getActivateMyAccount {}, (modal, modalScope) ->
# 			$rootScope.$broadcast 'accessCode:load:from:sms', match[1], modal
# 			modalScope.show()
