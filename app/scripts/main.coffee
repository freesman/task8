require.config(
  shim:
    underscore:
      exports: '_'
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    epoxy:
      deps: ['underscore', 'jquery', 'backbone']
      exports: 'Epoxy'
    backboneLocalstorage:
      deps: ['backbone']
      exports: 'Store'
  paths:
    jquery: '../../bower_components/jquery/dist/jquery'
    underscore: '../../bower_components/underscore/underscore'
    backbone: '../../bower_components/backbone/backbone'
    epoxy: '../../bower_components/backbone.epoxy/backbone.epoxy'
    backboneLocalstorage: '../../bower_components/backbone.localStorage/backbone.localStorage'
    text: '../../bower_components/text/text'
)

require(
  ['backbone', 'views/appView', 'routers/listRouter']
  (Backbone, AppView, Workspace) ->
    new AppView()
    new Workspace()
    Backbone.history.start()
)
