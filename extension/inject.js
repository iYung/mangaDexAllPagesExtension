// Generated by CoffeeScript 2.1.1
//inject script to webpage so it can access some variables
var injectScript;

injectScript = function(file, node) {
  var s, th;
  th = document.getElementsByTagName(node)[0];
  s = document.createElement('script');
  s.setAttribute('type', 'text/javascript');
  s.setAttribute('src', file);
  return th.appendChild(s);
};

injectScript(chrome.extension.getURL('script.js'), 'body');