//
//  ViewController.swift
//  GeoChecker
//
//  Created by Александр Сетров on 27.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import CoreLocation
import BackgroundTasks

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        //defaults.set("Пока мы ничего не знаем", forKey: "location")
        if let location = defaults.object(forKey: "location") {
            locationLabel.textColor = .red
            locationLabel.text = location as! String
        }
        print("Loaded")
        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            //print("Shit")
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Shit 2")
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            print("OK 4")
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("PreProcess")
        if let location = locations.last {
            print("Process")
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        } else{
            locationLabel.textColor = .red
            //print("Shit happens")
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {

        if let error = error {
            locationLabel.textColor = .red

        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                defaults.set(placemark.compactAddress, forKey: "location")
                locationLabel.textColor = .green
                //locationLabel.text = placemark.compactAddress
                locationLabel.text = defaults.object(forKey: "location") as! String
                //print("OK")
                //print(defaults.object(forKey: "location") as! String)
            } else {
                locationLabel.textColor = .red
                //locationLabel.text = "error"
                //print("Not OK")
                //print(defaults.object(forKey: "location") as! String)
                locationLabel.text = defaults.object(forKey: "location") as! String
            }
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
}

extension CLPlacemark {

    var compactAddress: String? {
        if let result = administrativeArea {
            return result
        }
        return nil
    }

}
