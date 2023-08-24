//
//  LocationDataManager.swift
//  WeatherAppMiniProject
//
//  Created by Pramith Prasanna on 8/24/23.
//

import Foundation

struct LocationData: Codable {
    let name: String
    let localNames: [String:String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}

// Function to call GeoCoding OpenWeather API given a city name
// Returns object with location details as defined in the struct above
func fetchGeocodingData(city: String, limit: Int, completion: @escaping ([LocationData]?, Error?) -> Void) {
    // Personal API key
    let apiKey = "780dff3019726bc1c13a9b7583949141"
    
    // URL with city input
    // Replace all spaces in city string with "%20" for API call to work
    let apiUrl = "https://api.openweathermap.org/geo/1.0/direct?q=\(city.replacingOccurrences(of: " ", with: "%20"))&limit=\(limit)&appid=\(apiKey)"
    
    // Verify url exists
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
                let coordinateData = try decoder.decode([LocationData].self, from: data)
                completion(coordinateData, nil)
            } catch {
                completion(nil, error)
                print("error")
            }
        }
    }
    
    task.resume()
}

// Function to call reverse GeoCoding OpenWeather API given latitude and longitude
// Returns object with location details as defined in the struct above
func fetchReverseGeocodingData(lat: Double, lon: Double, limit: Int, completion: @escaping ([LocationData]?, Error?) -> Void) {
    // Personal API key
    let apiKey = "780dff3019726bc1c13a9b7583949141"
    
    // API URL with given inputs
    let apiUrl = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=\(limit)&appid=\(apiKey)"
    
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
                let coordinateData = try decoder.decode([LocationData].self, from: data)
                completion(coordinateData, nil)
            } catch {
                completion(nil, error)
                print("error")
            }
        }
    }
    
    task.resume()
}
