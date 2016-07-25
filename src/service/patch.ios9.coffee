angular.module('ngIOS9UIWebViewPatch', [ 'ng' ]).config [
  '$provide'
  ($provide) ->
    'use strict'
    $provide.decorator '$browser', [
      '$delegate'
      '$window'
      ($delegate, $window) ->

        isIOS9UIWebView = (userAgent) ->
          /(iPhone|iPad|iPod).* OS 9_\d/.test(userAgent) and !/Version\/9\./.test(userAgent)

        applyIOS9Shim = (browser) ->
          pendingLocationUrl = null
          originalUrlFn = browser.url

          clearPendingLocationUrl = ->
            pendingLocationUrl = null
            return

          browser.url = ->
            if arguments.length
              pendingLocationUrl = arguments[0]
              return originalUrlFn.apply(browser, arguments)
            pendingLocationUrl or originalUrlFn.apply(browser, arguments)

          window.addEventListener 'popstate', clearPendingLocationUrl, false
          window.addEventListener 'hashchange', clearPendingLocationUrl, false
          browser

        if isIOS9UIWebView($window.navigator.userAgent)
          return applyIOS9Shim($delegate)
        $delegate
    ]
    return
]
