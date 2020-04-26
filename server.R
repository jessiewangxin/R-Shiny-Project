function(input,output,session){
  
#DATA TAB 
  output$table=DT::renderDataTable({
    datatable(airbnb,rownames = F) %>% 
      formatStyle(input$selected,background = 'skyblue',
                  fontWeight ='bold')
  })

#data used for the interactive map on the map tab
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
    
  test=mapdata 
  #adding colors for the map (map tab)
  boroughcolors <- colorNumeric(palette = "BuPu",domain = 0:500)
  #boroughcolors <- colorNumeric(palette = "Set1",domain = mapdata$price_bucket)
  
  #MAP 1 SCATTER OF AVERAGE PRICES 
  output$map1 <- renderLeaflet({
    mapdata() %>% filter(avg_price<=input$map_pricerange[2] & avg_price>=input$map_pricerange[1]) %>% 
    leaflet() %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      addCircleMarkers(~long, ~lat, 
                       color= ~boroughcolors(avg_price),
                       fillOpacity = 1,
                       radius=3,
                       label = ~info) %>% 
      addLegend('bottomright', 
                pal=boroughcolors, 
                values=~avg_price, 
                title = "Average Price") 
    
  })
  
  #WHERE TO STAY GRAPHS! 
  bar_data <- reactive({
    airbnb %>% 
      mutate(n=1) %>% 
      filter(room_type==input$roomtype2,neighbourhood_group==input$borough2) %>% 
      group_by(neighbourhood,neighbourhood_group) %>% 
      summarise(
        long=mean(longitude),
        lat=mean(latitude),
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
  
  
    output$leBubblePlot <- renderPlotly({
      ggplotly(ggplot(bar_data()[1:input$numoptions,] %>% 
                 filter(avg_price<=input$pricerange2[2] & avg_price>=input$pricerange2[1]),
                 aes(x=avg_price, y=num_listings, size = avg_reviews, color = neighbourhood,text=text)) +
                 geom_point(alpha=0.7) +
                 scale_size(range = c(5, 15)) +
                 scale_color_viridis(discrete=TRUE, guide=FALSE) +
                 theme_bw() +
                 xlab("Average Price") + 
                 ylab("Number of Listings") +
                 ggtitle("Most Listed Neighborhoods") +
                 theme(legend.title=element_blank(),legend.position="topright",plot.title = element_text(hjust = 0.5)),tooltip="text") %>% 
                 layout(autosize = FALSE, height = 425,width=650)
    })
   
   #MAP 2 select locations  
    output$map2 <- renderLeaflet({
      #maxprice<-7
      bar_data()[1:input$numoptions,] %>% 
        filter(avg_price<=input$pricerange2[2] & avg_price>=input$pricerange2[1]) %>% 
        leaflet() %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addMarkers(~long, ~lat, label = ~neighbourhood) 
      
    })
  

}



