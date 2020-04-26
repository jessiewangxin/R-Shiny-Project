

dashboardPage(skin='black',
  dashboardHeader(title='NYC Airbnb Data Project'),
  dashboardSidebar(
    sidebarMenu(
      menuItem('Introduction',tabName= 'introduction',icon=icon('info')),
      menuItem('Map',tabName = 'map',icon=icon('map')),
      menuItem('Where to Stay',tabName = 'analytics',icon=icon('question')),
      menuItem('Summaries',tabName = 'summaries',icon=icon('adjust')),
      menuItem('Data',tabName = 'data',icon=icon('database')),
      menuItem('About Jessie',tabName= 'about',icon=icon('book')))),
  dashboardBody(
    tabItems(
          tabItem(tabName='introduction',
            HTML('
            <p><center><b><font size="6">Visualizing NYC Airbnb Data</font></b></center></p>
            <p><center><font size="4">Finding the Best Neighborhoods to Stay in New York</font></center></p>
            <p><center>by Jessie Wang</center></p>
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
            The purpose of this project is to help users determine the best neighborhood to stay in New York City, by 
            observing several factors such as: price, borough, property type, number of listings. Below is a summary of the tabs in this Shiny app, please 
            refer to each respective tab for more detailed information and instructions.
            </center></p>
            
            <center><p>
          <table style="width: 417px; height: 258px;">
          <tbody>
          <tr>
          <td style="width: 120.671875px;"><u><b>Tab Name</b></u></td>
          <td style="width: 295.34375px;"><u><b>Description</b></u></td>
          </tr>
          <tr>
          <td style="width: 120.671875px;"><b>Map</b></td>
          <td style="width: 295.34375px;">Interactive map that displays average price of listings in each neighborhood.</td>
          </tr>
          <tr>
          <td style="width: 120.671875px;"><b>Where to Stay</b></td>
          <td style="width: 295.34375px;">Presents a maximum of 10 recommended neighborhoods that fit the user input criteria.</td>
          </tr>
          <tr>
          <td style="width: 120.671875px;"><b>Summaries</b></td>
          <td style="width: 295.34375px;">Other data visualizations and insights.</td>
          </tr>
          <tr>
          <td style="width: 120.671875px;"><b>Data</b></td>
          <td style="width: 295.34375px;">Data used for project, and source.</td>
          </tr>
          <tr>
          <td style="width: 120.671875px;"><b>About Jessie</b></td>
          <td style="width: 295.34375px;">About me, includes links to my Github, project code, and contact information.</td>
          </tr>
          </tbody>
          </table>
          </center></p>
                 ')),
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
                         Please specify your preferences using the slide and drop down menus. 
                         If you receive an error, please try another set of inputs.
                         <br></br>                         
                         Light blue markers on the map indicate cheaper neighborhoods (on average), and dark purple ones 
                         indicate the most expensive. Hover over a circle to view the borough name and average price per night (per listing).
                         <br></br>
                         <br></br>
                         '))
                  
                  )),
          
          #Other Analytics
          tabItem(tabName='analytics',
                  
                  #plots
                  fluidRow(
                    column(4,
                           "Please specify your preferences using the options below. If you receive an error, please try 
                           another set of inputs.",
                           HTML('<br></br>'),
                           sliderInput("numoptions",
                                       "Number of Options:",
                                       min = 1,
                                       max = 10,
                                       value = 5),
                           sliderInput("pricerange2",
                                       "Price Range:",
                                       min = 32,
                                       max = 500,
                                       value = c(75,300)),
                           selectizeInput(inputId ="roomtype2",
                                          label = "Room Type",
                                          choices = unique (airbnb$room_type)),
                           selectizeInput(inputId ="borough2",
                                          label = "Borough",
                                          choices = unique (airbnb$neighbourhood_group))
                           
                           ),
                  column(8,plotlyOutput("leBubblePlot"))),
                  HTML('<br></br>'),
                  leafletOutput("map2"),
                  HTML('<br></br>'),
                  "Note: Top 5 (or as specified) number of recommended neighborhoods
                  displays those with the highest number of listings that
                  satisfy the user input criteria. The larger bubbles on the plot reflect higher numbers of 
                  reviews on average - indicating more bookings and higher popularity. ",
                  HTML('
                         <br></br>
                         <br></br> 
                       ')),
          tabItem(tabName = 'summaries',
                  selectizeInput(inputId ="neighborhood",
                                 label = "Neighborhood",
                                 choices = unique (airbnb$neighbourhood)),
                  plotOutput("summaryplot1"),
                  plotOutput("summaryplot2"),
                  plotOutput("summaryplot3")
                  ),
            #DATA TAB
          tabItem(tabName='data',
                  HTML('
                     <a href="http://insideairbnb.com/get-the-data.html">Data Source</a>
                     <br></br> 
                       '),
                  
                  fluidRow(box(DT::dataTableOutput("table"), width = 20)),
                  HTML('
                     <br></br> 
                     <br></br> 
                       ')),
            
          #JESSIES BIO
          tabItem(tabName='about', 
                  
            fluidRow(
              column(6,HTML('
                              <p>I hope you enjoyed browsing my R Shiny project. </p>
                              <p>A little about myself, I studied Actuarial Science at the University of California, Santa Barbara. 
                              Upon graduation, I started my career as an Actuary in the healthcare industry, where I had the opportunity 
                              to work on various projects utilizing healthcare data. 
                              </p>
                              <p>I became interested in data science as there are many ways to use data creatively as a form 
                              storytelling. Aside from data science,
                              my interests include traveling, photography, and cooking - I am always trying new recipes!</p>
                              <p><a href="https://www.linkedin.com/in/jessie-wang-5b82b980/">LinkedIn</a></p>
                              <p><a href="https://github.com/jessiewangxin/">Github</a></p>
                              <p><a href="https://github.com/jessiewangxin/R-Shiny-Project">R Shiny Project Code</a></p>
                              <p>E-mail: jessiewangemail@gmail.com</p>
                              <p><br></p>')),
              column(6,
              #PERSONAL IMAGE LINK
              HTML('<img src="Jessie2.jpg", height="400px"    
              style="float:right"/>','<p style="color:black"></p>'))))
    )
  )
)



