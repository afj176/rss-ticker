{$, $$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
subscriptions = new CompositeDisposable
feed = require('feed-read')
request = require('request')

# TODO: Add ticker plugin to Atom.$, haven't found an easier solution yet
#   Find how to add coffeescript jquery plugins to Atom.$

{Ticker, tickerName} = require './ticker'

$.fn[tickerName] = (option, args...) ->
  @each ->
    $this = $(this)
    data = $.data(this, "plugin_" + tickerName)
    options = typeof option is "object" and option
    $this.data "plugin_" + tickerName, (data = new Ticker(this, options))  unless data

    # if first argument is a string, call silimarly named function
    data[option].apply data, Array::slice.call(args, 1)  if typeof option is "string"
    return

module.exports =
class RssTickerView extends View

  @content: ->
    @div id: 'rss-ticker', class:'ticker-box inline-block', =>
      @img class:'rss-icon', src: atom.config.get('rss-ticker.icon'), width:'19px', height:'18px'
      @div class:'rss-news-wrapper', =>
        @ul id:'news', class:'news-list inset-panel padded inline-block-tight', outlet: "news"

  initialize: ->

    atom.commands.add 'atom-workspace', 'rss-ticker:toggle': ->
      @toggle()

    @toggle()

    minutes = atom.config.get 'rss-ticker.refresh'

    if minutes > 0
      refresh = minutes * 60 * 1000
      setInterval (=>
        statusBar = document.querySelector('status-bar')
        if statusBar
          @build(statusBar)
        return
      ), refresh


  destroy: ->
    @detach()

  toggle: ->

    if @hasParent() then @detach() else @attach()

  addNews: (title, link, description) =>

    if(title)
      listItem = $('<li></li>').attr(class: 'news-list-item')
      linkItem = $('<a></a>').attr(href: link, class: 'news-list-link').text(title)
      @news.append(listItem.html(linkItem))
      description = (if (description) then description else "No description")
      subscriptions.add atom.tooltips.add(linkItem, {title: description })


  articles: null

  build: (statusBar) =>
    this.find('.news-list-item').remove()
    @addNews 'loading.....', '#', 'loading....'
    statusBar.addRightTile(item: this, priority: 100)
    passArticles = (articles) =>
      this.find('.news-list-item').remove()
      _i = 0
      _len = articles.length
      while _len > _i
        {title, link, content} = articles[_i]
        description = content.replace(/(<([^>]+)>)/ig,"")  if typeof content isnt "undefined"
        @addNews title, link, description
        _i++
        statusBar.addRightTile(item: this, priority: 100) if _len is _i

        @news.newsTicker()

    options =
      url: atom.config.get('rss-ticker.feed')
      headers: 'User-Agent': 'request'
    request options, (error, response, body) =>
      if !error and response.statusCode == 200
        isFeed = feed.identify(body)
        if isFeed
          feed[isFeed] body, (err, articles) =>
            # if er
            throw err if err
            # take articles and build list item
            @articles = articles
            passArticles @articles






  attach: =>
    statusBar = document.querySelector('status-bar')
    if statusBar

      @build(statusBar)

    else
      subscriptions.add atom.packages.once('activated', @attach)
