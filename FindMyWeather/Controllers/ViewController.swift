//
//  ViewController.swift
//  FindMyWeather
//
//  Created by Bhavna Mohan on 15/01/19.
//  Copyright © 2019 Bhavna Mohan. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,CLLocationManagerDelegate,ChangeLocationDelegate {

    //IBOutlets and Variable Declaration :
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentWeatherCondition: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var toggleTemp: UISwitch!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var pressureValue: UILabel!
    @IBOutlet weak var maxTempValue: UILabel!
    @IBOutlet weak var minTempValue: UILabel!
    
    let locationManager = CLLocationManager()
    let weatherData = WeatherData()
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        toggleTemp.isOn = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK : Location Manager didUpdate Location
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
    if location.horizontalAccuracy > 0 {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        let params : [String : String] = ["lat" : String(location.coordinate.latitude),"lon" : String(location.coordinate.longitude),"appid" : APP_ID]
        getDataFromOpenWeatherMaps(weatherURL : WEATHER_URL,parameters: params)
    }
    }
    
    func getDataFromOpenWeatherMaps(weatherURL : String,parameters : [String : String]) {
        Alamofire.request(weatherURL, method: .get, parameters: parameters).responseJSON {
            response in
                if response.result.isSuccess {
                    let weatherJSON = JSON(response.result.value!)
                    self.updateWeatherData(json: weatherJSON)
                }
                else {
                    print("Error : \(response.result.error!)")
                    self.currentLocation.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json : JSON) {
        if let temp = json["main"]["temp"].double {
            weatherData.temperature = Int(temp - 273.15)
            if json["name"].stringValue != ""{
                weatherData.city = json["name"].stringValue + " , \(json["sys"]["country"].stringValue)"
            }
            else {
                 weatherData.city = "Location Name Unavailable"
            }
                weatherData.humidity = json["main"]["humidity"].intValue
                weatherData.pressure = json["main"]["pressure"].intValue
                weatherData.minTemperature = Int(json["main"]["temp_min"].doubleValue - 273.15)
                weatherData.maxTemperature = Int(json["main"]["temp_max"].doubleValue - 273.15)
                weatherData.condition = json["weather"][0]["main"].stringValue
            
                updateUI()
        }
        else {
            currentLocation.text = "Weather Unavailable"
        }
       
    }
    
    func updateUI() {
        currentWeatherCondition.text = weatherData.condition
        currentLocation.text = weatherData.city
        tempLabel.text = String(weatherData.temperature) + "°"
        humidityValue.text = String(weatherData.humidity)
        pressureValue.text = String(weatherData.pressure)
        minTempValue.text = String(weatherData.minTemperature) + "°"
        maxTempValue.text = String(weatherData.maxTemperature) + "°"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chnageLocation" {
            let destinationVC = segue.destination as! ChangeLocationViewController
            destinationVC.delegate = self
        }
    }
    
    @IBAction func toggleTempValue(_ sender: UISwitch) {
        let temp = weatherData.temperature
        let minTemp = weatherData.minTemperature
        let maxTemp = weatherData.maxTemperature
        if !sender.isOn {
            let farenheit = Int((Double(temp) * 1.8)) + 32
            let minFar = Int((Double(minTemp) * 1.8)) + 32
            let maxFar = Int((Double(maxTemp) * 1.8)) + 32
            
            tempLabel.text = String(farenheit) + "°"
            minTempValue.text = String(minFar) + "°"
            maxTempValue.text = String(maxFar) + "°"
        }
        else {
             tempLabel.text = String(temp) + "°"
             minTempValue.text = String(minTemp) + "°"
             maxTempValue.text = String(maxTemp) + "°"
        }
    }
    
    //Delegate Methods :
    func userChangedLocation(cityName: String) {
        let params : [String : String] = ["q" : cityName,"appid" : APP_ID]
        getDataFromOpenWeatherMaps(weatherURL: WEATHER_URL, parameters: params)
        toggleTemp.isOn = true
    }
    
    func userChangedLocation(lat: String, lon: String) {
        let params : [String : String] = ["lat" : lat,"lon" : lon,"appid" : APP_ID]
        getDataFromOpenWeatherMaps(weatherURL: WEATHER_URL, parameters: params)
        toggleTemp.isOn = true
    }
    
    
}

