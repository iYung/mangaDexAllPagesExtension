###childList = document.getElementsByTagName('body')[0].children
scriptNodeIndex = index for child, index in childList when child.innerHTML.includes "var $ = jQuery;"
script = childList[scriptNodeIndex].innerHTML.replace "var page_array", "page_array"
script = script.replace "var $ = jQuery;", "var $ = jQuery; var page_array = [];"
childList[scriptNodeIndex].innerHTML = script

console.log window
###
#inject script to webpage so it can access some variables
injectScript = (file, node) ->
    th = document.getElementsByTagName(node)[0]
    s = document.createElement 'script'
    s.setAttribute 'type', 'text/javascript'
    s.setAttribute 'src', file
    th.appendChild s
injectScript chrome.extension.getURL('script.js'), 'body'