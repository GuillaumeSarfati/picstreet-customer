angular.module "picstreet.pictures"

.controller "picturesCtrl", ($pxModal, $timeout, $rootScope, $scope, $cordovaDialogs, $filter, Album, PromotionCode, UsedPromotionCode, Purchase) ->

	$scope.api = __API_URL__
	$scope.albums = $rootScope.me.albums
	$scope.animateFlip = false
	$scope.currentPicture = undefined
	$scope.total = 0
	$scope.showPayment = undefined

	$scope.purchase = {}

	console.log $rootScope.me

	$scope.card = $rootScope.me.defaultCreditCard

	$scope.switch = (picture=undefined) ->
		console.log 'PICTURE : ', picture
		if picture

			$scope.currentPicture = picture 
			$scope.currentPictureUrl = "#{__API_URL__}/api/Buckets/ppxpictures/download/#{$scope.currentPicture.name}"
			
			img = new Image()
			img.src = $scope.currentPictureUrl

		else

			$scope.currentPicture = undefined
			$scope.currentPictureUrl = undefined
			
		$scope.animateFlip = !$scope.animateFlip
		$scope.$apply() unless $scope.$$phase


	$scope.bookPicture = ($event, picture) ->
		$event.stopPropagation()
		$event.preventDefault()

		
		if picture.booking is true
			picture.booking = false
			$scope.total -=  6
		else
			picture.booking = true
			$scope.total +=  6

	$scope.goToPayment = ->
		
		purchase = 
			
			pictures: []
			price: 0
			customerId: $rootScope.me.id
			


		for album in angular.copy $scope.albums
			
			for picture in album.pictures
				if picture.booking
					purchase.pictures.push picture
					purchase.price += picture.price


		if purchase.price
			$scope.showPayment = true 
			$scope.purchase = purchase
			$scope.$apply() unless $scope.$$phase

	$scope.addPromotionCode = ->

		$cordovaDialogs.prompt 'Enter your promotion code', 'PicStreet', ['Cancel', 'Try']
		.then (result) ->
			PromotionCode.findOne filter: where: code: result.input1
			.$promise
			.then (promotionCode) -> 

				UsedPromotionCode.findOne
					where:
						promotionCodeId: promotionCode.id
						customerId:$rootScope.me.id
				.$promise
				.then (success) -> $cordovaDialogs.alert 'Sorry you have already use this promotion code', 'PicStreet', 'Ok'
				.catch (err) -> 
					console.log 'err : ', err
					$scope.purchase.promotionCodeId = success.id
					$scope.purchase.price -= success.amount
					$scope.$apply() unless $scope.$$phase

			.catch (err) -> $cordovaDialogs.alert 'Sorry this code is expired.', 'PicStreet', 'Ok'
			

	$scope.cancel = (purchase) ->
		console.log 'cancel'

		$scope.showPayment = false
		$scope.$apply() unless $scope.$$phase

	$scope.buy = (purchase) ->
		purchase.creditCardId = $scope.card.id

		Purchase.create purchase
		.$promise
		.then (success) -> 
			console.log 'success : ', success
			for picture in success.pictures
				$scope.updatePicture
					pictureId: picture.id
					albumId: picture.albumId
			
			$scope.total = 0
			$scope.showPayment = false
			$scope.$apply() unless $scope.$$phase

			$cordovaDialogs.alert 'Thanks for your purchase, Your photos will be sent to you by email.', 'PicStreet', 'Ok'

		.catch (err) -> 

			$cordovaDialogs.alert 'Your card was declined.', 'PicStreet', 'Retry with another card'
			$scope.openModalPaymentMethods()
			
	$scope.updatePicture = (opts={}) ->
		console.log 'update picture : ', opts
		console.log 'me albums : ', $rootScope.me.albums
		for album in $rootScope.me.albums
			console.log album.id, opts.albumId
			if album.id is opts.albumId
				console.log 'if album'
				for picture in album.pictures
					if picture.id is opts.pictureId
						console.log 'if picture'
						console.log 'update picture : ', picture
						picture.purchase = true
						picture.booking = false
						break
				break

	$rootScope.$on 'creditCard:change', (e, card) ->
		console.log 'receive credit card root'
		$scope.card = card
		$scope.$apply() unless $scope.$$phase

	$scope.openModalPaymentMethods = ->
		console.log 'OPEN MODAL'
		$pxModal.getPaymentMethods
			changeCard: (card) ->
				console.log 'CHANGE CARD : ', card
				@$emit 'creditCard:change', card
				@modal.hide()
		, (modal, modalScope) ->
			modalScope.show()

		



