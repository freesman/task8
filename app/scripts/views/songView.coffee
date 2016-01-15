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
      #initialize: ->
      destroyItem: ->
        this.model.destroy()
      edit: (e) ->
        this.$myTd = $(e.currentTarget) # clicked <td>element</td>
        this.$myInput = this.$myTd.children('.edit') # clicked td`s child input
        this.$myValue = this.$myTd.children('span').text() # clicked td`s child span
        this.$myTd.addClass('editing')
        this.$myInput.focus()
        console.log(this.$myValue)
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
    )
    return ItemView
)
