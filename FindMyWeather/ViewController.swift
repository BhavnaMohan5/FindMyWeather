//
//  ViewController.swift
//  FindMyWeather
//
//  Created by Bhavna Mohan on 15/01/19.
//  Copyright © 2019 Bhavna Mohan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    //IBOutlets and Variable Declaration :
    @IBOutlet weak var CurrentLocation: UILabel!
    @IBOutlet weak var currentWeatherCondition: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
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
    }
    }


}

