
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

test_that(
  "Log file is properly formatted.",
{
  expect_that(as.character(a[,1]),matches("^\\d+\\-\\d+\\-\\d+$"))
  expect_that(as.character(a[,2]),matches("^\\d+\\:\\d+\\:\\d+$"))
  expect_that(as.character(a[which(!is.na(a[,3])),3]),matches("\\d+\\.?\\d*"))
  expect_that(as.character(a[,4]),matches("\\d+\\.?\\d+?"))
  expect_that(as.character(a[,5]),matches("^\\d+"))
  expect_that(as.character(a[,6]),matches("^\\d+\\.?\\d+"))
  expect_that(as.character(a[,7]),matches("^\\d"))
}
)

CurTime <- Sys.time()
CurDate <- Sys.Date()

a[,1:2] <- cbind(
  as.character(a[,1]), 
  as.character(a[,2])
)

colnames(a) <- c(
  "date",
  "time",
  "temp1",
  "temp2",
  "light1",
  "humidity",
  "PIR"
)

# convert date and time to chron objects

a$date <- dates(
  as.character(a$date), 
  format = "y-m-d"
)

a$time <- times(
  as.character(a$time), 
  format = "h:m:s"
)

a$timestamp <- chron(
  a$date, 
  a$time
)

a$light <- log(a$light1)

bla <- a$light[1:nrow(a)]-c(a$light[2:nrow(a)],0)
bla <- bla[-length(bla)]

plot(
  a$timestamp,
  a$light,
  type = "l",
  ylim=c(15,3)
)


which(bla < -3)

  plot(
    bla, 
    type = "l"
  )

plot(
  a$timestamp,
  a$light,
  type = "l",
  ylim=c(15,3)
)

# This figure may need some calibration, but -4.5 seems to be about right... 
# Might be better to edit algorithm so the latest value in each day over a 
# certain threshold is used

points(
  a[which(bla < -4.5), 
    c("timestamp","light")]
)

lines(
  rep(
    a[which(bla < -4.5), 
    c("timestamp","light")]
    ,
    each = 2
    )
)




# Possible algorithm for detecting daylight!?

# bla <- a$light1[1:nrow(a)]-c(a$light1[2:nrow(a)],0)
# bla <- bla[-length(bla)]
# 
# plot(
#   a$timestamp,
#   a$light,
#   type = "l",
#   ylim=c(15,3)
# )
# 
# points(
#   a[which(bla < -80000), 
#     c("timestamp","light")]
# )
#      

