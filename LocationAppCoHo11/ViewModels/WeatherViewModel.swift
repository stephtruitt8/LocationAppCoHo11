//
//  WeatherViewModel.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 10/5/26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var weather: WeatherModel?
    @Published var errorMessage = ""
    @Published var lastUpdated: Date?
    
    private let weatherService = WeatherService()
    
    private var coordinate: CLLocationCoordinate2D?
    private var lastFetchedLocation: CLLocation?
    
    func updateCoordinate(
         newCoordinate: CLLocationCoordinate2D
    ) async {
        guard CLLocationCoordinate2DIsValid(newCoordinate) else {
            errorMessage = "The location coordinates are invalid."
            return
        }
        
        coordinate = newCoordinate
        
        await fetchWeather(force: false)
    }
    
    func refresh() async {
        await fetchWeather(force: true)
    }
    
    private func fetchWeather(force: Bool) async {
        guard !isLoading else { return }
        
        guard let coordinate else {
            errorMessage = " Get your location first!"
            return
        }
        
        let requestedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude
        )
        
        if !force, let lastFetchedLocation,
           requestedLocation.distance(from: lastFetchedLocation) < 100 {
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        defer {
            isLoading = false
        }
        
        do {
            let result = try await weatherService.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude
            )
            
            try Task.checkCancellation()
            
            weather = result
            lastUpdated = Date()
            lastFetchedLocation = requestedLocation
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
}
