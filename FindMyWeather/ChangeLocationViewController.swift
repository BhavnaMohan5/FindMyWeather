//
//  ChangeLocationViewController.swift
//  FindMyWeather
//
//  Created by Bhavna Mohan on 16/01/19.
//  Copyright © 2019 Bhavna Mohan. All rights reserved.
//

import UIKit

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
            let city = cityTextField.text!
            delegate?.userChangedLocation(cityName: city)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            let lon = longTextField.text!
            let lat = latTextField.text!
            delegate?.userChangedLocation(lat: lat, lon: lon)
             self.dismiss(animated: true, completion: nil)
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
    
    

}
