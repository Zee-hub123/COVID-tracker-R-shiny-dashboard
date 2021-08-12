

#Load the packages required for this app
#load the libraries


if(!require(ggthemes)) install.packages("ggthemes", repos = "http://cran.us.r-project.org")
if(!require(tidyr)) install.packages("tidyr", repos = "http://cran.us.r-project.org")
if(!require(readxl)) install.packages("readxl", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(maps)) install.packages("maps", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(stringr)) install.packages("stringr", repos = "http://cran.us.r-project.org")
if(!require(purrr)) install.packages("purr", repos = "http://cran.us.r-project.org")
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(rlang)) install.packages("rlang", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(highcharter)) install.packages("highcharter", repos = "http://cran.us.r-project.org")
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(rsconnect)) install.packages("rsconnect", repos = "http://cran.us.r-project.org")
if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")





#Data manipulation

state <- read.csv("https://raw.githubusercontent.com/Zee-hub123/COVID-tracker-R-shiny-dashboard/main/statecodes.csv")



#creating a new dataset by joining with the state name dataset
#urlall = "https://api.covidactnow.org/v2/states.timeseries.csv?apiKey=e82277772cee436d8ef9aab5d0eaa1e7"
#stateall <-  read_csv(url(urlall))

urlall = "https://api.covidactnow.org/v2/states.timeseries.csv?apiKey=e82277772cee436d8ef9aab5d0eaa1e7"
stateallcsv <-  read_csv(url(urlall))

saveRDS(stateallcsv, file = "stateallcsv.rds")
stateall <- readRDS("stateallcsv.rds")



#memory.limit(9999)

names(stateall)[names(stateall) == "state"] <- "StateCode"

names(state)[names(state) == "Code"] <- "StateCode"

datastate <- left_join(stateall,state, by= c("StateCode"))

#View(datastate)

state_list <- c(levels(as.factor(datastate$State)))
#state_list

#changing the names of the variables
names(datastate)[names(datastate) == "actuals.cases"] <- "confirmed"
names(datastate)[names(datastate) == "actuals.deaths"] <- "deaths"
names(datastate)[names(datastate) == "actuals.vaccinationsCompleted"] <- "vaccinated"
names(datastate)[names(datastate) == "metrics.caseDensity"] <- "density"


#mutating the values

summary <- datastate %>% 
  group_by(State) %>%
  arrange(State, date) %>%
  mutate(newcases = confirmed - lag(confirmed,1),
         newdeaths = deaths - lag(deaths,1),
         positive = actuals.positiveTests - lag(actuals.positiveTests,1),
         vaccinecomplete = vaccinated - lag(vaccinated,1),
         vaccineinitiated = actuals.vaccinationsInitiated - lag(actuals.vaccinationsInitiated,1),
         vaccinedistributed = actuals.vaccinesDistributed - lag(actuals.vaccinesDistributed,1))
statesum <- subset(summary, 
                   select=c(State,newcases,newdeaths, positive, vaccinecomplete,vaccineinitiated,vaccinedistributed, date))
#View(statesum)


#converting NA to 0
d <- as.data.frame(statesum)
d[is.na(d)] <- 0

#summing the data
agg <- d %>%
  group_by(State) %>%
  summarize(casessum = sum(newcases, na.rm = TRUE),
            deathsum = sum(newdeaths, na.rm = TRUE),
            possum = sum(positive, na.rm = TRUE ),
            vcomsum = sum(vaccinecomplete, na.rm = TRUE),
            vinitsum = sum(vaccineinitiated, na.rm = TRUE),
            vindistsum = sum(vaccinedistributed, na.rm = TRUE))




us_states <- map_data("state")

df <- datastate

# Compute weekly & daily growth rates
map_df <- df %>% 
  group_by(State) %>%
  arrange(State, date) %>%
  mutate(Weekly_casegrowth = round((confirmed-lag(confirmed,7))/lag(confirmed,7)*100,1),
         Daily_casegrowth = round((confirmed-lag(confirmed,1))/lag(confirmed,1)*100,1),
         Weekly_vaccinationgrowth = round((vaccinated-lag(vaccinated,7))/lag(vaccinated,7)*100,1),
         Daily_vaccinationgrowth = round((vaccinated-lag(vaccinated,1))/lag(vaccinated,1)*100,1),
         Weekly_deceasedgrowth = round((deaths-lag(deaths,7))/lag(deaths,7)*100,1),
         Daily_deceasedgrowth = round((deaths-lag(deaths,1))/lag(deaths,1)*100,1)
  )

#View(map_df)
datanew <- map_df[c(-6,-7)]

datanew$region <- tolower(datanew$State)
map_df1 <- left_join(us_states, datanew, by="region", sep = " ", collapse= NULL)

#memory.limit(99999)

#View(map_df1)



m <- subset(map_df1, 
            select=c(State, StateCode,vaccinated, deaths, confirmed, Weekly_casegrowth, Daily_casegrowth,
                     Weekly_vaccinationgrowth, Daily_vaccinationgrowth, Weekly_deceasedgrowth, Daily_deceasedgrowth, date))

m$date <- as.Date(m$date)

mon <- m %>% 
  mutate(month = format(m$date,"%m")) %>%
  mutate(year = format(m$date,"%Y"))

mon$month = as.numeric(mon$month)
mon$year = as.numeric(mon$year)

#View(mon)
mon$month = month.abb[mon$month]



#View(meandata)

meandata <- mon %>%
  group_by(StateCode, State, month, year) %>%
  summarize(mean_casew = mean(Weekly_casegrowth, na.rm = TRUE),
            mean_cased = mean(Daily_casegrowth, na.rm = TRUE),
            mean_deathw = mean(Weekly_deceasedgrowth, na.rm = TRUE),
            mean_deathd = mean(Daily_deceasedgrowth, na.rm=TRUE),
            mean_vacw = mean(Weekly_vaccinationgrowth, na.rm =TRUE),
            mean_vacd = mean(Daily_vaccinationgrowth, na.rm =TRUE),
            conall = mean(confirmed, na.rm =TRUE),
            deathall = mean(deaths, na.rm = TRUE),
            vacall = mean(vaccinated, na.rm=TRUE)) 


#removing the last row with NAs
meandata <- head(meandata, -1)

# Run the application 
#shinyApp(ui = ui, server = server)
