#!/bin/python

import urllib.request, json

city = "Bangalore"
api_key = "3c8b877e43313a018760ca0d232c1319"
units = "Metric"
unit_key = "C"

try:
    weather = eval(str(urllib.request.urlopen("http://api.openweathermap.org/data/2.5/weather?q={}&APPID={}&units={}".format(city, api_key, units), timeout=5).read())[2:-1])

    info = weather["weather"][0]["description"].capitalize()
    temp = int(float(weather["main"]["temp"]))

    print("%s, %i°%s" % (info, temp, unit_key))

except Exception as e:
    print("Weather not available")
