# A Script for downloading monthly water temperatures from Vellamo API

library(jsonlite)

getTemperatures <- function(areas) {
  # Fetches monthly temperature history data from Vellamo API.
  #
  # Args:
  #   areas: List of area names for which the data is fetched.
  #
  # Returns:
  #   Temperatures for each area in a list.
  temperatures <- list()

  print(paste("Downloading temperature history data for", length(areas), "areas...", sep = " "))
  for (i in 1:length(areas)) {
    print(paste(i, "/", length(areas), " ", areas[i], sep = ""))
    temperatures[[i]] <- fromJSON(paste("https://vellamo.tampere.fi/api/v1/area/", areas[i], "/t/month.json", sep = ""))
  }
  return(temperatures)
}

getFlattenedDataframe <- function(temperatures) {
  # Flattens the monthly temperature data into a single dataframe.
  #
  # Args:
  #   temperatures: List of temperatures for each area.
  #
  # Returns:
  #   Temperatures as a flattened dataframe
  temperaturesDf <- data.frame()

  for (areaData in temperatures) {
    df <- do.call(rbind.data.frame, areaData$groups$values)
    area <- areaData$area
    df <- cbind(df, area) # Add area name to one column
    temperaturesDf <- rbind(temperaturesDf, df)
  }
  return(temperaturesDf)
}

main <- function() {
  areas <- jsonlite::fromJSON("https://vellamo.tampere.fi/api/v1/areas.json")
  temperatures <- getTemperatures(areas$slug)
  temperaturesDf <- getFlattenedDataframe(temperatures)
  write.csv(temperaturesDf, file = "../data/temperatures.csv")
}

main()
