//
//  WeatherDataManager.swift
//  WeatherAppMiniProject
//
//  Created by Pramith Prasanna on 8/24/23.
//

import Foundation

struct WeatherData: Codable {
    var coord: Coord
    var weather: [Weather]
    var main: Main
    var wind: Wind
    var clouds: Clouds
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct Clouds: Codable {
        let all: Int
    }
}

// Function to retrieve weather data from OpenWeather API given latitude and longitude
// Return object with weather details as defined in the struct above
func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData?, Error?) -> Void) {
    // Personal API key
    let apiKey = "780dff3019726bc1c13a9b7583949141"
    
    // URL with given input
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
    
    guard let url = URL(string: apiUrl) else {
        completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        return
    }

    // Decode response
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }

        if let data = data {
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData, nil)
            } catch {
                completion(nil, error)
                print("error")
            }
        }
    }

    task.resume()
}
