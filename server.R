#rworldmapUI/server.r
#andy south 21/11/2014

library(shiny)
library(rworldmap)
library(rgdal) #for spTransform
library(RColorBrewer)
library(WDI)
#trying this to improve blurry plots in shiny
#library(Cairo) 
#options(shiny.usecairo=TRUE)
#this did make the plots look better
options(shiny.usecairo=FALSE)

#for me to deploy online
#library(shinyapps)
#setwd("C:\\rworldmapNotes\\2014\\")
#deployApp('rworldmapUI')


shinyServer(function(input, output) {
  
  # map call ---- 
  # can be called from more than one place
  formulaText <- reactive({
    
    strCode <- paste0("#allow map to fill plot area\n")    
    strCode <- paste0(strCode,"par(mar=c(3,0,0,0)) #bltr\n\n")
    
    strCode <- paste0(strCode,"#get data\n")
    strCode <- paste0(strCode,"dF <- WDI( indicator='",input$indicator,"',start=2010,end=2010 )\n")
    
    strCode <- paste0(strCode,"#join data to map\n")
    strCode <- paste0(strCode,"sPDF <- joinCountryData2Map( dF, nameJoinColumn='iso2c',joinCode='ISO2')\n")
                                          
    strCode <- paste0(strCode,"#exclude Antarctica\n")
    #strCode <- paste0(strCode,"sPDF <- getMap()[getMap()$ADMIN!='Antarctica',]\n\n")
    strCode <- paste0(strCode,"sPDF <- sPDF[sPDF$ADMIN!='Antarctica',]\n\n")
        
    #transform if not latlon selected
    if ( input$transformation != "longlat")
    {
      strCode <- paste0(strCode,"#transform projection\n")
      strCode <- paste0(strCode,"projCRS <- '+proj=",input$transformation," +ellps=WGS84'\n")
      strCode <- paste0(strCode,"sPDF <- spTransform(sPDF, CRS=CRS(projCRS))\n\n")
    }

    #get RColorBrewer palette if heat not selected
    #if ( input$colourPalette != "heat")
    #{
      strCode <- paste0(strCode,"#get RColorBrewer colourPalette\n")
      strCode <- paste0(strCode,"colourPalette <- brewer.pal(",input$numCats,",'",input$colourPalette,"')\n\n")
    #}
    
    #strCode <- paste0(strCode,"\n")
    
    strCode <- paste0(strCode,
                      "mapCountryData(sPDF, nameColumnToPlot='",input$indicator,
                      "', mapTitle='', addLegend=",input$addLegend,
                      ", catMethod='",input$catMethod,"'",
                      ", numCats=",input$numCats,                      
                      ", colourPalette=colourPalette",    
                      ")")    
  
    strCode
    })
   

  # barplot call ---- 
  formulaTextBarplot <- reactive({
    
    strCode <- paste0("#allow plot to fill plot area\n")    
    strCode <- paste0(strCode,"par(mar=c(3,0,0,0)) #bltr\n\n")
    
    strCode <- paste0(strCode,"#get data\n")
    strCode <- paste0(strCode,"dF <- WDI( indicator='",input$indicator,"',start=2010,end=2010 )\n")
    
    strCode <- paste0(strCode,"#join data to map\n")
    strCode <- paste0(strCode,"sPDF <- joinCountryData2Map( dF, nameJoinColumn='iso2c',joinCode='ISO2')\n")
    
    
    #get RColorBrewer palette if heat not selected
    #if ( input$colourPalette != "heat")
    #{
    strCode <- paste0(strCode,"#get RColorBrewer colourPalette\n")
    strCode <- paste0(strCode,"colourPalette <- brewer.pal(",input$numCats,",'",input$colourPalette,"')\n\n")
    #}
    
    #strCode <- paste0(strCode,"\n")
    
    strCode <- paste0(strCode,
                      "barplotCountryData(sPDF, nameColumnToPlot='",input$indicator,"'",
                      ", catMethod='",input$catMethod,"'",
                      ", numCats=",input$numCats,                      
                      ", colourPalette=colourPalette", 
                      ",na.last = NA ,decreasing = FALSE, scaleSameInPanels = TRUE, numPanels = 7, cex = 1.1", 
                      ")")    
    
    strCode
  })  
  
  
  
  # map plot ----
  output$rwmplot <- renderPlot({
    
    #mapCountryData(nameColumnToPlot=input$variable, addLegend=input$addLegend)
    eval(parse(text=formulaText()))
  })

  # barplot ----
  output$barplot <- renderPlot({
    
    eval(parse(text=formulaTextBarplot()))
  })
  
  # code via renderText ----
#   output$codeText <- renderText({
#     formulaText()
#   })  
  
  
  # map code via renderPrint----
  output$codePrint <- renderPrint({
    
    #add lib requirements on the start
    cat("library(rworldmap)\n")
    cat("library(RColorBrewer)\n")
    cat("library(WDI)\n")    
    cat("library(rgdal) #only needed if reprojection selected\n\n")    
    
    #cat makes that endlines are recognised
    cat( formulaText() )
  })   

  # barplot code via renderPrint----
  output$codePrintBarplot <- renderPrint({
    
    #add lib requirements on the start
    cat("library(rworldmap)\n")
    cat("library(RColorBrewer)\n")
    cat("library(WDI)\n")    
    cat("library(rgdal) #only needed if reprojection selected\n\n")    
    
    #cat makes that endlines are recognised
    cat( formulaTextBarplot() )
  })   

})
