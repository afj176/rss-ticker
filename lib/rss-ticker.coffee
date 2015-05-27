RssTickerView = require './rss-ticker-view'

module.exports =
  rssTickerView: null
  config:
    feed:
      type: 'string'
      default: 'http://rss.cnn.com/rss/edition_world.rss?format=xml'
      description: ''
    icon:
      type: 'string'
      default: 'atom://rss-ticker/images/Cnn.svg'
      description: 'Icon for status bar rss feed can be svg,png, gif, jpg'
    refresh:
      type: 'integer'
      default: 0
      description: 'How many minutes until content refresh'


  activate: (state) ->
    tickerStatus = =>
      @rssTickerView = new RssTickerView(state.RssTickerViewState)
      return
    atom.packages.onDidActivateInitialPackages -> tickerStatus()
  serialize: ->
    RssTickerViewState: @rssTickerView.serialize()
  deactivate: ->
    @rssTickerView?.destroy()
