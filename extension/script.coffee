#build image url
urlArray = $("#current_page").attr "src"
    .split('/')
imgType = urlArray.pop().replace /[0-9]/g, ''
url = ""
url += text + "/" for text in urlArray

#variable to save removed original page
originalPage = ""

#save page count
pageTotal = $("#jump_page").children().length

#turns off button
allPagesOffMode = ->
    $( originalPage ).insertBefore( "#goToTop" )
    $ "#allPages"
        .html "All Pages Off"
    $ "#goToTop"
        .remove()
    do elem.remove for elem in $ "[name='all_page']"

#turns on buttons         
allPagesOnMode = ->
    originalPage = $("#current_page")[0]
    $ "#current_page"
        .remove()
    $ "#allPages"
        .html "All Pages On"
    $ "#content"
        .append '<button class="btn btn-default" style="position:fixed;bottom:5%;right:5%;z-index:99;" id="goToTop">Go To Top</button>'
    $ "#goToTop"
        .on "click", ->
            window
                .scrollTo 0, 0
    $( '<img name="all_page" id="all_page_' + i + '" class="edit reader" src="' + url + i + imgType + '" alt="image" data-page="'+i+'">' ).insertBefore( "#goToTop" ) for i in [1...pageTotal + 1]
    $(document).keydown (evt) ->
        switch evt.keyCode
            when 39 then $("#all_page_" + pageTotal ).attr "id", "current_page"
            when 37 then $("#all_page_1").attr "id", "current_page"
    events = $._data($(document)[0], "events")["keydown"]
    temp = events[4]
    events[4] = events[3]
    events[3] = temp
    console.log $._data $(document)[0], "events"

#checks to see button settings
setButton = ->
    if localStorage.getItem("allPagesMode") is 'true' then do allPagesOnMode else do allPagesOffMode
    
#makes room for a "All Pages" toggle button
$ "#jump_page"
    .parents "[class='col-sm-3']"
        .attr 'class', 'col-sm-2'
$ "#jump_group"
    .parents "[class='col-sm-3']"
        .attr 'class', 'col-sm-2'
#adds the button
$ "#jump_page"
    .parents "[class='row']"
        .append '<div id="allPagesDiv" class="col-sm-1"><button class="btn btn-default" id="allPages">All Pages</button></div>'

#checks previous state of extension
if localStorage.getItem("allPagesMode") is null then localStorage.setItem "allPagesMode", false
do setButton

#adds button toggle functionality
$ "#allPages"
    .on "click", ->
        localStorage.setItem "allPagesMode", localStorage.getItem("allPagesMode") is 'false'
        do setButton