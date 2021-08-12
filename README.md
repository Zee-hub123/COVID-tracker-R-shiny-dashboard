# COVID-tracker-R-shiny-dashboard
COVID tracker R shiny dashboard

This app consists of 5 different tabs.

About this app:

Timeseries (Tab 1):
Includes time series data for the COVID cases, COVID deaths and COVID vaccinations plotted using a multiple line plot. Three multiple line plots are displayed which can be filtered by state and date range using the inputs


![image](https://user-images.githubusercontent.com/72050449/129120558-8b24f9fe-036c-4bc3-bfca-b017dfe77106.png)


Case density (Tab 2):
Includes COVID case density data which is the number of cases per 100k population calculated using a 7-day rolling average. An area chart and a stacked bar chart can be displayed based on the state of interest and date range using the inputs


![image](https://user-images.githubusercontent.com/72050449/129120873-2f850b3b-4ca2-40c6-99bd-f8a7c0c0273b.png)


Bubble chart (Tab 3):
Compares the weekly change rate and the daily change rate for COVID cases, deaths and vaccinations by average rate of cases, deaths and vaccinations for different states. The bubble chart is color coded based on states and the size represents the average rate. For example, for weekly vs daily case growth plot, the size of the bubble would be the average rate of cases. The input controls include month, year and mean measure.


![image](https://user-images.githubusercontent.com/72050449/129120975-07afe340-a663-47cb-a9cd-c398dd9b20c5.png)


US summary (Tab 4):
Corresponds to the US summary data which summarizes cases, deaths and vaccination data for COVID 19. The top section consists of value boxes corresponding to the up-to-date total number of cases, total number deaths and total number of vaccinations completed. Following the values boxes, 3 tree maps are displayed for cases, deaths and vaccinations ordered by the top states. The states are color code based on gradience and total counts. This tab helps you find the leading states with the top cases, deaths and vaccinations.

![image](https://user-images.githubusercontent.com/72050449/129121050-c67a37e4-32fe-4073-b7cf-045f6b4514a4.png)


Vaccination tracker (Tab 5):
Tracks the number of vaccinations initiated, distributed and completed. Description for each variable can be found at the bottom section. The input controls include state of interest and date range.


![image](https://user-images.githubusercontent.com/72050449/129121099-44f03347-af84-4499-9317-0d82f75b6742.png)

