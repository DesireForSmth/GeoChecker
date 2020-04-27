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
    @IBOutlet var contentView: CustomView! = CustomView()
    var locationManager: CLLocationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //contentView.setup()
        //contentView.locationLabel.text = "hello"
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        contentView.changeLabelColor(color: .green)
        if let location: String = defaults.object(forKey: "location") as? String {
            print(location)
           // self.contentView.changeLabelText(data: location)
            //self.contentView.changeLabelColor(color: .red)
        } else {
            defaults.set("Пока мы ничего не знаем", forKey: "location")
            //self.contentView.changeLabelText(data: "Пока мы ничего не знаем")
            //self.contentView.changeLabelColor(color: .red)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied: break
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways: break
    }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        } else{
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {

        if error != nil {
            contentView.changeLabelColor(color: .red)
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                defaults.set(placemark.compactAddress, forKey: "location")
                //contentView.locationLabel.text = placemark.compactAddress
                contentView.changeLabelText(data: placemark.compactAddress!)
                contentView.changeLabelColor(color: .green)
            } else {
                contentView.changeLabelText(data: defaults.object(forKey: "location") as! String)
                contentView.changeLabelColor(color: .green)
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
