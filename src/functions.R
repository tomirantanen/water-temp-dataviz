# Functions for creating plots and doing calculations for the temperature data.

library("dygraphs")

getMeanTemperaturesPerYear <- function(temperatures) {
  # Calculate mean temperatures for each area.
  #
  # Args:
  #   temperatures: Temperatures as a dataframe.
  #
  # Returns:
  #   Mean temperatures for each area in a data frame.
  areas <- unique(temperatures$area)
  totalMeans <- data.frame()

  for (area in areas) {
    temp <- data.frame("average" = mean(temperatures[temperatures$area == area, ]$average), "area" = area)
    totalMeans <- rbind(totalMeans, temp)
  }
  return(totalMeans)
}

plotAllAreas <- function(temperatures) {
  # Plot all area temperatures in a single graph.
  #
  # Args:
  #   temperatures: Temperatures as a dataframe.

  areas <- unique(temperatures$area)
  tsTemperatures <- list(NULL)

  for (i in 1:length(areas)) {
    if (i != 1) {
      par(new = TRUE)
    }
    tsTemperatures[[i]] <- ts(
      temperatures$average[temperatures$area == areas[i]],
      frequency = 12,
      start = c(2014, 2)
    )
    plot(tsTemperatures[[i]], ylab = "Temperature", ylim = c(0, 22),
         main = "Average water temperatures", col = "#22A7F0")
  }
}

plotArea <- function(areaTemperatures, plotTitle = "") {
  # Plot min, max and average water temperature lines for single area.
  #
  # Args:
  #   areaTemperatures: Temperatures as a dataframe.
  #   plotTitle: Title of the plot
  plot(0, 0, xlim = c(0, 55), ylim = c(0, 25),
       ylab = expression("Temperature " (degree~C)),
       main = plotTitle) 

  lines(areaTemperatures$average, col = "black")
  lines(areaTemperatures$maximum, col = "red")
  lines(areaTemperatures$minimum, col = "blue")
}

barPlotTemperatures <- function(temperaturesBack, temperaturesFront, isHead = TRUE) {
  # Barplot yearly average temperatures of two months for each area
  #
  # Args:
  #   temperaturesBack: Yearly temperatures of certain month for each area as a data frame.
  #                     These temperatures are plotted on the background of the barplot.
  #   temperaturesFront: Yearly temperatures of certain month for each area as a data frame.
  #                     These temperatures are plotted on the foreground of the barplot.
  #   isHead: Defines if the first half of the data is plotted or the second half.
  #           This is used because all the data could not fit into single barplot.
  meanTemperaturesBack <- getMeanTemperaturesPerYear(temperaturesBack)
  meanTemperaturesFront <- getMeanTemperaturesPerYear(temperaturesFront)

  areaCount <- length(unique(temperaturesBack$area))
  plotLimit <- round(areaCount / 2)

  if (isHead) {
    valuesBack <- head(meanTemperaturesBack$average, n = plotLimit)
    namesBack <- head(meanTemperaturesBack$area, n = plotLimit)
    valuesFront <- head(meanTemperaturesFront$average, n = plotLimit)
    namesFront <- head(meanTemperaturesFront$area, n = plotLimit)
  } else {
    valuesBack <- tail(meanTemperaturesBack$average, n = plotLimit)
    namesBack <- tail(meanTemperaturesBack$area, n = plotLimit)
    valuesFront <- tail(meanTemperaturesFront$average, n = plotLimit)
    namesFront <- tail(meanTemperaturesFront$area, n = plotLimit)
  }

  par(mar = c(10.1, 4.1, 4.1, 2.1)) # Increase bottom margin to make room for the area names

  # Background data plot
  barplot(valuesBack,
          names.arg = namesBack,
          las = 2,
          col = "#D24D57",
          ylim = c(0, 23),
          space = 0,
          ylab = expression("Temperature " (degree~C)))

  # legend("topright", legend = c("August", "January"), fill = c("#D24D57", "#22A7F0"))
  par(new = TRUE)

  # Foreground data plot
  barplot(
    valuesFront,
    names.arg = namesFront,
    las = 2,
    col = "#22A7F0",
    ylim = c(0, 23),
    space = 0,
    main = "Average water temperatures"
  )

  title(xlab = "Area", line = 8, cex.lab = 1.2)
}

plotInteractive <- function(temperatures) {
  areas <- unique(temperatures$area)

  # Create timeseries of averages
  tsTemperatures <- list(NULL)
  for (i in 1:length(areas)) {
    tsTemperatures[[i]] <- ts(
      temperatures$average[temperatures$area == areas[i] ],
      frequency = 12,
      start = c(2014, 2)
    )
  }

  dygraph(cbind(Hervanta = tsTemperatures[[which(areas == "hervanta")]],
                Tohloppi = tsTemperatures[[which(areas == "tohloppi")]]),
          xlab = "Time",
          ylab = "Temperature")
}
