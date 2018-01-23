http = require 'http'
fs = require 'fs'

file = fs.createWriteStream "./extension/jquery-3.2.1.slim.min.js"
http.get "http://code.jquery.com/jquery-3.2.1.slim.min.js", (response) ->
    response.pipe file