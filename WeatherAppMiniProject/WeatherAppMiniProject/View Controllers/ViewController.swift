//
//  ViewController.swift
//  WeatherAppMiniProject
//
//  Created by Pramith Prasanna on 8/24/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var conditionImage: UIImageView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        locationManager.delegate = self
        
        // Request location authorization
        locationManager.requestWhenInUseAuthorization()
        
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            // Check the authorization status
            let authorizationStatus = locationManager.authorizationStatus
            // Wait for authorization status to be determined
            if authorizationStatus == .notDetermined {
                // Request location authorization
                locationManager.requestWhenInUseAuthorization()
            } else if authorizationStatus == .authorizedWhenInUse {
                // Update the weather information with the current location weather
                updateCurrentLocationWeather()
            }
            
        } else {
            // If location services are not allowed display the following
            DispatchQueue.main.sync {
                self.cityLabel.text = "Please Enter City"
            }
        }
    }
    
    // CLLocationManagerDelegate method for location authorization change
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Update the UI with the desired content
            updateCurrentLocationWeather()
        }
    }
    
    // Function to update the labels and image with the current location weather
    func updateCurrentLocationWeather() {
        // Set accuracy to ten meters to be as precise as possible
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // Start updating location
        self.locationManager.startUpdatingLocation()
        
        // Find the latitude and longitude from locationManager
        // If the coordinates are (0,0) that indicates that the locationManager did not retrieve anything
        let lat = Double(locationManager.location?.coordinate.latitude ?? 0)
        let lon = Double(locationManager.location?.coordinate.longitude ?? 0)

        // Make API call to get weather data
        fetchWeatherData(latitude: lat, longitude: lon) { weatherData, error in
            if let weatherData = weatherData {
                // Check if the latitude and longitude values are valid (not 0)
                if (lat != 0 && lon != 0) {
                    // Make API call to get the city name from the latitude and longitude coordinates
                    fetchReverseGeocodingData(lat: lat, lon: lon, limit: 1) { coordinateData, error in
                        if let coordinateData = coordinateData {
                            // Update city name label
                            let city = coordinateData.first?.name
                            // Call populate view function to fill labels/image with appropriate information
                            self.populateView(weatherData: weatherData, city: city)
                        } else if let error = error {
                            print("Geocoding API error: \(error)")
                        }
                    }
                } else if let error = error {
                    print("Weather API error: \(error)")
                }
            }
        }
    }
    
    
    // Function for when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide keyboard after enter
        searchBar.resignFirstResponder()
        
        // Call function to update view with desired values
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
    
    
    // Function to get weather for a given location
    func updateWeatherForLocation (location: String) {
        // Call the API to get location data given a city name
        // Latitude and longitude can be derived from API request
        // Calling based on lat/lon rather than city name due to city name API call deprecation
        fetchGeocodingData(city: location, limit: 1) { coordinateData, error in
            if let coordinateData = coordinateData {
                // Check if city input in search bar actually exists
                if (!coordinateData.isEmpty) {
                    // Call the API to fetch weather data and populate the view with the information given latitude/longitude
                    fetchWeatherData(latitude: coordinateData[0].lat, longitude: coordinateData[0].lon) { weatherData, error in
                        if let weatherData = weatherData {
                            self.populateView(weatherData: weatherData, city: location)
                        } else if let error = error {
                            print("Weather API error: \(error)")
                        }
                    }
                }
            } else if let error = error {
                print("Geocoding API error: \(error)")
            }
        }
    }
    
    // Function to populate the view with weather information
    func populateView (weatherData: WeatherData, city: String?) {
        let imageURL = getImageURL(weatherData: weatherData)
        
        // Download image from URL
        downloadImage(from: imageURL) { image in
            if let image = image {
                // Use the downloaded image
                DispatchQueue.main.sync {
                    self.conditionImage.image = image.resized(to: CGSize(width: 400, height: 400))
                }
            } else {
                print("Failed to download image.")
            }
        }
        
        // Update the labels with the appropriate information as well as the image
        DispatchQueue.main.sync {
            // If the city name in API return object is empty, then display "City Name not Found in API"
            self.cityLabel.text = city ?? "City Name not Found in API"
            
            self.conditionLabel.text = weatherData.weather[0].description
            
            self.temperatureLabel.text = "Temperature: \(Int(weatherData.main.temp)) °F"
            
            self.humidityLabel.text = "Humidity: \(Int(weatherData.main.humidity)) %"
        }
    }
}

// Function to resize image to take up majority of screen
extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// Function to store last searched value to load on app re-launch
extension ViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Update the saved value
        UserDefaults.standard.set(searchText, forKey: "lastSearchValue")
    }
}

