# WeatherAppMiniProject
Weather App for JP Morgan Chase coding challenge.

# Functionality Overview
I have created a single page weather applicaiton that displays the location, a photo of the weather conditions, and information about the weather conditions, temperature, and humidity.

The location can either be the current location or any location the User searches.

On launch, the application will prompt the User to share their location. If the User shares their location, then the weather for that location is retrieved. If the User does not share their location, then they can input a location they wish to get weather data for.

When the app is reoppened after inactivity, the last searched city will appear.

If the application is closed out (swiped up from applicaiton manager), when the app is opened it will re-prompt the User to share location if the option "Only once" or "Don't share" was chosen for share data permissions on the last launch. Otherwise the app will automatically load with the weather data for the users current location.

# Implementation Details
This App was built using UIKit Framework and Storyboard. I chose this as it was outlined in the specifications that I had to use UIKit.

The App uses a standard View Control that contains components of an UISearchBar, an UIImage, and UILabels. The UISearchBar is used to look up city names, the UILabels are meant to show the data that is retrieved from the OpenWeather API, and the UIImage is meant to display Open Weather's image representation of the corespondant weather condition.

The User's location is retrieved by leveraging the CoreLocation Framework from Apple. This allows for in-built iOS share location prompts as well as facilitates retrieving the location information in the form of coordinates.

In order to retrieve the weather data, the OpenWeather Weather API is being called using the latitude and longitude since the city call is deprecated. To retrieve the location of a given city, the OpenWeather GeoCoder API is being called using the city name to retrieve the latitude and longitude coordinates for a given city. These values are used in the OpenWeather Weather API call. To retrieve the image, the image URL from OpenWeather is being accessed with the value of the image icon being derived from the Weather API response.

