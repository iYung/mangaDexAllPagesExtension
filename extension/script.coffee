#turns off button  
allPagesOffMode = ->
    $ "#allPages"
        .html "All Pages Off"
    $ "#goToTop"
        .remove()

#turns on buttons         
allPagesOnMode = ->
    $ "#allPages"
        .html "All Pages On"
    $ "#content"
        .append '<button class="btn btn-default" style="position:fixed;bottom:5%;right:5%;" id="goToTop">Go To Top</button>'
    $ "#goToTop"
        .on "click", ->
            window
                .scrollTo 0, 0

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
        
        