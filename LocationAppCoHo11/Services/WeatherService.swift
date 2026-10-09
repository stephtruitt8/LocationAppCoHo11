//
//  WeatherService.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 10/4/26.
//

import Foundation // <--- This is for primitive and complex types
import CoreLocation // <--- This is for GPS and location data
import Observation // <---  MVVM Pattern


enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingFailed
    case noInternet
    case timedOut
    case networkFailed
    
    var errorDescription: String? {
        switch self {
                case .invalidURL:
                    return "Couldn't create the weather URL."

                case .invalidResponse:
                    return "The weather server returned an invalid response."

                case .serverError(let statusCode):
                    return "The weather request failed (HTTP \(statusCode))."

                case .decodingFailed:
                    return "Couldn't read the weather data."

                case .noInternet:
                    return "You're offline. Check your internet connection."

                case .timedOut:
                    return "The weather request timed out. Please try again."

                case .networkFailed:
                    return "Couldn't connect to the weather service."
        }
    }
}

class WeatherService {
    
    func fetchWeather (
    latitude: Double,
    longitude: Double
    ) async throws -> WeatherModel {
         
        // Build URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        
        components.queryItems = [
            URLQueryItem(
                name: "latitude",
                value: String(latitude)
            ),
            URLQueryItem(
                name: "longitude",
                value: String(longitude)
            ),
            URLQueryItem(
                name: "current",
                value: "temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code"
            ),
            URLQueryItem(
                name: "temperature_unit",
                value: "celsius"
            ),
            URLQueryItem(
                name: "wind_speed_unit",
                value: "kmh"
            )
        ]
        
        guard let url = components.url else {
            throw WeatherError.invalidURL
        }
        
        // Fetch data
        let data: Data
        let response: URLResponse
        
        do {
                    (data, response) = try await URLSession.shared.data(from: url)
                } catch let error as URLError {
                    switch error.code {
                    case .cancelled:
                        throw CancellationError()

                    case .notConnectedToInternet:
                        throw WeatherError.noInternet

                    case .timedOut:
                        throw WeatherError.timedOut

                    default:
                        throw WeatherError.networkFailed
                    }
                }

                // 3. Check the HTTP response.
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw WeatherError.invalidResponse
                }

                guard httpResponse.statusCode == 200 else {
                    throw WeatherError.serverError(httpResponse.statusCode)
                }

                // 4. Decode the API response.
                let decoded: WeatherResponse

                do {
                    decoded = try JSONDecoder().decode(
                        WeatherResponse.self,
                        from: data
                    )
                } catch {
                    throw WeatherError.decodingFailed
                }

                // 5. Return your app's model.
                return WeatherModel(
                    temperature: decoded.current.temperature,
                    humidity: decoded.current.humidity,
                    windSpeed: decoded.current.windSpeed,
                    weatherCode: decoded.current.weatherCode
                )
            }
        }

        // These types describe the API's JSON structure.
        private struct WeatherResponse: Decodable {
            let current: CurrentWeather
        }

        private struct CurrentWeather: Decodable {
            let temperature: Double
            let humidity: Int
            let windSpeed: Double
            let weatherCode: Int

            enum CodingKeys: String, CodingKey {
                case temperature = "temperature_2m"
                case humidity = "relative_humidity_2m"
                case windSpeed = "wind_speed_10m"
                case weatherCode = "weather_code"
            }
        }


//1.- Make it so you can see the coordinates
//2.- See what happens when you pass in the coordinates to the weather view model
//3.- Display the cOORDINATES ON A VIEW
//3.- DISPLAY THE WEATHER ON A VIEW
