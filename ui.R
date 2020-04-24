

dashboardPage(skin='black',
  dashboardHeader(title='Airbnb Listings in NYC'),
  dashboardSidebar(
    sidebarUserPanel("Jessie Wang",
                     image="https://avatars3.githubusercontent.com/u/60956368?s=400&v=4"),
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
            <p>REPLACE WITH TEXT</p>
            <p>
            <img src="https://eatplantstraveloften.files.wordpress.com/2019/10/p1011002-1.jpg?w=665", height="400px"    
            style="float:right"/>','<p style="color:black"></p></p>
            <p>REPLACE WITH TEXT</p>')),
          #INTERACTIVE MAP TAB
          tabItem(tabName='map',
                  #leaflet map
                  leafletOutput("map1"),
                  #slider
                  fluidRow(
                  column(6,
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
                                 choices = unique (airbnb$neighbourhood_group))),
                  column(6,
                         "INSTRUCTION TEXT HERE")
                  
                  )),
          
          #Other Analytics
          tabItem(tabName='analytics',
                  
                  #plots
                  fluidRow(
                  column(6,plotOutput("lePlot")),
                  column(6,plotlyOutput("leBubblePlot"))),
                  leafletOutput("map2")),
          
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
                              like the opportunity to combine my analytical skills with my creative talent. Aside from Data Science,
                              my interests include traveling, photography, and cooking - I am always trying new recipes.</p>
                              <p><a href="https://www.linkedin.com/in/jessie-wang-5b82b980/">LinkedIn</a></p>
                              <p><a href="https://github.com/jessiewangxin/">Github</a></p>
                              <p><br></p>')),
              column(6,
              #PERSONAL IMAGE LINK
              HTML('<img src="https://eatplantstraveloften.files.wordpress.com/2019/11/p6272436-1.jpg?w=665", height="400px"    
              style="float:right"/>','<p style="color:black"></p>'))))
    )
  )
)



