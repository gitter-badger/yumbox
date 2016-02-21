# ## Prerender all pages
#
# This uses PhantomJS to prerender for search engine crawling. You should use the **[gulp task](./prerender.html)** to call it but if you wanna try it and see how it works execute something like this:
# ```
#   phantomjs phantom.coffee 'http://localhost:3000' './snapshots' -1
# ```
#
Page    = require 'webpage'
fs      = require 'fs'
args    = require('system').args;

# ### Home Page
#
# Set **array** of urls, from where phantom should start crawling. Usually it is only home page
#
root = if args[1].indexOf('#') > -1
  [args[1]]
else
  ["#{args[1]}/#!/"]

# ### Prerender Destination
#
# Update this path if you are willing to store files in a different location
#
saveDir = args[2] || "./snapshots"

# ### How deep should it crawl
#
# -1 = unlimited
# 0  = none
# 1  = 1 level
# 2  = 2 level
# N  = N level
#
levels = args[3] || -1
levels = parseInt levels

# ## Save snapshots
#
# Create a snapshot of page as html file in destination folder
#
# @method
# @private
# @param {String} uri    Url of the page which be converted relative to saveDir variable
# @param {String} body   Page content to save in the path
#
saveSnapshot = (uri, body) ->
  lastIdx = uri.lastIndexOf '#!/'
  path = uri.substring(lastIdx + 2, uri.length);
  path = "/index.html" if path == '/'
  path += ".html" if path.indexOf('.html') == -1
  filename = saveDir + path
  console.log "saving as '#{filename}'"
  fs.write filename, body, 'w'


# ## Wait For Page Load
#
# Wait for complete page load and
#
#
waitFor = (testFx, onReady, timeOutMillis) ->
  timeOutMillis ||= 3000
  maxtimeOutMillis = 7000
  start = new Date().getTime()
  condition = false
  interval = setInterval (->
    if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition )
      condition = testFx()
    else
      onReady()
      clearInterval(interval)
    ), 250

# ## Crawler
#
# Recursive parser to parse the current url and find all other pages to create snapshot of them. Also avoid parsing already parsed URLs in current session.
#
# @method
# @public
# @param {Integer} idx     Current index of page which is about to be parsed
# @param {Array}   pages   List of urls which should be parsed
#
crawlPage = (idx, pages, levels) ->
  if (idx < pages.length && levels!=0) 
    --levels
    uri = pages[idx]
    page = Page.create()
    page.settings.userAgent = 'SpecialAgent'
    page.viewportSize = {
      width: 1000
      height: 800
    }
    page.open uri, (status) ->
      if status != "success"
        console.log "Unable to access network"
      else
        waitFor ->
          page.evaluate ->
            return $('body').is("[phantom='true']")
        , ->
          if levels!=0
            urls = page.evaluate( (uri) ->
              links = document.querySelectorAll('a[href]')
              return [] if links.lenght < 1
              return [].map.call links, (link) ->
                href = link.getAttribute 'href'
                return null if /\/panel/.test(href) || /http\:/.test(href) || /www\./.test(href)

                # ## Url Resolver
                #
                # Try to create absolute path for any give url
                #
                # @method
                # @private
                # @param {String} base  Base url to be used to create absolute url, it can be dirty
                # @param {String} url   Url which be converted to absolute url.
                #
                # @example
                #   resolve 'http://server.com/users', 'experiences'
                #   // 'http://server.com/experiences'
                #
                resolve = (base, url) ->
                  base_regex = /^https?:\/\/[^\/]+/i
                  base = base.match(base_regex)[0]
                  url = '/'+url if url.charAt(0) isnt '/'
                  return base + url

                absUrl = resolve uri, href
                link.setAttribute 'href', absUrl
                return absUrl
            , uri)
          else
            urls = []
          saveSnapshot( uri, page.content)
          for url in urls
            if pages.indexOf(url) < 0 && url != null && url.length > 0
              pages.push url
          crawlPage( idx+1, pages, levels)
  else
    phantom.exit()

crawlPage(0, root, levels)
