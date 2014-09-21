
args <- commandArgs(trailingOnly = TRUE)

# Load packages

require(chron)
#require(zoo) # only required for rolling mean
require(testthat)
require(methods)

# require(ggplot2) # doesn't support chron objects at present

#expect_is(
#  args, 
#  "character", 
#  info = "Arguments are not a vector of character objects"
#)


a <- read.csv(
  "Log.csv", 
  header = FALSE, 
  sep = ","
)

colnames(a) <- c(
  "timestamp",
  "temp1",
  "temp2",
  "light",
  "humidity",
  "PIR"
)

test_that(
  "Log file is properly formatted.",
{
  expect_that(as.character(a[,'timestamp']),matches("\\d+\\-\\d+\\-\\d+\\ \\d+\\:\\d+\\:\\d+"))
  expect_that(as.character(a[which(!is.na(a[,'temp1'])),3]),matches("\\d+\\.?\\d*"))
  expect_that(as.character(a[,'temp2']),matches("\\d+\\.?\\d+?"))
  expect_that(as.character(a[,'light']),matches("^\\d+"))
  expect_that(as.character(a[,'humidity']),matches("^\\d+\\.?\\d+"))
  expect_that(as.character(a[,'PIR']),matches("^\\d"))
}
)



CurTime <- Sys.time()
CurDate <- Sys.Date()

#a[,1:2] <- cbind(
#  as.character(a[,1]), 
#  as.character(a[,2])
#)


# convert date and time to chron objects

#a$date <- dates(
#  as.character(a$date), 
#  format = "y-m-d"
#)

#a$time <- times(r(
#  as.character(a$time), 
#  format = "h:m:s"
#)

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

temp1 <- subset(a,temp1 > 0 & temp1 < 100,c(timestamp,temp1,PIR))
temp2 <- subset(a,temp2 > 0 & temp2 < 100,c(timestamp,temp2,PIR))
#coreTemp <- subset(a,coreTemp > 0 & coreTemp < 100,c(timestamp,coreTemp))
humidity <- subset(a,humidity > 0 & humidity < 100,c(timestamp,humidity,PIR))
light <- subset(a,light > 0 ,c(timestamp,light,PIR)) # this has been changed!
light$light <- log(light$light) * -1

temp1PIR <- subset(temp1,PIR > 0, c(timestamp,temp1))
lightPIR <- subset(light,PIR > 0, c(timestamp,light))
humidityPIR <- subset(humidity,PIR > 0, c(timestamp,humidity))

# Set graph axes max and min

tempMax <- max(
  #max(coreTemp$coreTemp-25),
  max(temp2$temp2),
  max(temp1$temp1)
) # * 1.025

tempMin <- min(
  #min(coreTemp$coreTemp-25),
  min(temp2$temp2),
  min(temp1$temp1)
) # * 1.025

#tempMax<-max(temp1$temp1) #*1.025
#tempMin<-min(temp1$temp1) #*0.975

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

#par(xpd = TRUE)
#mtext(expression(paste("Core temperature (",degree,"C)")), side = 4, line = 3)
#par(xpd = FALSE)


sapply(
  1:length(temp1PIR[,1]),
  function(x) {
    lines(
      c(temp1PIR[x,1],temp1PIR[x,1]),
      c(0,temp1PIR[x,2]),
      col = "gray50",
      lwd = 0.5
    ) 
  }
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



sapply(
  1:length(humidityPIR[,1]), 
  function(x) {
    lines(
      c(humidityPIR[x,1],humidityPIR[x,1]),
      c(0,humidityPIR[x,2]),
      col = "gray50",
      lwd = 0.5
    )
  }
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




sapply(
  1:length(lightPIR[,1]), 
  function(x) {
    lines(
      c(lightPIR[x,1],lightPIR[x,1]),
      c(-20,lightPIR[x,2]),
      col = "gray50",
      lwd = 0.5
    )
  }
)

points(
  light$timestamp,
  light$light,
  col = "red",
  type = "l"
)


#axis(side=2,at=seq(0,100,1),label=seq(0,100,1)+25, cex.axis = 1,lwd = 0.5)
#axis(side=2,at=seq(0,-20,-2),labels=rev(seq(0,20,2)),las = 2, cex.axis = 0.75,lwd = 0.5)

dev.off()
