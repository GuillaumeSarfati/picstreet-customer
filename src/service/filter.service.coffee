angular.module 'picstreet'

.filter 'date', ->
	(date, format) ->
		moment(date).format(format)