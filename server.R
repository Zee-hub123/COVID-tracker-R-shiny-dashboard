#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



server <- function(input, output) {
    
    
    
    
    output$progressBox <- renderValueBox({
        
        sumdata <- agg[-1,-1]
        
        allsum <- sumdata %>% 
            summarise_all(funs(sum)) %>% 
            select(deathsum)
        
        allsum1 <- prettyNum(allsum$deathsum, big.mark = ",", scientific = FALSE)
        
        box1 <- allsum1[1]
        
        
        
        valueBox(value = tags$p("COVID Deaths", style = "font-size: 80%;"),
                 paste0(box1), 
                 color = "red"
        )
    })
    
    output$progressBox2 <- renderValueBox({
        
        sumdata <- agg[-1,-1]
        
        allsum <- sumdata %>% 
            summarise_all(funs(sum)) %>% 
            select(casessum)
        allsum2 <- prettyNum(allsum$casessum, big.mark = ",", scientific = FALSE)
        
        box2 <- allsum2[1]
        valueBox(value = tags$p("COVID Cases", style = "font-size: 80%;"),
                 paste0( box2), 
                 color = "yellow"
        ) })
    
    output$progressBox3 <- renderValueBox({
        
        sumdata <- agg[-1,-1]
        
        allsum <- sumdata %>% 
            summarise_all(funs(sum)) %>% 
            select(vcomsum)
        
        allsum3 <- prettyNum(allsum$vcomsum, big.mark = ",", scientific = FALSE)
        
        box3 <- allsum3[1]
        
        valueBox(value = tags$p("COVID Vaccinated", style = "font-size: 80%;")
                 
                 , paste0( box3), 
                 color = "green"
        )
    })
    
    
    dat_overall_pandemic_start <- reactive(
        datastate %>% filter(  (State %in% c(input$state)) &
                                   (date>=input$dateRange[1] & date<=input$dateRange[2])) 
        
        
        
    ) 
    
    output$plot1 <- ({
        
        options(scipen = 999)
        
        
        renderPlot(
            dat_overall_pandemic_start() %>% ggplot( aes(date, deaths,  color=State, shape=State)) +
                geom_line() +
                geom_point() +
                
                theme_igray() +
                
                labs(
                    y = "Death Counts", x = "") )  
        
    })
    
    
    output$plot2 <- ({
        
        options(scipen = 999)
        
        
        renderPlot(
            dat_overall_pandemic_start() %>% ggplot( aes(date, vaccinated, color=State, shape=State)) +
                geom_line() +
                geom_point() +
                
                
                theme_igray() +
                
                labs(
                    y = "Vaccination Counts", x = "Date") )  
        
    })
    
    
    output$plot3 <- ({
        
        options(scipen = 999)
        
        
        renderPlot(
            dat_overall_pandemic_start() %>% ggplot( aes(date, confirmed,  color=State, shape=State)) +
                geom_line() +
                geom_point() +
                theme_igray() +
                
                labs(
                    y = "Case Counts", x = "") )  
        
    })
    
    
    dat_overall_pandemic <- reactive(
        datastate %>% filter(  (State %in% c(input$state2)) &
                                   (date>=input$dateRange2[1] & date<=input$dateRange2[2]) ))
    
    
    output$TestingChart <- renderPlot({
        
        require(input$chart)
        
        
        if (input$chart == "Bar chart")
        { dat_overall_pandemic() %>%   ggplot(aes(x = date, color = State, fill = State)) +
                
                geom_bar(aes(y = density), stat = "identity") +
                
                theme_minimal()}
        
        
        else if (input$chart == "Area chart")
            
            
        { dat_overall_pandemic() %>%   ggplot(aes(x = date, y = density, color = State, fill = State)) +
                geom_area() +
                #geom_bar(aes(y = density), stat = "identity") +
                
                theme_minimal()}
        
        
    })
    
    
    output$StateConf <- renderHighchart({
        
        
        #removing the first row as it has the totals
        chart_data <- agg[-1,]
        
        hchart(chart_data, "treemap", hcaes(x = State, value = casessum, color = casessum)) %>% 
            hc_add_theme(hc_theme_ffx())
        
        
    })
    
    output$StateDeaths <- renderHighchart({
        
        #removing the first row as it has the totals
        chart_data <- agg[-1,]
        
        hchart(chart_data, "treemap", hcaes(x = State, value = deathsum, color = deathsum)) %>% 
            hc_add_theme(hc_theme_ffx())
        
        
    })
    
    
    output$Statevacc <- renderHighchart({
        
        
        
        #removing the first row as it has the totals
        chart_data <- agg[-1,]
        
        hchart(chart_data, "treemap", hcaes(x = State, value = vcomsum, color = vcomsum)) %>% 
            hc_colorAxis(stops = color_stops(colors = viridis::plasma(30))) %>% 
            hc_add_theme(hc_theme_ffx())
        
        
    })
    
    
    
    output$vac_chart <- renderPlotly({
        
        vac_data <- reactive(
            datastate %>% filter(  (State == c(input$state3)) &
                                       (date>=input$dateRange3[1] & date<=input$dateRange3[2]) )) 
        
        
        fig <- plot_ly(vac_data(), x = ~date, y = ~vaccinated, name = 'Vaccinated', type = 'scatter', mode = 'lines',
                       line = list(color = input$state3, width = 4)) 
        
        fig <- fig %>% add_trace(y = ~actuals.vaccinesDistributed, name = 'Distributed', line = list(color = input$state3, width = 4)) 
        fig <- fig %>% add_trace(y = ~actuals.vaccinationsInitiated, name = 'Initiated', line = list(color = input$state3, width = 4)) 
        
        fig <- fig %>% layout(title = "Vaccination distribution in the US",
                              xaxis = list(title = "Date"),
                              yaxis = list (title = "Count"))
        
        fig
        
        
    })
    
    
    
    bub_data <- reactive(
        meandata %>% filter(  (month == c(input$mon)) &
                                  (year == c(input$year) )))
    
    
    output$bub1 <- renderPlotly({
        
        
        if(input$growth == "Case change rate")
        {
            
            
            
            fig <- plot_ly(bub_data(), x = ~mean_cased, y = ~mean_casew, text= ~conall, type = 'scatter', mode = 'markers',
                           
                           size = ~conall, color = ~State, colors = 'Paired',
                           marker = list(opacity = 0.5, sizemode = 'diameter'))
            fig <- fig %>% layout(title = 'Weekly vs Daily case growth',
                                  xaxis = list(title = "Daily average case rate",showgrid = TRUE),
                                  yaxis = list(title = "Weekly average case rate",showgrid = TRUE),
                                  showlegend = FALSE)
            
            
            
            
            fig}
        
        else if (input$growth == "Death change rate")
            
        { fig2 <- plot_ly(bub_data(), x = ~mean_deathd, y = ~mean_deathw,text=~deathall,  type = 'scatter', mode = 'markers',
                          
                          size = ~deathall, color = ~State, colors = 'Paired',
                          marker = list(opacity = 0.5, sizemode = 'diameter'))
        fig2 <- fig2 %>% layout(title = 'Weekly vs Daily death growth',
                                xaxis = list(title = "Daily average death rate",showgrid = TRUE),
                                yaxis = list(title = "Weekly average death rate",showgrid = TRUE),
                                showlegend = FALSE)
        
        
        
        
        fig2}
        else if (input$growth == "Vaccination change rate")
        { fig3 <- plot_ly(bub_data(), x = ~mean_vacd, y = ~mean_vacw,text=~vacall,  type = 'scatter', mode = 'markers',
                          
                          size = ~vacall, color = ~State, colors = 'Paired',
                          marker = list(opacity = 0.5, sizemode = 'diameter'))
        fig3 <- fig3 %>% layout(title = 'Weekly vs Daily death growth',
                                xaxis = list(title = "Daily average vaccination rate",showgrid = TRUE),
                                yaxis = list(title = "Weekly average vaccination rate",showgrid = TRUE),
                                showlegend = FALSE)
        
        
        
        
        fig3}
    })  
    
    
    
    
    
    
}



