angular.module "picstreet.payment"

.controller "paymentCtrl", ($rootScope, $scope, $cordovaDialogs, CreditCard, $filter, Customer) ->

	Stripe.setPublishableKey 'pk_test_cd9qs7aO7l2730zspzQJkAki'
	
	# $scope.cards = $rootScope.me.creditCards

	$scope.deleteCard = (card) ->
		
		$cordovaDialogs.confirm $filter('translate')('deleteCreditCard'), 'Bottle Booking', ['Ok', 'Cancel']
		.then (index) ->

			button = if window.cordova then 2 else 1
			
			if index is button
			
				$scope.cards.splice $scope.cards.indexOf(card), 1
				
				CreditCard.deleteById id: card.id
				.$promise
				.then (success) -> console.log 'success : ', success
				.catch (err) -> console.log 'err : ', err


	scanCard = ->

		CardIO.scan

			requireExpiry: true
			requireCVV: true
			guideColor: '#ff0061'
			hideCardIOLogo: true
			useCardIOLogo: true

		, scanSuccess
		, scanErr

	scanCardMock = ->
		scanSuccess
			# card_number:'4000000000000341' # Charge fail
			card_number: '4242424242424242'
			cvv: '874'
			expiry_month: 4
			expiry_year: 2019
			
	scanErr = (err) ->
		$cordovaDialogs.alert 'An error occured, please try again or use another credit card.', 'PicStreet', 'Ok'
		$scope.$emit 'loading:hide', force: true

	scanSuccess = (scan) ->
		$scope.$emit 'loading:unlock', force: true
		$scope.$emit 'loading:show', force: true
		
		
		newCard = 
			last4: scan.cardNumber.substr(scan.cardNumber.length - 4)
			expMonth: scan.expiryMonth
			expYear: scan.expiryYear
			brand: scan.cardType

		$rootScope.me.creditCards = [] unless $rootScope.me.creditCards
		$rootScope.me.creditCards.push newCard

		Stripe.card.createToken
			number: scan.cardNumber
			cvc: scan.cvv
			exp_month: scan.expiryMonth
			exp_year: scan.expiryYear

		, createCard

	createCard =  (status, response) ->
		
		console.log 'STRIPE STATUS : ', status
		console.log 'STRIPE RESPONSE : ', response

		$scope.$emit 'loading:hide', force: true
		$scope.$emit 'loading:lock', force: true

		newCard = 
			stripeInitialToken: response.id
			last4: response.card.last4
			type: response.card.type
			expMonth: response.card.exp_month
			expYear: response.card.exp_year
			country: response.card.country
			customerId: $rootScope.me.id
			customerStripeId: $rootScope.me.stripeId

		console.log 'NEW CARD : ', newCard
		
		CreditCard.create newCard

		.$promise
		.then (card) -> 

			# $rootScope.me.creditCards = [] unless $rootScope.me.creditCards
			# $rootScope.me.creditCards.push card
			$scope.makeDefaultCard card unless $rootScope.me.defaultCreditCard

		.catch (err) ->
			
			$scope.creditCards.splice $scope.creditCards.length - 1, 1
			$cordovaDialogs.alert 'An error occured, please try again or use another credit card', 'PicStreet', 'Ok' 

	$scope.makeDefaultCard = (card) ->
		$rootScope.me.defaultCreditCard = card
		$rootScope.me.defaultCreditCardId = card.id

		Customer.prototype$updateAttributes
			id: $rootScope.me.id
		,	defaultCreditCardId: card.id
		.$promise
		.then (err, success) ->
			console.log 'default credit card success : ', err, success
		
		.catch (err) -> 
			console.log 'err : ', err

	$scope.scanCard = ->

		$scope.$emit 'loading:show', force: true

		scanCard()			if window.cordova
		scanCardMock() 	unless window.cordova

	


