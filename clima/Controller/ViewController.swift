//
//  ViewController.swift
//  clima
//
//  Created by Farid Hamzayev on 26.08.23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  
  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
    
    searchTextField.delegate = self
    weatherManager.delegate = self
  }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
  @IBAction func locationPressed(_ sender: UIButton) {
    locationManager.requestLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      weatherManager.fetchWeather(lat: lat, lon: lon)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  @IBAction func searchPressed(_ sender: UIButton) {
    searchTextField.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      textField.placeholder = "Type something"
      return false
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let city = searchTextField.text {
      weatherManager.fetchWeather(cityName: city)
    }
    searchTextField.text = ""
  }
}

// MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager,  weather: WeatherModel) {
    DispatchQueue.main.async {
      self.conditionImageView.image = UIImage(systemName: weather.conditionName)
      self.temperatureLabel.text = weather.temperatureString
      self.cityLabel.text = weather.cityName
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
}
