{$, $$, View} = require 'atom'

feed = require("feed-read")

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
    #@attach()
    atom.workspaceView.command "rss-ticker:toggle", => @toggle()
    @toggle()
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
      linkItem.setTooltip description

  articles: null

  attach: =>
    statusBar = atom.workspaceView.statusBar
    if statusBar

      passArticles = (articles) =>
        _i = 0
        _len = articles.length
        while _len > _i
          {title, link, content} = articles[_i]
          description = content.replace(/<img[^>]*>/g, "")  if typeof content isnt "undefined"
          @addNews title, link, description
          _i++
          statusBar.prependRight this if _len is _i
          @news.newsTicker()

      feed atom.config.get('rss-ticker.feed'), (err, articles) =>
        # if er
        throw err if err
        # take articles and build list item
        @articles = articles
        passArticles @articles

    else
      @subscribe(atom.packages.once('activated', @attach))
