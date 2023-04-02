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




#* @get /update
function() {
  sheet <- gs4_get("1eHMuNzFxombsNDxCgL-UDdOPnDua8LC3F1CuQbLmijU")
  data <- read_sheet(sheet)
  
  newdata <- with(
    data,
    anthro_zscores(
      sex = sexo_num, age = edad_dias,
      weight = `Ingrese el peso`, lenhei = `Ingrese la altura`, measure = measure, headc = `circunferencia de la cabeza`,
      armc = `circunferencia braquial`, oedema = oedema
    )
  )
  names(newdata)[names(newdata) %in% c("zlen", "zwei", "zwfl","zbmi","zhc","zac" )] <- c("HAZ", "WAZ", "WHZ","BAZ","HCZ","MUACZ")
  
  data <- cbind(data[, c(1,2,3,4,5,6,7,8,9,10, 11,12,13,14,15)], newdata)
  
  write_sheet(data, sheet, sheet = "datos")
  
  return("procesado exitos")
  
}
#* @get /csv
#* @csv
function(res){

  data <- read.csv('https://kf.kobotoolbox.org/api/v2/assets/a3MRsgwdgcjD5c2qKzdNS4/export-settings/esSPAby29U5Tbhyr63iLZft/data.csv',  sep = ";")
  
  newdata <- with(
    data,
    anthro_zscores(
      sex = sexo_num, age = edad_dias,
      weight = Ingrese.el.peso, lenhei = Ingrese.la.altura, measure = measure, headc = circunferencia.de.la.cabeza,
      armc = circunferencia.braquial, oedema = oedema
    )
  )
  names(newdata)[names(newdata) %in% c("zlen", "zwei", "zwfl","zbmi","zhc","zac" )] <- c("HAZ", "WAZ", "WHZ","BAZ","HCZ","MUACZ")
  
  data <- cbind(data[, c(1,2,3,4,5,6,7,8,9,10, 11,12,13,14,15)], newdata)
  
  
  filename <- tempfile(fileext = ".csv")
  write.csv(data, filename, row.names = FALSE)
  include_file(filename, res, "text/csv")
}
