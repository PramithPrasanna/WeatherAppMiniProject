//
//  ImageDataManager.swift
//  WeatherAppMiniProject
//
//  Created by Pramith Prasanna on 8/24/23.
//

import Foundation
import UIKit

// Function to get Image URL given a WeatherData object
func getImageURL(weatherData: WeatherData) -> URL {
    // Retrieve the icon value and input it into given url string
    let urlString = "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png"
    return URL(string: urlString)!
}

// Function to download image from internet given a specific URL
func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Image download error: \(error.localizedDescription)")
            return
        }
        
        if let data = data, let image = UIImage(data: data) {
            completion(image)
        } else {
            completion(nil)
        }
    }.resume()
}
