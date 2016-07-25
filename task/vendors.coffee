mainBowerFiles  = require 'main-bower-files'

module.exports = (gulp, plugins, config) ->
  ->
    files = mainBowerFiles
      paths:
        bowerJson: "./#{config.bower.json}"
        bowerDirectory: "./#{config.bower.directory}"

    filter = plugins.filter '**/*.js'

    gulp.src files
    .pipe plugins.plumber(errorHandler: plugins.notify.onError('Error: '))
    .pipe filter
    .pipe plugins.concat 'vendors.js'
    .pipe gulp.dest "./#{config.client.path.build}/js"
