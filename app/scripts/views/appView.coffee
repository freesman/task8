define(
  ['jquery', 'underscore', 'backbone', 'epoxy', 'collections/songs', 'views/songView']
  ($, _, Backbone, Epoxy, SongsCollection, ItemView) ->
    AppView = Backbone.Epoxy.View.extend(
      el: '#mainBlock'
      collection: SongsCollection
      itemView: ItemView
      initialize: ->
        this.collection.fetch()
      events:
        'click #addBut'    : 'addSong'
        'click #delAllBut' : 'clearList'
      addSong: ->
        this.collection.create(this.newAttributes())
        this.$('#songTitle').val('')
        this.$('#songAuthor').val('')
        this.$('#songGenre').val('')
      newAttributes: ->
        return {} =
          title: this.$('#songTitle').val()
          author: this.$('#songAuthor').val()
          genre: this.$('#songGenre').val()
      clearList: ->
        _.invoke(SongsCollection.toArray(), 'destroy')
    )
    return AppView
)
