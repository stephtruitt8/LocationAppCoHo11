//
//  LocationService.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//
import Foundation // <--- This is for primitive and complex types
import CoreLocation // <--- This is for GPS and location data
import Observation // <---  MVVM Pattern
import Combine

@MainActor
class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    // NSObject -> Because we are using Sensors and they are LOW
    // CLLocationManagerDelegate -> Because we are going to use pre-made functions
    
    private let manager:CLLocationManager = CLLocationManager()
    private var isActive = false
    
    //CLLocationManager -> Its the one in charge of location updates and readings
    
    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage = ""

    // Are we running this code?
    
    @Published var isLoading:Bool = false
    
    // Current Location Status
    @Published var authStatus:CLAuthorizationStatus = .notDetermined
    
    override init() {
        
        super.init()
        
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        authStatus = manager.authorizationStatus
        
    }
    
    // MARK: Location Functions
    
    func start() {
        isActive =  true
        requestPermissionAndLocation()
    }
    
    func stop() {
        isActive =  false
        manager.stopUpdatingLocation()
        isLoading = false
    }
    
    func requestLocation() {
        guard isActive, !isLoading else { return }

        guard authStatus == .authorizedWhenInUse ||
              authStatus == .authorizedAlways else {
            return
        }

        errorMessage = ""
        isLoading = true
        manager.requestLocation()
    }
    
    func requestPermissionAndLocation(){
        
        authStatus = manager.authorizationStatus
        
        if authStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            requestLocation()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            isLoading = false
            location = nil
            
        }
        
        
    }
    // MARK: This comes from the class that we are extending
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authStatus = manager.authorizationStatus
        
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways{
            requestLocation()
        }else{
            isLoading = false
        }
        
        if authStatus == .denied || authStatus == .restricted {
            manager.stopUpdatingLocation()
            isLoading = false
            location = nil
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard isActive else {
            return
        }
        
        if let lastLocation = locations.last, lastLocation.horizontalAccuracy >= 0{
            errorMessage = "Couldn't find your location. Please try again"
            
            
            
            location = lastLocation.coordinate
            errorMessage = ""
        }
        
        isLoading = false
        return
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
        authStatus = manager.authorizationStatus
        errorMessage = "Couldn't get your location. Please try again."
        
        isLoading = false
    }
    
    
}

