define(
  ['jquery', 'underscore', 'backbone', 'epoxy', 'text!templates/song.html', 'collections/songs', 'common']
  ($, _, Backbone, Epoxy, songTemplate, SongsCollection, Common) ->
    ItemView = Backbone.Epoxy.View.extend(
      el: songTemplate
      bindings: 'data-bind'
      setterOptions: save:true
      events:
        'dblclick .view'          : 'edit'
        'click .destroy'          : 'destroyItem'
        'keypress .editing .edit' : 'updateOnEnter'
        'keydown .editing .edit'  : 'revertOnEscape'
        'blur .editing .edit'     : 'close'
        'click .view'             : 'routeItem'
      initialize: ->
        this.listenTo(this.model, 'filterResetItem', this.filterResetItem) # reset filtered element
        this.listenTo(this.model, 'filterItem', this.filterItem) # check every element = filtered?
      destroyItem: ->
        this.model.destroy()
        Backbone.history.loadUrl(Backbone.history.getFragment())
      edit: (e) ->
        this.$myTd = $(e.currentTarget) # clicked <td>element</td>
        this.$myInput = this.$myTd.children('.edit') # clicked td`s child input
        this.$myValue = this.$myTd.children('span').text() # clicked td`s child span
        this.$myTd.addClass('editing')
        this.$myInput.focus()
      updateOnEnter: (e) ->
        if e.which == Common.ENTER_KEY
          this.close()
      revertOnEscape: (e) ->
        if e.which  == Common.ESC_KEY
          this.close('esc')
      close: (switcher) ->
        if !this.$myInput.val() or switcher == 'esc'
          this.$myInput.val(this.$myValue)
          this.$myInput.keyup()
        this.$myTd.removeClass('editing')
        Backbone.history.loadUrl(Backbone.history.getFragment()) # refresh route cur item after editing
      toggleFiltered: ->
        this.model.toggle()
      filterItem: ->
        titleCheck = this.checkAndTest($('#titleFilter').val(), this.model.get('title'))
        authorCheck = this.checkAndTest($('#authorFilter').val(), this.model.get('author'))
        genreCheck = this.checkAndTest($('#genreFilter').val(), this.model.get('genre'))
        if titleCheck and authorCheck and genreCheck
          if !this.model.get('filtered')
            this.toggleFiltered()
            this.visibleOff(false)
        else
          if this.model.get('filtered')
            this.toggleFiltered()
          this.visibleOff(true)
      checkAndTest: (inputVal, modelVal) -> # try find filter value in element
        if inputVal
          inputVal = inputVal.toLowerCase()
          modelVal = modelVal.toLowerCase()
          tester = modelVal.indexOf(inputVal) + 1
          if !tester then return false
        return true
      filterResetItem: ->
        if this.model.get('filtered') then this.toggleFiltered()
        if this.$el.hasClass('filterOut') then this.visibleOff(false)
      visibleOff: (visible) -> # toggle visible on filtered elements
        this.$el.toggleClass('filterOut', visible)
      routeItem: -> # route to item on click some attribute in list
        songMass = SongsCollection.toArray()
        id = 0
        while songMass[id].cid != this.model.cid
          id++
        id++
        Backbone.history.navigate('items/' + id, true)
    )
    return ItemView
)
