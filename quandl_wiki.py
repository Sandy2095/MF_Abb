import quandl
#quandl.ApiConfig.api_key = "XyzymywJ-RCEhbgUPZmo"
data = quandl.get("EIA/PET_RWTC_D",returns="numpy")
print data
