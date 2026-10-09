//
//  CheckIn.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//

import Foundation

struct CheckIn:Identifiable, Equatable{
    
    let id:UUID = UUID()
    let latitude:Double
    let longitude:Double
    let timestamp:Date
    
    init(id: UUID = UUID(), latitude: Double, longitude: Double, timestamp: Date) {
        
        self.longitude = longitude
        self.latitude = latitude
        self.timestamp = timestamp
    }
    
    
    
}

struct WeatherModel: Codable {
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let weatherCode: Int
}
