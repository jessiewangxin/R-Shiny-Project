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
  
  #DATA FOR WHERE TO STAY GRAPHS
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
  
  #Bubble plot, where to stay tab
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
   
   #MAP 2 only displays select locations  
    output$map2 <- renderLeaflet({
      #maxprice<-7
      bar_data()[1:input$numoptions,] %>% 
        filter(avg_price<=input$pricerange2[2] & avg_price>=input$pricerange2[1]) %>% 
        leaflet() %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addMarkers(~long, ~lat, label = ~neighbourhood) 
      
    })

    #data used to create plots on the summary tab 
    summarydata1 <- reactive({
      airbnb %>% 
        filter(neighbourhood==input$neighborhood1) 
    })
    
    #1st plot on summary tab
    output$summaryplot1 <- renderPlot({
      ggplot(
        summarydata1() %>% mutate(n=1) %>% 
          group_by(room_type) %>% 
          summarise(count=sum(n)) %>% mutate(percent=round(count/sum(count)*100,0.0))
        , aes(x=reorder(room_type,desc(count)),y=count)) + 
        geom_bar(stat="identity", fill = 'light blue') +  
        geom_text(aes(label=paste0(percent, "%\n(", count, ")"))) +
        theme_bw() +
        ylab("") +
        xlab("") +
        ggtitle("Frequency of Property Type")
    })
  

    #2nd plot, pie chart, on summary tab
    output$summaryplot2 <- renderPlot({
      ggplot(
        summarydata1() %>% mutate(n=1,
                          minimum_stay = ifelse(minimum_nights==1, '1 day',
                                                ifelse(minimum_nights >=2 &minimum_nights <=7, '2 to 7 days',
                                                       ifelse(minimum_nights >=8 &minimum_nights <=30, '8 to 30 days', 'over 30 days')))) %>% 
                                                       group_by(minimum_stay) %>% summarise(count=sum(n))
             , aes(x = 2, y = count, fill = minimum_stay)) +
        geom_bar(stat = "identity", color = "white") +
        coord_polar(theta = "y", start = 0) +
        theme_void() +
        xlim(0.5, 2.5) + 
        xlab('') +
        ylab('') +
        ggtitle('Minimum Days Required to Stay') +
        scale_fill_discrete(name = 'Minimum Stay') +
        theme_bw()
    })
    
    #3rd plot, histogram, on summary tab
    output$summaryplot3 <- renderPlot({
      ggplot(summarydata1() %>% filter(availability_365!=0), aes(x=availability_365, fill='coral')) + 
        geom_histogram(binwidth = 20) +
        geom_density(alpha=.2) +
        theme_bw() +
        theme(legend.position = "none") +
        ggtitle("Distribution of Availability") +
        ylab("") +
        xlab("Days in the Year")

    })
    
    #data used to create 2nd set of plots on the summary tab 
    summarydata2 <- reactive({
      airbnb %>% 
        filter(neighbourhood==input$neighborhood2) 
    })
    
    #1st plot on summary tab - for 2nd neighborhood
    output$summaryplot4 <- renderPlot({
      ggplot(
        summarydata2() %>% mutate(n=1) %>% 
          group_by(room_type) %>% 
          summarise(count=sum(n)) %>% mutate(percent=round(count/sum(count)*100,0.0))
        , aes(x=reorder(room_type,desc(count)),y=count)) + 
        geom_bar(stat="identity", fill = 'light blue') +  
        geom_text(aes(label=paste0(percent, "%\n(", count, ")"))) +
        theme_bw() +
        ylab("") +
        xlab("") +
        ggtitle("Frequency of Property Type")
    })
    
    
    #2nd plot, pie chart, on summary tab - for 2nd neighborhood
    output$summaryplot5 <- renderPlot({
      ggplot(
        summarydata2() %>% mutate(n=1,
                                 minimum_stay = ifelse(minimum_nights==1, '1 day',
                                                       ifelse(minimum_nights >=2 &minimum_nights <=7, '2 to 7 days',
                                                              ifelse(minimum_nights >=8 &minimum_nights <=30, '8 to 30 days', 'over 30 days')))) %>% 
          group_by(minimum_stay) %>% summarise(count=sum(n))
        , aes(x = 2, y = count, fill = minimum_stay)) +
        geom_bar(stat = "identity", color = "white") +
        coord_polar(theta = "y", start = 0) +
        theme_void() +
        xlim(0.5, 2.5) + 
        xlab('') +
        ylab('') +
        ggtitle('Minimum Days Required to Stay') +
        scale_fill_discrete(name = 'Minimum Stay') +
        theme_bw()
    })
    
    #3rd plot, histogram, on summary tab - for 2nd neighborhood
    output$summaryplot6 <- renderPlot({
      ggplot(summarydata2() %>% filter(availability_365!=0), aes(x=availability_365, fill='coral')) + 
        geom_histogram(binwidth = 20) +
        geom_density(alpha=.2) +
        theme_bw() +
        theme(legend.position = "none") +
        ggtitle("Distribution of Availability") +
        ylab("") +
        xlab("Days in the Year")
      
    })

}



