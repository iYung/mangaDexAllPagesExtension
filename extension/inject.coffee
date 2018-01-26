s#inject script to webpage so it can access some variables
injectScript = (file, node) ->
    th = document.getElementsByTagName(node)[0]
    s = document.createElement 'script'
    s.setAttribute 'type', 'text/javascript'
    s.setAttribute 'src', file
    th.appendChild s
injectScript chrome.extension.getURL('script.js'), 'body'