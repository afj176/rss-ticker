"use strict"
###
risq / jquery-advanced-news-ticker in coffescipt
http://risq.github.io/jquery-advanced-news-ticker
###

{$} = require 'atom-space-pen-views'

defaults =
  row_height: 20
  max_rows: 3
  speed: 400
  duration: 2500
  direction: "up"
  autostart: 1
  pauseOnHover: 1
  nextButton: null
  prevButton: null
  startButton: null
  stopButton: null

  hasMoved: ->

  movingUp: ->

  movingDown: ->

  start: ->

  stop: ->

  pause: ->

  unpause: ->


module.exports.Ticker = Ticker = (element, options) ->
  @element = element
  @$el = $(element)
  @options = $.extend({}, defaults, options)
  @_defaults = defaults
  @_name = tickerName
  @moveInterval
  @state = 0
  @paused = 0
  @moving = 0
  @init()  if @$el.is("ul, ol")
  return

module.exports.tickerName = tickerName = "newsTicker"

Ticker:: =
  init: ->
    @$el.height(@options.row_height * @options.max_rows).css overflow: "hidden"
    @checkSpeed()
    noNext = typeof (@options.nextButton[0]) isnt "undefined"
    noPrev = typeof (@options.prevButton[0]) isnt "undefined"
    noStop = typeof (@options.stopButton[0]) isnt "undefined"
    noStart = typeof (@options.startButton[0]) isnt "undefined"
    if @options.nextButton and noNext
      @options.nextButton.click ((e) ->
        @moveNext()
        @resetInterval()
        return
      ).bind(this)
    if @options.prevButton and noPrev
      @options.prevButton.click ((e) ->
        @movePrev()
        @resetInterval()
        return
      ).bind(this)
    if @options.stopButton and noStop
      @options.stopButton.click ((e) ->
        @stop()
        return
      ).bind(this)
    if @options.startButton and noStart
      @options.startButton.click ((e) ->
        @start()
        return
      ).bind(this)
    if @options.pauseOnHover
      @$el.hover (->
        @pause()  if @state
        return
      ).bind(this), (->
        @unpause()  if @state
        return
      ).bind(this)
    @start()  if @options.autostart
    return

  start: ->
    unless @state
      @state = 1
      @resetInterval()
      @options.start()
    return

  stop: ->
    if @state
      clearInterval @moveInterval
      @state = 0
      @options.stop()
    return

  resetInterval: ->
    if @state
      clearInterval @moveInterval
      @moveInterval = setInterval((->
        @move()
        return
      ).bind(this), @options.duration)
    return

  move: ->
    @moveNext()  unless @paused
    return

  moveNext: ->
    if @options.direction is "down"
      @moveDown()
    else @moveUp()  if @options.direction is "up"
    return

  movePrev: ->
    if @options.direction is "down"
      @moveUp()
    else @moveDown()  if @options.direction is "up"
    return

  pause: ->
    @paused = 1  unless @paused
    @options.pause()
    return

  unpause: ->
    @paused = 0  if @paused
    @options.unpause()
    return

  moveDown: ->
    unless @moving
      @moving = 1
      @options.movingDown()
      mt = "marginTop"
      mTop = "-" + @options.row_height + "px"
      ll = "li:last"
      @$el.children(ll).detach().prependTo(@$el).css(mt, mTop).animate
        marginTop: "0px"
      , @options.speed, (->
        @moving = 0
        @options.hasMoved()
        return
      ).bind(this)
    return

  moveUp: ->
    unless @moving
      @moving = 1
      @options.movingUp()
      element = @$el.children("li:first")
      element.animate
        marginTop: "-" + @options.row_height + "px"
      , @options.speed, (->
        element.detach().css("marginTop", "0").appendTo @$el
        @moving = 0
        @options.hasMoved()
        return
      ).bind(this)
    return

  updateOption: (option, value) ->
    if typeof (@options[option]) isnt "undefined"
      @options[option] = value
      if option is "duration" or option is "speed"
        @checkSpeed()
        @resetInterval()
    return

  add: (content) ->
    @$el.append $("<li>").html(content)
    return

  getState: ->
    if @paused # 2 = paused
      2
    else # 0 = stopped, 1 = started
      @state

  checkSpeed: ->
    durationGspeed = @options.duration < (@options.speed + 25)
    @options.speed = @options.duration - 25  if durationGspeed
    return

  destroy: ->
    @_destroy() # or this.delete; depends on jQuery version
    return
