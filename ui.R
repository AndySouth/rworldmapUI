#rworldmapUI/ui.r
#andy south 21/11/2014

library(shiny)


# shinyUI(pageWithSidebar(
#   
#   # Application title
#   #headerPanel("rworldmap shiny demo3, shows code and resultant plot, Andy South"),
#   #if no headerPanel an error is generated
#   headerPanel(""),
# 
#   sidebarPanel(
# 
#     selectInput("variable", "to plot :",
#                 c("population" = "POP_EST",
#                   "gdp" = "GDP_MD_EST"
#                   )),
# 
#     checkboxInput("addLegend", "addLegend", TRUE) #var,name
#     
#     
#   ),
#   
#   mainPanel(
#     
#     #h3(textOutput("caption")),
#     
#     #the map plot
#     plotOutput("rwmPlot")
#   )
# ))

#trying a fluid page to create more space for the plot
#from here
#https://groups.google.com/forum/?fromgroups#!searchin/shiny-discuss/plot$20area/shiny-discuss/_mrgCT5G7yQ/5mETVb3tfbIJ
shinyUI(fluidPage(
  
  fluidRow(h1("")),
           helpText("To show how maps can be created with rworldmap using the great WDI package.",
                    "Code from the code tab can be copied & pasted to recreate plots locally."),
  
  fluidRow(
    column(2,
           
           h3("rworldmapUI"),
           
#            selectInput("variable", "to plot :",
#                        c("population" = "POP_EST",
#                          "gdp" = "GDP_MD_EST"
#                        )),

           selectInput("indicator", "World Bank Indicator :",
                       c("sanitation" = "SH.STA.ACSN",
                         "CO2 per capita" = "EN.ATM.CO2E.PC",
                         "mobile phones" = "IT.CEL.SETS.P2"
                       )),           
           
           selectInput("catMethod", "categorisation :",
                       c("quantiles" = "quantiles",
                         "fixedWidth" = "fixedWidth",
                         "logFixedWidth" = "logFixedWidth"                         
                       )),          

           sliderInput("numCats", "num. categories :", 
                       min = 2,
                       max = 100, 
                       value = 6),
           
           selectInput("colourPalette", "colourPalette :",
                       c("YlOrRd" = "YlOrRd",
                         "YlGnBu" = "YlGnBu",
                         "Purples" = "Purples",
                         "PuBuGn" = "PuBuGn",
                         "Greens" = "Greens"
                       )), 
           
           selectInput("transformation", "map transformation :",
                       c("Long Lat" = "longlat",
                         "Robinson" = "robin",
                         "Winkel Tripel" = "wintri",
                         "Mercator" = "merc",
                         "Lambert Conformal Conic" = "lcc",
                         "Mollweide" = "moll"                        
                       )),           
           
           checkboxInput("addLegend", "addLegend", TRUE) #var,name
    ),
    
    column(10,
           
           tabsetPanel(
             tabPanel("Map", plotOutput("rwmplot", width = "100%")
             ),
             #tabPanel("Code", textOutput("codeText")
             #),
             tabPanel("Map Code", verbatimTextOutput("codePrint")
             #tabPanel("Code print", textOutput("codePrint")
             ),
             tabPanel("Barplot",plotOutput("barplot", width = "100%")
             ),
             tabPanel("Barplot Code", verbatimTextOutput("codePrintBarplot")
             )
             
                      
           ) #end tabset panel
    )
  )
  
))

