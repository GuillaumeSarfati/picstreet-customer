angular.module 'picstreet.directives'

.directive 'notification', ->
	restrict: 'E'
	templateUrl: 'notification.view.html'
	link: ($scope, $element, $attr) ->

		$scope.title = 'Title'
		$scope.description = 'hjkdh sdhsdbfjhsd fjh sdhjf jsdh fhjs djf jsdgf sd fgj sgjf jgs dfgjs dgfj sgjdf hjsd fjgs dfjg sfd jgs fjs'
		
		backdrop = document.querySelector '.notification-backdrop'
		notification = document.querySelector '.notification-content'

		$scope.$on 'notification', (e, notification) ->
			console.log notification
			$scope.title = notification.title
			$scope.description = notification.description
			$scope.show()

		$scope.hide = ->
			console.log 'hide'
			notification.classList.remove 'notification-show'
			notification.classList.add 'notification-hide'
			backdrop.classList.remove 'backdrop-show'
			backdrop.classList.add 'backdrop-hide'

		$scope.show = ->
			console.log 'show'
			notification.classList.remove 'notification-hide'
			notification.classList.add 'notification-show'
			backdrop.classList.remove 'backdrop-hide'
			backdrop.classList.add 'backdrop-show'

