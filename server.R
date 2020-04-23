function(input,output,session){
  
#DATA TAB 
  output$table=DT::renderDataTable({
    datatable(airbnb,rownames = F) %>% 
      formatStyle(input$selected,background = 'skyblue',
                  fontWeight ='bold')
  })

  #reading in data 
  airbnb<-read.csv('listings.csv')
  
  test <- airbnb %>% 
    mutate(n=1) %>% 
    filter(room_type=='Private room') %>% 
    group_by(neighbourhood,neighbourhood_group) %>% 
    summarise(
      long=mean(longitude),
      lat=mean(latitude),
      avg_price=round(mean(price),0),
      avg_reviews=mean(number_of_reviews),
      num_listings=sum(n))
  
  #formatting label for the map 
  test$info<- paste("$",as.character(round(test$avg_price,0)),"/night, ",
                    test$neighbourhood," (",test$neighbourhood_group,")", sep="")
  #adding colors for the map
  boroughcolors <- colorNumeric(palette = "Set1",domain = 0:500)
  
  
  
  #MAP 1 SCATTER OF AVERAGE PRICES 
  output$map1 <- renderLeaflet({
    #maxprice<-7
  
    test %>% filter(avg_price<=input$maxprice) %>% 
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

}