#https://github.com/larryosborn/JSONP
`(function(){var e,n,r,t,o,d,u,a;r=function(e){return window.document.createElement(e)},t=window.encodeURIComponent,u=Math.random,e=function(e){var t,d,u,l,i,c,s;if(e=e?e:{},c={data:e.data||{},error:e.error||o,success:e.success||o,beforeSend:e.beforeSend||o,complete:e.complete||o,url:e.url||""},c.computedUrl=n(c),0===c.url.length)throw new Error("MissingUrl");return l=!1,c.beforeSend({},c)!==!1&&(u=e.callbackName||"callback",d=e.callbackFunc||"jsonp_"+a(15),t=c.data[u]=d,window[t]=function(e){return window[t]=null,c.success(e,c),c.complete(e,c)},s=r("script"),s.src=n(c),s.async=!0,s.onerror=function(e){return c.error({url:s.src,event:e}),c.complete({url:s.src,event:e},c)},s.onload=s.onreadystatechange=function(){return l||this.readyState&&"loaded"!==this.readyState&&"complete"!==this.readyState?void 0:(l=!0,s.onload=s.onreadystatechange=null,s&&s.parentNode&&s.parentNode.removeChild(s),s=null)},i=i||window.document.getElementsByTagName("head")[0]||window.document.documentElement,i.insertBefore(s,i.firstChild)),{abort:function(){return window[t]=function(){return window[t]=null},l=!0,s&&s.parentNode?(s.onload=s.onreadystatechange=null,s&&s.parentNode&&s.parentNode.removeChild(s),s=null):void 0}}},o=function(){return void 0},n=function(e){var n;return n=e.url,n+=e.url.indexOf("?")<0?"?":"&",n+=d(e.data)},a=function(e){var n;for(n="";n.length<e;)n+=u().toString(36)[2];return n},d=function(e){var n,r,o;n=[];for(r in e)o=e[r],n.push(t(r)+"="+t(o));return n.join("&")},"undefined"!=typeof define&&null!==define&&define.amd?define(function(){return e}):"undefined"!=typeof module&&null!==module&&module.exports?module.exports=e:this.JSONP=e}).call(this);`

base = 'http://localhost:3000'
get = (id) -> document.getElementById id
html = (element, html) -> element.innerHTML = html

load = (path, callback, data = {}) ->
  JSONP {
    url: configs.base + path + "?jsonp&uid=#{configs.uid}"
    data: data
    success: (content) -> callback(content.replace(/\\"/g, '"'))
  }

configs =
  tags:
    script: 'tipi-script'
    guests: 'tipi-plugin-guests'
  base: null
  uid: null
  plugins: []

plugin =
  detect: ->
    script = get configs.tags.script
    url = document.createElement 'a'
    url.href = script.src
    base = url.protocol + '//' + url.hostname
    base += ":#{url.port}" if url.port?
    configs.base = base
    for i in url.search.substr(1).split('&')
      item = i.split('=')
      item[1] = item[1].split ',' if item[0] == 'plugins'
      configs[item[0]] = item[1]

  load: ->
    plugin.guests.load()

  guests:
    load: (settings = {}) ->
      plugin.detect()
      load '/plugins/guests', plugin.guests.show, settings

    show: (content) ->
      guests = get configs.tags.guests
      html guests, content

window.tipi =
  start: plugin.load
  guests: (settings) ->
    if settings?
      plugin.guests.load settings
    else
      plugin.guests.load()

plugin.load()
