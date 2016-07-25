angular.module 'picstreet'

.service '$popup', ($rootScope, $localStorage) ->
	welcome: (me) ->

		if $localStorage.welcomeNotification isnt true

			$rootScope.$broadcast 'notification', 
				title: "Welcome on<br>PicStreet !"
				description: """
					Rejoignez les plus beaux spots de Paris, un photographe PicStreet vous y attend ! Un shooting pro sans engagement !
					<br><br>
					Marre des Selfies, des photos ratées, floues ou mal cadrées ? 
					<br><br>
					Grâce à votre smartphone, localisez en temps réel un photographe Picstreet disponible qui immortalisera vos plus beaux moments en amoureux, en famille, entre amis ou en solo !
					<br><br>
					Après votre shooting vous recevrez toutes vos photos sur l'application.
					Achetez seulement vos préférées.
					<br><br>
					Vous recevez ensuite par mail vos clichés en haute qualité.
					<br><br>
					Nous sommes pour l'instant uniquement présents sur Paris. 
					Mais un peu de patience... PicStreet sélectionne actuellement pour vous
					les meilleurs photographes qui seront bientôt disponibles sur toutes vos destinations préférées.
					<br>
					<br>
					<br>

				"""
			$localStorage.welcomeNotification = true

	create: (notification) ->
		$rootScope.$broadcast 'notification', 
			title: notification.title
			description: notification.description