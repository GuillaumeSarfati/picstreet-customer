gulp            = require 'gulp'
plugins         = require('gulp-load-plugins')()
config					= require('./gulpfile.config.json')

getTask = (name) -> require("./task/#{name}")(gulp, plugins, config)

gulp.task 'index', getTask 'index'
gulp.task 'jade', getTask 'jade'
gulp.task 'less', getTask 'less'
gulp.task 'coffeescript', getTask 'coffeescript'
gulp.task 'img', getTask 'img'
gulp.task 'vendors', getTask 'vendors'
gulp.task 'static', getTask 'static'
gulp.task 'api', getTask 'api'
gulp.task 'i18n', getTask 'i18n'
gulp.task 'icon', getTask 'icon'
gulp.task 'facebook', getTask 'facebook'

gulp.task 'build', [
	'facebook'
	'index'
	'jade'
	'less'
	'coffeescript'
	'vendors'
	'img'
	'api'
	'i18n'
	'icon'
	'static'
]

gulp.task 'watch', ['build'], ->
  gulp.watch ["./#{config.server.path}/**", "./#{config.common.path}/**"], ['api']
  gulp.watch ["./#{config.client.path.src}/index.jade", "./#{config.client.path.src}/main.jade"], ['index']
  gulp.watch "./#{config.client.path.src}/**/*.coffee", ['coffeescript']
  gulp.watch "./#{config.client.path.src}/**/*.less", ['less']
  gulp.watch "./#{config.client.path.src}/**/*.jade", ['jade']
  gulp.watch "./#{config.client.path.src}/**/*.js", ['js']
  gulp.watch "./#{config.client.path.src}/i18n/*.json", ['i18n']
  gulp.watch "./#{config.client.path.src}/static/**", ['static']
