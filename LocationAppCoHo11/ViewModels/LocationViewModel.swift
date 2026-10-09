//
//  LocationView.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//

import Foundation
import CoreLocation
import Observation
import Combine


enum LocationViewState{
    case needsPermission,ready,loading,denied,failed
}


@MainActor
class LocationViewModel:ObservableObject{
    
    @Published var checkIns:[CheckIn] = []
    @Published var weather: WeatherModel?
    @Published var isWeatherLoading = false
    @Published var weatherErrorMessage = ""
    
    private let locationService:LocationService = LocationService()
    private var serviceSubscription: AnyCancellable?
    private let weatherService = WeatherService()
    
    init() {
        serviceSubscription = locationService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        
    }
    
    var lastCoordinate: CLLocationCoordinate2D? {
        locationService.location
    }
    
    var latitudeText: String {
        guard let coordinate = lastCoordinate else {
            return "--"
        }

        return String(format: "%.5f", coordinate.latitude)
    }

    var longitudeText: String {
        guard let coordinate = lastCoordinate else {
            return "--"
        }

        return String(format: "%.5f", coordinate.longitude)
    }
    
    
    var viewState: LocationViewState {
        let status = locationService.authStatus

        if status == .notDetermined {
            return .needsPermission
        }

        if status == .denied || status == .restricted {
            return .denied
        }

        if !locationService.errorMessage.isEmpty {
            return .failed
        }

        if locationService.isLoading || lastCoordinate == nil {
            return .loading
        }

        return .ready
    }

    var errorMessage: String {
        if locationService.authStatus == .restricted {
            return "Location access is restricted by device settings."
        }

        if locationService.authStatus == .denied {
            return "Enable location access in Settings to see local weather."
        }

        return locationService.errorMessage
    }
    
    
//    var viewState:LocationViewState {
//        
//        if self.locationService.isLoading == true{
//            return .loading
//        }
//        
//        let status:CLAuthorizationStatus = self.locationService.authStatus
//            
//        if status == .notDetermined {
//            print(status)
//            return .needsPermission
//        }
//        
//        if status == .denied{
//            return .denied
//        }
//        
//        if locationService.isLoading || lastCoordinate == nil {
//            return .loading
//            
//        }
//        
//        if self.locationService.location != nil {
//            return .ready
//        }
//        
//        return .failed
//        
//    }
//    
//    var latitudeText:String {
//        if self.locationService.location == nil{
//            return "--"
//        }
//        let coordinate:CLLocationCoordinate2D = self.locationService.location!
//        return String(format: "%.5f", coordinate.latitude)
//    }
//    
//    var longitudeText:String {
//        if self.locationService.location == nil{
//            return "--"
//        }
//        let coordinate:CLLocationCoordinate2D = self.locationService.location!
//        return String(format: "%.5f", coordinate.longitude)
//    }
//    
//    var errorMessage:String{
//        if self.viewState == .failed {
//            return "Error while getting location access"
//        }
//        
//        if self.viewState == .denied{
//            return "We don't have access to the location, please Enable it in Settings"
//        }
//        
//        return ""
//        
//    }
    
    func saveCheckIn() {
        
        if self.locationService.location == nil {
            return
        }
        
        let coordinate:CLLocationCoordinate2D = self.locationService.location!
        
        
        let newCood:CheckIn = CheckIn(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            timestamp: Date())
        self.checkIns.insert(newCood, at: 0)
    }
    
    
    func clearAll(){
        self.checkIns.removeAll()
    }
    
    func retryTapped(){
        locationService.start()
    }
    
    func start() {
           locationService.start()
       }

    func stop() {
           locationService.stop()
       }
    
}
