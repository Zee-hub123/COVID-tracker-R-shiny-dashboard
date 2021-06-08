#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#






ui <- dashboardPage( skin="blue",
                     dashboardHeader(title = "COVID-19 Dashboard"),
                     dashboardSidebar(
                         sidebarMenu(
                             menuItem("Timeseries", tabName = "timeseries", icon = icon("bar-chart-o")
                                      
                                      
                             ),
                             
                             menuItem("Case density", tabName = "density", icon = icon("gear")),
                             menuItem("Bubble chart", tabName = "bubble", icon  = icon("dashboard", lib="font-awesome")),
                             menuItem("US summary", tabName = "summary", icon = icon("map-marked-alt")),
                             menuItem("Vaccination tracker", tabName = "vaccination", icon = icon("list-alt")),
                             menuItem("About this app", tabName = "about", icon = icon("th"))
                         )),
                     
                     dashboardBody(color = "white",
                                   tabItems(
                                       # First tab content
                                       tabItem(tabName = "timeseries",
                                               h2("COVID-19 timeseries",align="center",style="margin-top:0px;"),
                                               p("(Displays the timeseries data for confirmed cases, deaths and vaccinations)",align="center"),
                                               
                                               fluidRow(
                                                   
                                                   
                                                   
                                                   box(background = "navy" ,
                                                       height = 260,
                                                       
                                                       
                                                       selectInput(inputId = "state",
                                                                   label = "State of interest",
                                                                   choices = datastate$State, selected = "Pennsylvania",
                                                                   multiple = TRUE
                                                       ),
                                                       hr(),
                                                       dateRangeInput('dateRange',
                                                                      label = 'Date range',
                                                                      start = max(datastate$date, na.rm = T)-30, end = max(datastate$date, na.rm = T))
                                                       
                                                   ),
                                                   
                                                   
                                                   
                                                   box(background = "red" ,
                                                       title = "Time series for COVID deaths", solidHeader = TRUE,
                                                       plotOutput("plot1", height = 200)),
                                                   
                                                   box(background = "green" ,
                                                       title = "Time series for COVID vaccinations", solidHeader = TRUE,
                                                       plotOutput("plot2", height = 200)),
                                                   
                                                   box(background = "yellow" ,
                                                       title = "Time series for COVID cases", solidHeader = TRUE,
                                                       plotOutput("plot3", height = 200))
                                               )
                                       ),
                                       
                                       
                                       
                                       tabItem(tabName = "density",
                                               h2("COVID-19 Case density",align="center",style="margin-top:0px;"),
                                               p("(Displays the covid case density using a 7-day rolling average)",align="center"),
                                               
                                               fluidRow(
                                                   
                                                   
                                                   box(background = "navy",
                                                       
                                                       selectInput(inputId = "state2",
                                                                   label = "State of interest",
                                                                   choices = (datastate$State), selected = "Pennsylvania",
                                                                   multiple = TRUE
                                                       ),
                                                       
                                                       
                                                       
                                                       dateRangeInput('dateRange2',
                                                                      label = 'Date range',
                                                                      start = max(datastate$date, na.rm = T)-90, end = max(datastate$date, na.rm = T)),
                                                       
                                                       
                                                       
                                                       radioButtons("chart", "Chart type",
                                                                    
                                                                    c("Bar chart", "Area chart"))
                                                       
                                                       
                                                       
                                                       
                                                       
                                                   ),
                                                   
                                                   box(
                                                       width = 12,
                                                       h3("Case density"),
                                                       p("The number of cases per 100k population calculated using a 7-day rolling average"),
                                                       br(),
                                                       plotOutput("TestingChart")
                                                   )
                                                   
                                                   
                                               )),
                                       
                                       # 2nd tab content
                                       tabItem(tabName = "bubble",
                                               h2("Weekly vs Daily change in cases, deaths and vaccinations", align="center"),
                                               p("(Compares the weekly change rate and the daily change rate by average rate of cases, deaths and vaccinations)",align="center"),
                                               
                                               
                                               fluidRow(
                                                   
                                                   
                                                   
                                                   box(background = "navy" , width = 12,
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       selectInput(inputId = "mon",
                                                                   label = "Select a month",
                                                                   choices = unique(meandata$month)
                                                                   
                                                       ),
                                                       
                                                       selectInput(inputId = "year",
                                                                   label = "Select a year",
                                                                   choices = unique(meandata$year)
                                                                   
                                                       ),
                                                       
                                                       selectInput(inputId = "growth",
                                                                   label = "Select a mean measure",
                                                                   choices = c("Case change rate", "Death change rate", "Vaccination change rate"),
                                                                   selected = "Case change rate"
                                                                   
                                                       )
                                                   ),
                                                   
                                                   
                                                   box( width=12,
                                                        plotlyOutput("bub1"))
                                               )
                                               
                                               
                                       )
                                       
                                       
                                       
                                       
                                       
                                       
                                       
                                       
                                       ,
                                       
                                       # 3rd tab content
                                       tabItem(tabName = "summary",
                                               
                                               fluidRow(
                                                   
                                                   h2("COVID-19 US Summary",align="center",style="margin-top:0px;"),
                                                   p("(Displays the US summary for the most current data | Data refreshes every day)",align="center"),
                                                   
                                                   valueBoxOutput("progressBox"),
                                                   
                                                   valueBoxOutput("progressBox2"),
                                                   
                                                   valueBoxOutput("progressBox3")),
                                               
                                               
                                               
                                               
                                               box(width = 6,
                                                   
                                                   h4("Total number of COVID cases in each US state:"),
                                                   br(),
                                                   highchartOutput("StateConf")
                                               ),
                                               box(width = 6,
                                                   
                                                   h4("Total number of Deaths in each US state:"),
                                                   br(),
                                                   highchartOutput("StateDeaths")
                                               ) ,
                                               
                                               box(width = 12,
                                                   
                                                   h4("Total number of people vaccinated in each US state:"),
                                                   br(),
                                                   highchartOutput("Statevacc")
                                               )),
                                       
                                       # 4th tab content
                                       tabItem(tabName = "vaccination",
                                               
                                               width = 12,
                                               h2("COVID-19 Vaccination tracker",align="center",style="margin-top:0px;"),
                                               p("(Tracks the number of vaccinations initiated, distributed and completed)",align="center")
                                               ,
                                               
                                               fluidRow( 
                                                   box(background = "navy",
                                                       
                                                       selectInput(inputId = "state3",
                                                                   label = "State of interest",
                                                                   choices = unique(datastate$State),
                                                                   selected = "Pennsylvania"
                                                                   
                                                                   
                                                       ),
                                                       
                                                       
                                                       
                                                       dateRangeInput('dateRange3',
                                                                      label = 'Date range',
                                                                      start = max(datastate$date, na.rm = T)-90, end = max(datastate$date, na.rm = T))),
                                                   
                                                   
                                                   box(width = 12,
                                                       plotlyOutput("vac_chart")),
                                                   
                                                   box(width = 12,
                                                       strong("Vaccine Distributed:"),p(" Number of vaccine doses distributed "),
                                                       
                                                       strong("Vaccine Initiated:"),p("Number of vaccinations initiated (This value may vary by type of vaccine, but for Moderna and Pfizer this indicates number of people vaccinated with the first dose.) "),
                                                       
                                                       strong("Vaccine Completed/Vaccinated:"), p("Number of vaccinations completed (This value may vary by type of vaccine, but for Moderna and Pfizer this indicates number of people vaccinated with both the first and second dose.) ")
                                                       
                                                   ))
                                       )
                                       ,
                                       
                                       
                                       
                                       #6th tab content 
                                       tabItem(tabName = "about",
                                               h2("About this app", align="center", style="margin-top:0px;"),
                                               hr(),
                                               strong("Timeseries (Tab 1):"),p("Includes time series data for the COVID cases, COVID deaths and COVID vaccinations 
                                                                     plotted using a multiple line plot. Three multiple line plots are displayed which can be filtered by state
                                                                     and date range using the inputs"),
                                               
                                               strong("Case density (Tab 2):"),p("Includes COVID case density data which is the number of cases per 100k population calculated using a 7-day rolling average. 
                                     An area chart and a stacked bar chart can be displayed based on the state of interest and date range using the inputs"),
                                               
                                               strong("Bubble chart (Tab 3):"),p("Compares the weekly change rate and the daily change rate for COVID cases, deaths and vaccinations by average rate of cases, deaths and vaccinations
                                     for different states. The bubble chart is color coded based on states and the size represents the average rate. For example, for weekly vs daily case growth plot,
                                     the size of the bubble would be the average rate of cases. The input controls include month, year and mean measure."),
                                               
                                               strong("US summary (Tab 4):"),p("Corresponds to the US summary data which summarizes cases, deaths and vaccination data for COVID 19. The top section consists of value boxes corresponding to the up-to-date 
                                     total number of cases, total number deaths and total number of vaccinations completed. Following the values boxes, 3 tree maps are displayed for cases, deaths and vaccinations ordered by the top states.
                                                                     The states are color code based on gradience and total counts. This tab helps you find the leading states with the top cases, deaths and vaccinations. "),
                                               
                                               strong("Vaccination tracker (Tab 5):"),p("Tracks the number of vaccinations initiated, distributed and completed. Description for each variable can be found at the bottom section.
                                                                              The input controls include state of interest and date range.")
                                               
                                               
                                               
                                       )
                                   )
                     )
                     
                     
)
