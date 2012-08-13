define ->
  Backbone.Model.extend
    defaults:
      name: ''
      currentWeek: 0
      rowsPlayed: 0
      rowsPerWeek: 10
      rowPrice: 1
      gameRunning: false
      sleepTime: 300
      moneyWon: 0
          
    initialize: ->
      startDate = new Date
      @set {
        startDate: startDate,
        startDateString: @getFinnishDateString(startDate),
        currentDate: startDate,
        currentDateString: @getFinnishDateString(startDate)
        winnings: [
          ["7 oikein", 15380937, 2000000, 0],
          ["6+1 oikein", 1098638, 20000, 0],
          ["5+2 oikein", 732426, 3000, 0],
          ["6 oikein", 73243, 1500, 0],
          ["5+1 oikein", 12207, 115, 0],
          ["4+2 oikein", 14649, 80, 0],
          ["5 oikein", 1684, 45, 0],
          ["4+1 oikein", 505, 17, 0],
          ["4 oikein", 108, 9, 0],
          ["3+2 oikein", 1010, 5, 0],
          ["3+1 oikein", 54, 1, 0],
          ]
      }
      
    validate: (attribs) ->
      if isNaN(Number(attribs.rowsPerWeek))
        return "Rivien määrän on oltava luku"
      if attribs.rowsPerWeek < 0
        return "Rivien määrän on oltava positiivinen"
      if attribs.rowsPerWeek > 100000
        return "Rivien määrän on oltava korkeintaan 100000"
    
    getFinnishDateString: (date) ->
      return date.getDate() + "." + (date.getMonth() + 1) + "." + date.getFullYear()
    
    start: ->
      @set "gameRunning", true
      
    stop: ->
      @set "gameRunning", false
    
    playWeek: ->
      @set {
        currentWeek: @get("currentWeek") + 1,
        currentDate: new Date(@get("currentDate").getTime() + (7 * 24 * 60 * 60 * 1000)),
        currentDateString: @getFinnishDateString(@get("currentDate")),
        rowsPlayed: @get("rowsPlayed") + @get("rowsPerWeek")
      }
      @raffle()
    
    checkForLotteryWin: (probability) ->
      randomNumber = Math.floor(Math.random() * probability)
      # console.log randomNumber
      randomNumber == 1
    
    incrementAttribute: (attribute, increment) ->
      @set attribute, @get(attribute) + increment
    
    raffle: ->
      for [1..@get("rowsPerWeek")]
        for winning in @get "winnings"
          if @checkForLotteryWin winning[1]
            @set "moneyWon", @get("moneyWon") + winning[2]
            winning[3] = winning[3] + 1
            break

    isRunning: ->
      @get "gameRunning"