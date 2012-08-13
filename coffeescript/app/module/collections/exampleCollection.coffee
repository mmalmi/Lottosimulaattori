define ['app/module/models/lottoPeli'], (LottoPeli) ->
  Backbone.Collection.extend
    model: LottoPeli
    initialize: ->
      @