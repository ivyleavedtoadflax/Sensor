
args <- commandArgs(trailingOnly = TRUE)

# Load packages

require(testthat)
require(methods)
require(chron)

a <- read.csv(
  "Log.csv", 
  header = FALSE, 
  sep = ","
)

colnames(a) <- c(
  "timestamp",
  "temp1",
  "temp2",
  "temp3",
  "light",
  "humidity"
)

#test_that(
#  "Log file is properly formatted.",
#{
#  expect_that(as.character(a[,'timestamp']),matches("\\d+\\-\\d+\\-\\d+\\ \\d+\\:\\d+\\:\\d+"))
#  expect_that(as.character(a[which(!is.na(a[,'temp1'])),3]),matches("\\d+\\.?\\d*"))
#  expect_that(as.character(a[which(!is.na(a[,'temp2'])),3]),matches("\\d+\\.?\\d*"))
#  expect_that(as.character(a[which(!is.na(a[,'temp3'])),3]),matches("\\d+?\\.?\\d*"))
#  expect_that(as.character(na.omit(a[,'light'])),matches("^\\d+"))
#  expect_that(as.character(a[,'humidity']),matches("^\\d+\\.?\\d+"))
#}
#)

CurTime <- Sys.time()
CurDate <- Sys.Date()

a$timestamp <- strptime(as.character(a$timestamp),format = "%Y-%m-%d %H:%M:%S")

# Check argument and produce graphs accordingly:

if (args[1] == "all") {
  
  message("Using whole time sequence.")
  
} else if (args[1] == "today") {
  
  a <- subset(
    a, 
    date == as.chron(CurDate)
  )
  
  message(
    paste(
      "Using only data from ",
      CurDate,
      ".",
      sep = ""
    )  
  )
  
} else if (attr(regexpr("^\\d+\\-\\d+\\-\\d+$",args[1]), "match.length") == 10) {
  
  
  test_that(
    "Argument is a properly formatted date",    
    expect_that(args[1],matches("^\\d+\\-\\d+\\-\\d+$"))    
  )
  
  a <- subset(
    a,
    date > strptime(args[1],format="%Y-%m-%d")
  )
  

message(
  paste(
    "Using data since ",
    args[1],
    ".",
    sep = ""
  )  
)


} else if (attr(regexpr("\\d+",args[1]), "match.length") <= 4) {
  
  a <- subset(
    a,
    date = (CurDate - as.numeric(args[1]))
  )
  
  message(
    paste(
      "Using only data from ",
      CurDate - as.numeric(args[1]),
      ".",
      sep = ""
    )  
  )
  
} else error("Argument one did not match possible options: all, today, yyyy-mm-dd, n (of days before today).")


#Create subsets for plotting - actually this would be much better in dplyr,
#however the R version available on the Rpi does not support dplyr

temp1 <- subset(a,temp1 > 0 & temp1 < 100,c(timestamp,temp1))
temp2 <- subset(a,temp2 > 0 & temp2 < 100,c(timestamp,temp2))
temp3 <- subset(a,temp3 > 0 & temp2 < 100,c(timestamp,temp3))
humidity <- subset(a,humidity > 0 & humidity < 100,c(timestamp,humidity))
light <- subset(a,light > 0 ,c(timestamp,light)) # this has been changed!
light$light <- log(light$light) * -1

# Set graph axes max and min

tempMax <- max(
  #max(coreTemp$coreTemp-25),
  max(temp2$temp2),
  max(temp1$temp1),
  max(temp3$temp3)
)

tempMin <- min(
  #min(coreTemp$coreTemp-25),
  min(temp2$temp2),
  min(temp1$temp1),
  min(temp3$temp3)
)

png(
  "/var/www/gfx/daily_temp_plot.png", 
  width = 6, 
  height = 4.5, 
  units = "in", 
  res = 200
)	 

par(
  mar = c( 5.1, 4.1, 3.1, 4.1),
  lend = "square"
)

plotTemp <- plot(
  temp1$timestamp,
  temp1$temp1,
  xlab = "Date/Time",
  ylab = expression(paste("Ambient temperature (",degree,"C)")),
  pch = 16,
  col = "blue",
  type = "n",
  ylim = c(tempMin,tempMax),
  main = CurTime
)

points(
  temp1$timestamp,
  temp1$temp1,
  col = "blue",
  type = "l"
)

points(
  temp2$timestamp,
  temp2$temp2,
  col = "blue",
  type = "l",
  lty = 3
)

points(
  temp3$timestamp,
  temp3$temp3,
  col = "red",
  type = "l",
  lty = 1
)


dev.off()

png("/var/www/gfx/daily_humidity_plot.png",width=6,height=4.5,units="in",res=200)	

par(
  mar = c( 5.1, 4.1, 3.1, 4.1),
  lend = "square"
)

plot(
  humidity$timestamp,
  humidity$humidity,
  xlab = "Date/Time",
  ylab = "Relative humidity (%)",
  pch = 16,
  col = "red",
  type = "n"
)

points(
  humidity$timestamp,
  humidity$humidity,
  col = "green",
  type = "l"
)

dev.off()

png("/var/www/gfx/daily_light_plot.png",width=6,height=4.5,units="in",res=200)

par(
  mar = c( 5.1, 4.1, 3.1, 4.1),
  lend = "square"
)

plot(
  light$timestamp,
  light$light,
  xlab = "Date/Time",
  ylab = "Relative light values",
  pch = 16,
  col = "red",
  type = "n"
)

points(
  light$timestamp,
  light$light,
  col = "red",
  type = "l"
)

dev.off()
