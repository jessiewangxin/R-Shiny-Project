function(input,output,session){
  
#DATA TAB 
  output$table=DT::renderDataTable({
    datatable(airbnb,rownames = F) %>% 
      formatStyle(input$selected,background = 'skyblue',
                  fontWeight ='bold')
  })

  #reading in data 
  airbnb<-read.csv('listings.csv')
  
  mapdata <- reactive({
    airbnb %>% 
      mutate(n=1) %>% 
      filter(room_type==input$roomtype,neighbourhood_group==input$borough) %>% 
      group_by(neighbourhood,neighbourhood_group) %>% 
      summarise(
        long=mean(longitude),
        lat=mean(latitude),
        avg_price=round(mean(price),0),
        avg_reviews=mean(number_of_reviews),
        num_listings=sum(n)) %>% 
      mutate(info=paste("$",as.character(round(avg_price,0)),"/night, ",
                        neighbourhood," (",neighbourhood_group,")", sep=""))
  })
    
   
  #formatting label for the map 
  # mapdata$info<- paste("$",as.character(round(mapdata$avg_price,0)),"/night, ",
  #                   mapdata$neighbourhood," (",mapdata$neighbourhood_group,")", sep="")
  # 
  #adding colors for the map
  boroughcolors <- colorNumeric(palette = "Set1",domain = 0:500)
  
  
  
  #MAP 1 SCATTER OF AVERAGE PRICES 
  output$map1 <- renderLeaflet({
    #maxprice<-7
  
    mapdata() %>% filter(avg_price<=input$map_pricerange[2] & avg_price>=input$map_pricerange[1]) %>% 
    leaflet() %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      addCircleMarkers(~long, ~lat, 
                       color= ~boroughcolors(avg_price),
                       fillOpacity = 1,
                       radius=1,
                       label = ~info) %>% 
      addLegend('bottomright', 
                pal=boroughcolors, 
                values=~avg_price, 
                title = "Number of Listings") 
    
  })
  
  #WHERE TO STAY GRAPHS! 
  bar_data <- reactive({
    airbnb %>% 
      mutate(n=1) %>% 
      filter(room_type=="Private room",neighbourhood_group=="Brooklyn") %>% 
      group_by(neighbourhood,neighbourhood_group) %>% 
      summarise(
        avg_price=round(mean(price),0),
        avg_reviews=round(mean(number_of_reviews),0),
        num_listings=sum(n)) %>%     
      mutate(text = 
               paste(neighbourhood,", ", neighbourhood_group, 
                     "\nAverage Price: ", avg_price, 
                     "\nAverage Number of Reviews: ", avg_reviews, 
                     "\nTotal Listings: ", num_listings, sep=""))  %>% 
      arrange(desc(num_listings))
  })
  
  output$lePlot <- renderPlot({
    bar_data()[1:5,] %>% 
      ggplot(aes(x=reorder(neighbourhood,desc(num_listings)),y=num_listings)) + 
      geom_bar(stat='identity', fill = "light blue") + 
      theme_bw() +
      ylab("Average Number of Reviews") +
      xlab("") +
      ggtitle("Top 5 Listed Neighborhoods") +
      theme(plot.title = element_text(hjust = 0.5)) +coord_flip()
  })
  
  output$leBubblePlot <- renderPlotly({
    ggplotly(ggplot(bar_data()[1:5,],
               aes(x=avg_price, y=num_listings, size = avg_reviews, color = neighbourhood,text=text)) +
               geom_point(alpha=0.7) +
               scale_size(range = c(5, 15)) +
               scale_color_viridis(discrete=TRUE, guide=FALSE) +
               theme_bw() +
               xlab("Average Price") + 
               ylab("Number of Reviews") +
               theme(legend.position="bottomright"),tooltip="text") 
  })

}