#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(googledrive)
library(googlesheets4)
library(anthro)

options(gargle_oauth_cache = ".secrets")
drive_auth(cache = ".secrets", email = "diegoroman199@gmail.com")
gs4_auth(token = drive_token())


#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
    list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
    rand <- rnorm(100)
    hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
    as.numeric(a) + as.numeric(b)
}

# Programmatically alter your API
#* @plumber
function(pr) {
    pr %>%
        # Overwrite the default serializer to return unboxed JSON
        pr_set_serializer(serializer_unboxed_json())
}


#* @get /update
function() {
  sheet <- gs4_get("1eHMuNzFxombsNDxCgL-UDdOPnDua8LC3F1CuQbLmijU")
  data <- read_sheet(sheet)
  
  newdata <- with(
    data,
    anthro_zscores(
      sex = sexo_num, age = ageD,
      weight = Weight, lenhei = Height
    )
  )
  
  data <- cbind(data[, c(1,2,3,4,5,6,7,8,9,10, 11,12,13)], newdata)
  
  write_sheet(data, sheet, sheet = "datos")
  
  return("procesado exitos")
  
}
