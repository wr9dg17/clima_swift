//
//  WeatherManager.swift
//  clima
//
//  Created by Farid Hamzayev on 27.08.23.
//

import Foundation
import CoreLocation

let appId = ProcessInfo.processInfo.environment["OPEN_WEATHER_APP_ID"] ?? "APP_ID"

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weahterManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=\(appId)&units=metric"
  
  var delegate: WeatherManagerDelegate?
  
  func fetchWeather(cityName: String) {
    let url = "\(weatherUrl)&q=\(cityName)"
    performRequest(with: url)
  }
  
  func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
    let url = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
    performRequest(with: url)
  }
  
  func performRequest(with endpoint: String) {
    if let url = URL(string: endpoint) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      }
      task.resume()
    }
  }
  
  func parseJSON(_ data: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: data)
      let id = decodedData.weather[0].id
      let name = decodedData.name
      let temp = decodedData.main.temp
      
      return WeatherModel(conditionId: id, cityName: name, temperature: temp)
    } catch {
      self.delegate?.didFailWithError(error: error)
      return nil
    }
  }

}
