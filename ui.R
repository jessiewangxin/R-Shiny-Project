

dashboardPage(skin='black',
  dashboardHeader(title='Airbnb Listings in NYC'),
  dashboardSidebar(
    sidebarUserPanel("Jessie Wang",
                     image="Jessie1.jpeg"),
    sidebarMenu(
      menuItem('Introduction',tabName= 'introduction',icon=icon('info')),
      menuItem('Map',tabName = 'map',icon=icon('map')),
      menuItem('Where to Stay',tabName = 'analytics',icon=icon('question')),
      menuItem('Data',tabName = 'data',icon=icon('database')),
      menuItem('About Jessie',tabName= 'about',icon=icon('book')))),
  dashboardBody(
    tabItems(
          tabItem(tabName='introduction',
            HTML('
            <p><center><b>REPLACE WITH TEXT</b></center></p>
            <p><center>
            <img src="NewYork2.png", height="400px"    
            style="float:center"/>
            <img src="NewYork3.png", height="400px"    
            style="float:center"/></center>
            </p>
            </p><center>
            (photos taken by Jessie Wang)
            </center></p>
            <p><center>
            REPLACE WITH TEXT
            </center></p>')),
          #INTERACTIVE MAP TAB
          tabItem(tabName='map',
                  #leaflet map
                  leafletOutput("map1"),
                  #slider
                  fluidRow(
                  column(6,
                  HTML('<br></br>'),
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
                                 choices = unique (airbnb$neighbourhood_group)),
                  #<br> adds space below the drop down menus
                  HTML('
                         <br></br>
                         <br></br> 
                         <br></br>
                       ')),
                  column(6,HTML(
                         '<br></br>
                         <b>Instructions: </b>
                         <br></br>
                         INSERT TEXT HERE
                         <br></br>
                         <br></br>
                         '))
                  
                  )),
          
          #Other Analytics
          tabItem(tabName='analytics',
                  
                  #plots
                  fluidRow(
                    column(4,"TEXT HERE"),
                  # column(6,plotOutput("lePlot")),
                  column(8,plotlyOutput("leBubblePlot"))),
                  HTML('<br></br>'),
                  leafletOutput("map2"),
                  HTML('
                         <br></br>
                         <br></br> 
                       ')),
          
            #DATA TAB
          tabItem(tabName='data',
                  fluidRow(box(DT::dataTableOutput("table"), width = 20))),
            
          #JESSIES BIO
          tabItem(tabName='about', 
                  
            fluidRow(
              column(6,HTML('<p>Hello,</p>
                              <p>I hope you enjoyed browsing my R Shiny App project. </p>
                              <p>A little about myself, I studied Actuarial Science at the University of California, Santa Barbara. 
                              Upon graduation, I worked as an Actuary in the healthcare industry for several years, 
                              with an array of experience in: data analytics, financial reporting, reserving and pricing. </p>
                              <p>I became interested in Data Science, as I have always had a passion for Statistics and technology. I also
                              like the opportunity to combine my analytical skills with my creative instinct. Aside from Data Science,
                              my interests include traveling, photography, and cooking - I am always trying new recipes.</p>
                              <p><a href="https://www.linkedin.com/in/jessie-wang-5b82b980/">LinkedIn</a></p>
                              <p><a href="https://github.com/jessiewangxin/">Github</a></p>
                              <p><br></p>')),
              column(6,
              #PERSONAL IMAGE LINK
              HTML('<img src="Jessie2.jpg", height="400px"    
              style="float:right"/>','<p style="color:black"></p>'))))
    )
  )
)



