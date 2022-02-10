#!/usr/bin/env python3
import cgi,html,requests

form = cgi.FieldStorage()
address = form.getfirst("address","empty")
api_key = form.getfirst("key","AIzaSyBv7R9-p35bGzPmoiBEBMMINo6iPbKShBk")

# ----------------------------------------------------
url = 'https://maps.googleapis.com/maps/api/geocode/json'

params={'key':api_key,'address':address}
response = requests.get(url,params=params)
response.raise_for_status
print(response.status_code)
data=response.json()

# ----------------------------------------------------
formatted_address=data['results'][0]['formatted_address']
latitude=data['results'][0]['geometry']['location']['lat']
longitude=data['results'][0]['geometry']['location']['lng']
print("Content-type:text/html\n")
print("""<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Geocoding of places</title>
  </head>
  <body>""")
print()
print("<h1>Processing of form data</h1>")
print("<h4>You was finding coordinates for the place:</h4>")
print("<p>address: {}</p>".format(formatted_address))
print("<p>latitude: {}</p>".format(latitude))
print("<p>longitude: {}</p>".format(longitude))
# print("<p>data: {}</p>".format(data))

print("""</body>
</html>""")