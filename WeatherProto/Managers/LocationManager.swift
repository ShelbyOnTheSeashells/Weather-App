//
//  LocationManager.swift
//  WeatherProto
//
//  Created by Lexi Singson on 4/29/25.
//

import Foundation
import CoreLocation
import SwiftUICore

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var cllocation : CLLocation?
    @Published var location : CLLocationCoordinate2D?
    @Published var isLoading : Bool = false
    @Published var city : String = "Unknown"
    
    override init() {
        super.init( )
        manager.delegate = self
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestLocation( )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        cllocation = locations.first
        location = locations.first?.coordinate
        GetCity()
        isLoading = false
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error getting location", error)
        isLoading = false
    }

    func GetCity() {
        CLGeocoder().reverseGeocodeLocation(cllocation ?? CLLocation(latitude: 0, longitude: 0), completionHandler: { placemark, error in
            guard error == nil,
                  let placemark = placemark
            else
            {
                print("ERROR ERORR")
                return
            }
            
            if placemark.count > 0 {
                let found = placemark.first?.locality ?? "No city"
                self.city = found.components(separatedBy: " ").first ?? "No city"
                print("CITY FOUND!!!!!! \(self.city)")
                
            }
        })
        
        
    }
    
    func setCity(_ city : String?, _ placemark : [CLPlacemark]?) -> String {
        let city = placemark?.first?.locality ?? "No city"
        print("CITY FOUND!!!!!! \(city)")
        return city
    }
}
