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

class ViewController: UIViewController,CLLocationManagerDelegate {

    //IBOutlets and Variable Declaration :
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentWeatherCondition: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK : Location Manager didUpdate Location
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
    if location.horizontalAccuracy > 0 {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        print("latitude : \(location.coordinate.latitude) and longitude : \(location.coordinate.longitude)")
        let params : [String : String] = ["lat" : String(location.coordinate.latitude),"lon" : String(location.coordinate.longitude),"appid" : APP_ID]
        getDataFromOpenWeatherMaps(weatherURL : WEATHER_URL,parameters: params)
    }
    }
    
    func getDataFromOpenWeatherMaps(weatherURL : String,parameters : [String : String]) {
        Alamofire.request(weatherURL, method: .get, parameters: parameters).responseJSON {
            response in
                if response.result.isSuccess {
                    let weatherJSON = JSON(response.result.value!)
                    self.currentLocation.text = weatherJSON["name"].string
                    print(weatherJSON)
                }
                else {
                    print("Error : \(response.result.error!)")
                    self.currentLocation.text = "Connection Issues"
            }
        }
    }


}

