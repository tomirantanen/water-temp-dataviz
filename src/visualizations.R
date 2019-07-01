# Scripts for visualizations

# Start with empty workspace
rm(list = ls(all = TRUE)) 

# Set your workspace directory here
# setwd("/your/path/here/water-temp-dataviz/src")

source("functions.R")

temperatures <- read.csv(file = "../data/temperatures.csv", header = TRUE, sep = ",")

# Cleanup data by removing first month and future months. 
temperatures <- subset(temperatures, !(datetime %in% c("2014-01", "2019-07", "2019-08", "2019-09", "2019-10", "2019-11", "2019-12")))

# Highest maximum temperature
temperatures[which.max(temperatures$maximum), ]
head(temperatures[order(temperatures$maximum, decreasing = TRUE), ])

# Lowest minimum temperature
temperatures[which.min(temperatures$minimum), ]
head(temperatures[order(temperatures$minimum), ])

# Highest and lowest average temperature
temperatures[which.max(temperatures$average), ]
temperatures[which.min(temperatures$average), ]
head(temperatures[order(temperatures$average, decreasing = TRUE), ], n = 20)
head(temperatures[order(temperatures$average), ], n = 20)

# Calculate average August and January temperatures for each area.
augustTemperatures <- subset(temperatures, (datetime %in% c("2014-08", "2015-08", "2016-08", "2017-08", "2018-08")))
januaryTemperatures <- subset(temperatures, (datetime %in% c("2014-01", "2015-01", "2016-01", "2017-01", "2018-01", "2019-01")))

# Barplot first half of the data
barPlotTemperatures(augustTemperatures, januaryTemperatures, isHead = TRUE)

# Barplot second half of the data
barPlotTemperatures(augustTemperatures, januaryTemperatures, isHead = FALSE)

# All areas in a single line graph. Note: Takes a while to draw all lines
plotAllAreas(temperatures)

# Min, max and averages as line graph
plotArea(temperatures[temperatures$area == 'tohloppi', ], "Tohloppi")
plotArea(temperatures[temperatures$area == 'hervanta', ], "Hervanta")

# Interactive line graph about Hervanta (Eastern Tampere) and Tohloppi (Western Tampere)
plotInteractive(temperatures)

# Histogram of the average temperatues
hist(temperatures$average)
