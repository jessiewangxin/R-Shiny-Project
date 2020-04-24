library(shiny)
library(shinydashboard)
library(DT)
library(leaflet)
library(dplyr)
library(plotly)
library(viridis)

dashboardPage(skin='black',
  dashboardHeader(title='Airbnb Listings in NYC'),
  dashboardSidebar(
    sidebarUserPanel("Jessie Wang",
                     image="https://vignette.wikia.nocookie.net/onepiece/images/a/af/Tony_Tony_Chopper_Anime_Post_Timeskip_Infobox.png/revision/latest?cb=20130428202154"),
    sidebarMenu(
      menuItem('Introduction',tabName= 'introduction',icon=icon('info')),
      menuItem('Map',tabName = 'map',icon=icon('map')),
      menuItem('Where to Stay',tabName = 'analytics',icon=icon('question')),
      menuItem('Data',tabName = 'data',icon=icon('database')),
      menuItem('About Jessie',tabName= 'about',icon=icon('book')))),
  dashboardBody(
    tabItems(
          tabItem(tabName='introduction',
            HTML('<img src="https://eatplantstraveloften.files.wordpress.com/2019/10/p1011002-1.jpg?w=665", height="400px"    
            style="float:right"/>','<p style="color:black"></p>'),
                  'REPLACE WITH TEXT'),
          #INTERACTIVE MAP TAB
          tabItem(tabName='map',
                  #leaflet map
                  leafletOutput("map1"),
                  #slider
                  sliderInput("map_pricerange",
                              "Price Range:",
                              min = 32,
                              max = 500,
                              value = c(75,300)),
                  selectizeInput(inputId ="roomtype",
                                 label = "Room Type",
                                 choices = unique (airbnb$room_type)),
                  selectizeInput(inputId ="borough",
                                 label = "Borough",
                                 choices = unique (airbnb$neighbourhood_group))
                  
                  ),
          
          #Other Analytics
          tabItem(tabName='analytics',
                  
                  #plots
                  plotOutput("lePlot"),
                  plotlyOutput("leBubblePlot")),
          
            #DATA TAB
          tabItem(tabName='data',
                  fluidRow(box(DT::dataTableOutput("table"), width = 20))),
            
          #JESSIES BIO
          tabItem(tabName='about', 
                  
            fluidRow(
              column(6,"Hello, I hope you enjoyed browsing my R Shiny App project.
              Linkedin link
              Github link
                     "),
              column(6,
              #PERSONAL IMAGE LINK
              HTML('<img src="https://eatplantstraveloften.files.wordpress.com/2019/11/p6272436-1.jpg?w=665", height="400px"    
              style="float:right"/>','<p style="color:black"></p>'))))
    )
  )
)



