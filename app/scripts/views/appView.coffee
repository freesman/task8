define(
  ['jquery', 'underscore', 'backbone', 'epoxy', 'collections/songs', 'views/songView']
  ($, _, Backbone, Epoxy, SongsCollection, ItemView) ->
    AppView = Backbone.Epoxy.View.extend(
      el: '#mainBlock'
      collection: SongsCollection
      itemView: ItemView
      initialize: ->
        this.listenTo(this.collection, 'filter', this.filterList)
        this.listenTo(SongsCollection, 'filterReset', this.filterReset)
        this.collection.fetch()
      events:
        'click #addBut'    : 'addSong'
        'click #delAllBut' : 'clearList'
        'click #filterBut' : 'routeFilter'
        'click #resetBut'  : 'routeReset'
        'click .close'     : 'closeAlert'
      addSong: ->
        if !this.$('#songTitle').val() or !this.$('#songAuthor').val() or !this.$('#songGenre').val()
          this.alert('add')
        else
          this.collection.create(this.newAttributes())
          this.$('#songTitle').val('')
          this.$('#songAuthor').val('')
          this.$('#songGenre').val('')
          Backbone.history.loadUrl(Backbone.history.getFragment())
      newAttributes: ->
        return {} =
          title: this.$('#songTitle').val()
          author: this.$('#songAuthor').val()
          genre: this.$('#songGenre').val()
      clearList: ->
        _.invoke(SongsCollection.toArray(), 'destroy')
      routeFilter: -> # route on click filter button
        title = this.$('#titleFilter').val()
        author = this.$('#authorFilter').val()
        genre =  this.$('#genreFilter').val()
        if !title and !author and !genre
          this.alert('filter')
          return false
        filterStr = 'search?'
        if title then filterStr += '/title=' + title
        if author then filterStr += '/author=' + author
        if genre then filterStr += '/genre=' + genre
        Backbone.history.navigate(filterStr, true)
      filterList: ->
        this.alert('alert')
        this.collection.each((song)->song.trigger('filterItem'))
      routeReset: ->
        Backbone.history.navigate('', true)
      filterReset: ->
        this.$('#titleFilter').val('')
        this.$('#authorFilter').val('')
        this.$('#genreFilter').val('')
        this.closeAlert()
        this.$('#alertFilter').fadeOut(100)
        this.collection.each((song)->song.trigger('filterResetItem'))
      alert: (switcher) -> # show <!> when filter list
        switch switcher
          when 'add'
            this.$('#alertWarnFilter').fadeOut(0)
            if !this.$('#alertWarnAdd').css('display', 'block')
              this.$('#alertWarnAdd').fadeIn(100)
          when 'filter'
            this.$('#alertWarnAdd').fadeOut(0)
            if !this.$('#alertWarnFilter').css('display', 'block')
              this.$('#alertWarnFilter').fadeIn(100)
          when 'alert'
            this.closeAlert()
            if !this.$('#alertFilter').css('display', 'block')
              this.$('#alertFilter').fadeIn(100)
      closeAlert: ->
        this.$('#alertWarnAdd').fadeOut(0)
        this.$('#alertWarnFilter').fadeOut(0)
    )
    return AppView
)
