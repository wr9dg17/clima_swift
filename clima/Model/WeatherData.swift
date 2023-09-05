//
//  WeatherData.swift
//  clima
//
//  Created by Farid Hamzayev on 28.08.23.
//

import Foundation

struct WeatherData: Codable {
  let name: String
  let main: MainData
  let weather: [WeatherInfo]
}

struct MainData: Codable {
  let temp: Double
}

struct WeatherInfo: Codable {
  let id: Int
}
