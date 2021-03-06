$ document
    .ready ->

        #build image url
        urlArray = $("#current_page").attr "src"
            .split '/'
        imgType = urlArray.pop().replace /[0-9]/g, ''
        imgPrefix = imgType.slice 0, imgType.indexOf "."
        imgType = imgType.slice imgType.indexOf "."
        url = ""
        url += text + "/" for text in urlArray
        
        #save page count
        pageTotal = $("#jump_page").children().length
        
        #removes effects of all page mode
        allPagesOffMode = ->
            
            #refreshes window to start of chapter
            newUrlArray = window.location.href.split '/'
            do newUrlArray.pop
            newUrl = ""
            newUrl += text + "/" for text in newUrlArray
            window.location.replace newUrl+"1"
        
        #setting up all page mode
        allPagesOnMode = ->
        
            #removes original image
            $ "#current_page"
                .remove()
            
            #changes on/off button to on
            $ "#allPages"
                .html "Long Strip On"
            
            #disables page dropdown
            $ "#jump_page"
                .attr 'disabled', ''
                
            #creates bottom bar
            $ "#content"
                .append '<div style="position:fixed;bottom:2%;right:2%;z-index:99;" id="bottomBar"><button class="btn btn-default" style="border:0;background: rgba(255, 255, 255, 0.5);" id="goPrev">&lt;-</button><button class="btn btn-default" style="border:0;background: rgba(255, 255, 255, 0.5);" id="goToTop">Top</button><button class="btn btn-default" style="border:0;background: rgba(255, 255, 255, 0.5);" id="goNext">-&gt;</button></div>'
                
            #makes page go to the top
            $ "#goToTop"
                .on "click", ->
                    window
                        .scrollTo 0, 0
            
            #runs keydown handlers to go to the next chapter         
            ##USES UNRELIABLE JQUERY FUNCTIONS
            $ "#goNext"
                .on "click", ->
                    events = $._data($(document)[0], "events")["keydown"]
                    newKeypressIndex = index for event, index in events when String(event.handler).includes "#all_page_"
                    oldKeypressIndex = index for event, index in events when String(event.handler).includes "evt.target"
                    events[newKeypressIndex].handler {keyCode: 39}
                    events[oldKeypressIndex].handler {keyCode: 39, target: {tagName: 'BODY'}, key: "d"}
                    
            #runs keydown handlers to go to the prev chapter         
            ##USES UNRELIABLE JQUERY FUNCTIONS
            $ "#goPrev"
                .on "click", ->
                    events = $._data($(document)[0], "events")["keydown"]
                    newKeypressIndex = index for event, index in events when String(event.handler).includes "#all_page_"
                    oldKeypressIndex = index for event, index in events when String(event.handler).includes "evt.target"
                    events[newKeypressIndex].handler {keyCode: 37}
                    events[oldKeypressIndex].handler {keyCode: 37, target: {tagName: 'BODY'}, key: "a"}
        
            #adds images with a function which helps deal with chapteres with both jpg and png
            $( '.images' ).append '<img name="all_page" id="all_page_' + i + '" class="reader max-width" src="' + url + imgPrefix + i + imgType + '" alt="image" data-page="'+i+'">' for i in [1...pageTotal + 1]
            fixUrl elem, index + 1 for elem, index in $ '[name="all_page"]'
                    
            #adds new arrow key functions which makes them jump by chapters instead of pages
            $(document).keydown (evt) ->
                switch evt.keyCode
                    when 39 then $("#all_page_" + pageTotal ).attr "id", "current_page"
                    when 37 then $("#all_page_1").attr "id", "current_page"
        
            #swap event order when arrow keys are pressed
            ##USES UNRELIABLE JQUERY FUNCTIONS
            events = $._data($(document)[0], "events")["keydown"]
            newKeypressIndex = index for event, index in events when String(event.handler).includes "#all_page_"
            oldKeypressIndex = index for event, index in events when String(event.handler).includes "evt.target"
            temp = events[newKeypressIndex]
            events[newKeypressIndex] = events[oldKeypressIndex]
            events[oldKeypressIndex] = temp
        
        #checks to see button settings
        setButton = ->
            if localStorage.getItem("allPagesMode") is 'true' then do allPagesOnMode else do allPagesOffMode
        
        #swaps img source from jpg <-> png and marks that it has attempted to fix the url to prevent an infinite cycle if there is no image
        fixUrl = (elem, i) -> 
            newImgType = if imgType is ".png" then ".jpg" else ".png"
            $(elem).on "error", ->
                if $(elem).attr("retry") is undefined
                    $(elem).attr "src", url + imgPrefix + i + newImgType
                    $(elem).attr "retry", ""
            
        #makes room for a "Long Strip" toggle button
        $ "#jump_group"
            .parents "[class='col-md-3']"
                .attr 'class', 'col-md-2'
        $ "[class='col-md-4 text-center']"
            .attr 'class', 'col-md-3 text-center'
        #adds the on/off button
        $ "#jump_page"
            .parents "[class='row']"
                .append '<div id="allPagesDiv" class="col-md-1"><button class="btn btn-default" id="allPages">Long Strip Off</button></div>'
        
        #checks previous state of extension
        if localStorage.getItem("allPagesMode") is null then localStorage.setItem "allPagesMode", false
        do setButton if localStorage.getItem("allPagesMode") is 'true'
        
        #adds button toggle functionality
        $ "#allPages"
            .on "click", ->
                localStorage.setItem "allPagesMode", localStorage.getItem("allPagesMode") is 'false'
                do setButton