module.exports = (grunt) ->
  
  # track the time it takes to run tasks
  require("time-grunt")(grunt)
  # while watching, only load the dep needed to take the grunt action
  require("jit-grunt")(grunt)
  # explicitly load a tool to fix jade rendering to only the files affected
  grunt.loadNpmTasks "grunt-jade-inheritance"
  # load your tasks, allows them to be in separate files for cleanliness
  tasks = require("load-grunt-configs")(grunt, config: src: "tasks/*.coffee")
  # loads file paths and other build configurations
  buildConfig = require("./build.coffee")(grunt)
  # Merge all tasks and build config together and then init
  grunt.initConfig grunt.util._.extend(tasks, buildConfig)
  
  # compile everything, run server, and watch
  # nothing is smashed, find comments for line numbers in your precompressors
  # should be totally out of your way, just awesome automated-ness
  grunt.registerTask "default", [
    "asciify:headline"
    "clean" 
    "concurrent:dev_StylusJade" 
    "copy"
    "notify:appstarted"
    "connect:dev"
    "browserSync"
    "watch"
  ]

  # serve static dist/ directory
  # run this if you've run prod or dev commands and want to serve the output
  grunt.registerTask "serve", [
    "asciify:headline"
    "shell:open_app"
    "connect:dev"
    "watch"
  ]
  
  # compile everything for debug but don't watch
  # comes in handy if you just want to output a static dev version, no server
  grunt.registerTask "dev", [
    "clean"
    "concurrent:dev_StylusJadeUglify" 
    "copy"
  ]

  grunt.registerTask "test", [
    "concurrent:dev_StylusJadeUglify"
    "concurrent:prod_StylusJadeUglify"
    # "concurrent:shrink"
    "copy"
  ]
  
  # for prod use, minify all js files, html is already compressed 
  # serve it local, no browsersync, just static folder
  # for smoke testing your features before you deploy or commit
  grunt.registerTask "prod", [
    "clean"
    "concurrent:prod_StylusJadeUglify"
    "copy"
    "concurrent:shrink"
    "notify:prod"
    "connect:prod"
    "watch"
  ]

  # hook into Heroku builds with this and the heroku grunt build pack
  # runs your prod tasks
  grunt.registerTask "heroku", [
    "clean"
    "concurrent:prod_StylusJadeUglify"
    "copy"
    "concurrent:shrink"
    "asciify:build"
  ]

  # handy command for opening the project file in sublime
  # so you dont have to remember
  grunt.registerTask "subl", [
    "shell:open_sublime"
  ]
  