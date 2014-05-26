RssTickerView = require './rss-ticker-view'

module.exports =
  rssTickerView: null
  configDefaults:
    feed: "http://rss.cnn.com/rss/edition_world.rss?format=xml"
    icon: "atom://rss-ticker/images/Cnn.svg"
        #"http://upload.wikimedia.org/wikipedia/commons/8/8b/Cnn.svg"
  activate: (state) ->
    @rssTickerView = new RssTickerView(state.RssTickerViewState)

  deactivate: ->
    @rssTickerView.destroy()

  serialize: ->
    RssTickerViewState: @rssTickerView.serialize()
