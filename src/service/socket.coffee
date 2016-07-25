angular.module 'picstreet'

.factory '$socket', ($rootScope, LoopBackAuth) ->

	service = 

		instance: (url=__API_URL__) ->

			id = LoopBackAuth.accessTokenId
			userId = LoopBackAuth.currentUserId

			socket = io.connect url
			
			socket.on 'photographer:position:update', (data) ->
				$rootScope.$emit 'photographer:position:update', data

			return socket

	return service
