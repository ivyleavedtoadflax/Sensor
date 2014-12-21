# Load packages

require(testthat)
require(methods)

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

a$timestamp <- strptime(as.character(a$timestamp),format = "%Y-%m-%d %H:%M:%S")

a$light <- log(a$light)

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

# bedtime
points(
  a[which(bla < -4.5), 
    c("timestamp","light")]
)

# home from work

points(
  a[which(bla > 1.5), 
    c("timestamp","light")]
)




# Possible algorithm for detecting daylight!?

# bla <- a$light[1:nrow(a)]-c(a$light[2:nrow(a)],0)
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

