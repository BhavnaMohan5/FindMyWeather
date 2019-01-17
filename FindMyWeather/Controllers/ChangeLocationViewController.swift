//
//  ChangeLocationViewController.swift
//  FindMyWeather
//
//  Created by Bhavna Mohan on 16/01/19.
//  Copyright © 2019 Bhavna Mohan. All rights reserved.
//

import UIKit

enum ErrorCases : Error {
    case incomplete
    case invalidCityName
}
enum LatLonErrorCases : Error {
    case incomplete
    case wrongLatitude
    case wrongLongitude
}

protocol ChangeLocationDelegate {
    func userChangedLocation(cityName : String)
    func userChangedLocation(lat : String,lon : String)
}

class ChangeLocationViewController: UIViewController {
    //IBOutlets and Variables declaration :

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var toggleCityAndLatLon: UISwitch!
    
    var delegate : ChangeLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longTextField.isHidden = true
        latTextField.isHidden = true

    }
    //IBActions :
    @IBAction func getWeatherBtnTapped(_ sender: UIButton) {
        if toggleCityAndLatLon.isOn {
            do {
                try validateTextFieldData(checkFor: "city")
                let city = cityTextField.text!
                delegate?.userChangedLocation(cityName: city)
                self.dismiss(animated: true, completion: nil)
            }
            catch ErrorCases.incomplete {
                let alert = UIAlertController(title: "Empty Field", message: "City Name cannot be empty.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            catch ErrorCases.invalidCityName {
                let alert = UIAlertController(title: "Invalid City Name", message: "City Name cannot contain numbers and special characters.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            catch {
                print("Error")
            }
        }
        else {
            do {
                try validateTextFieldData(checkFor: "latLon")
                let lon = longTextField.text!
                let lat = latTextField.text!
                delegate?.userChangedLocation(lat: lat, lon: lon)
                self.dismiss(animated: true, completion: nil)
            }
            catch LatLonErrorCases.incomplete {
                let alert = UIAlertController(title: "Empty Field", message: "Longitude or Latitude cannot be empty.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
             catch LatLonErrorCases.wrongLongitude {
                let alert = UIAlertController(title: "Invalid Longitude", message: "Longitude value should be between -180 and +180 degrees.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            catch LatLonErrorCases.wrongLatitude {
                let alert = UIAlertController(title: "Invalid Latitude", message: "Latitude value should be between -90 and +90 degrees.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            catch {
                
            }
           
        }
       
    }
    
    
    @IBAction func toggledCityAndLatLon(_ sender: UISwitch) {
        if !sender.isOn {
            cityTextField.isHidden = true
            latTextField.isHidden = false
            longTextField.isHidden = false
        }
        else
        {
            longTextField.isHidden = true
            latTextField.isHidden = true
            cityTextField.isHidden = false
    }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateTextFieldData (checkFor : String) throws {
        let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
        if checkFor == "city" {
            let city = cityTextField.text!
            if city.isEmpty {
                throw ErrorCases.incomplete
            }
            if regex.firstMatch(in: city, options: [], range: NSMakeRange(0, city.count)) != nil {
                throw ErrorCases.invalidCityName
                
            }
        }
        else if checkFor == "latLon"{
            let lat = latTextField.text!
            let long = longTextField.text!
            print("lat : \(lat) and lon : \(long)")
            if lat.isEmpty || long.isEmpty {
                throw LatLonErrorCases.incomplete
            }
            else if Int(lat)! < -90 || Int(lat)! > 90 {
                throw LatLonErrorCases.wrongLatitude
            }
            else if Int(long)!  < -180 || Int(long)! > 180 {
                throw LatLonErrorCases.wrongLongitude
        }
    }
    
    }

}
