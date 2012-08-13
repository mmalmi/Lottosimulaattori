define [
  "app/module/views/skeletorView"
  "text!app/module/templates/exampleTemplate.html"
  "app/module/models/lottoPeli"
], (SkeletorView, Template, LottoPeli) ->
  SkeletorView.extend
    el: "#example-view"
    template: _.template(Template)

    events: {
      "click #play" : "playButtonPressed",
      "click #reset" : "resetButtonPressed",
      "change #rowsPerWeek" : "settingsChanged"
      }

    settingsChanged: ->
      @model.set({"rowsPerWeek" : @$("#rowsPerWeek").val()})
      console.log "rowsPerWeek: " + @model.get("rowsPerWeek")

    resetButtonPressed: ->
      @model = new LottoPeli
      @render()

    playButtonPressed: ->
      if @model.isRunning()
        console.log "stopping game"
        @model.stop()
        clearTimeout this.timeoutID
      else
        console.log "starting game"
        @model.start()
        this.runGame()
      @render()

    runGame: ->
      return unless @model.isRunning()
      @model.playWeek()
      this.timeoutID = setTimeout (=> this.runGame()), @model.get("sleepTime")
      @render()

    initialize: ->
      console.log "init example view"
      @model = new LottoPeli
      @render()

    render: ->
      @$el.html(@template(@model.toJSON()))
      return this
