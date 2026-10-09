//
//  ContentView.swift
//  LocationAppCoHo11
//
//  Created by Stephen Truitt on 9/30/26.
//

import SwiftUI
import CoreLocation
import Combine


struct ContentView: View {
    @StateObject private var viewModel:LocationViewModel = LocationViewModel()
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        
        VStack {
            
            if viewModel.viewState == .needsPermission { PermissionView(onEnable:{ viewModel.retryTapped()})
            }else if viewModel.viewState == .loading {LoadingView()}
            
            else if viewModel.viewState == .ready {
                VStack(spacing: 8) {
                        Text("Your Coordinates")
                            .font(.headline)

                        Text("Latitude: \(viewModel.latitudeText)")
                        Text("Longitude: \(viewModel.longitudeText)")
                }
                .padding()
                
                LocationReady(
                    latText: viewModel.latitudeText,
                    lonText: viewModel.longitudeText,
                    onRefresh: {viewModel.retryTapped()},
                    onSave: {viewModel.saveCheckIn()}
                )
                
                Text("Weather loading: \(weatherViewModel.isLoading ? "Yes" : "No")")

                Text("Weather received: \(weatherViewModel.weather == nil ? "No" : "Yes")")

                if !weatherViewModel.errorMessage.isEmpty {
                    Text(weatherViewModel.errorMessage)
                        .foregroundStyle(.red)
                }

                Button("Load Weather") {
                    Task {
                        if let coordinate = viewModel.lastCoordinate {
                            await weatherViewModel.updateCoordinate(
                                newCoordinate: coordinate
                            )
                            await weatherViewModel.refresh()
                        }
                    }
                }
                .disabled(weatherViewModel.isLoading)
                
                //AI code
                VStack(spacing: 12) {
                    Text("Current Weather")
                        .font(.headline)

                    if weatherViewModel.isLoading {
                        ProgressView("Loading weather...")
                    }

                    if let weather = weatherViewModel.weather {
                        Text("\(weather.temperature, specifier: "%.1f") °C")
                            .font(.largeTitle)

                        Text("Humidity: \(weather.humidity)%")
                        Text("Wind: \(weather.windSpeed, specifier: "%.1f") km/h")
                    }

                    if !weatherViewModel.errorMessage.isEmpty {
                        Text(weatherViewModel.errorMessage)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button("Refresh Weather") {
                        Task {
                            await weatherViewModel.refresh()
                        }
                    }
                    .disabled(weatherViewModel.isLoading)
                }
                .padding()
                
                
            }else if viewModel.viewState == .failed {
                FailedView(message: viewModel.errorMessage, onTryAgain: {viewModel.retryTapped()})

            }else if viewModel.viewState == .denied {
                VStack(spacing: 12) {
                    Text(viewModel.errorMessage)
                        .multilineTextAlignment(.center)
                    
                    Button("Open Settings") {
                        guard let url = URL(string: UIApplication.openSettingsURLString)
                        else { return }
                        
                        UIApplication.shared.open(url)
                    }
                    
                }
                .padding()
                
                
            }
            
            Divider()
            
            CheckInListView(checkInlist: viewModel.checkIns,
                            onClear: {
                viewModel.clearAll()
                }
            )
            
        }
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
//        .task { [viewModel.lastCoordinate?.latitude,
//                 viewModel.lastCoordinate?.longitude
//        ]
//            if let coordinate = viewModel.lastCoordinate {
//                await weatherViewModel.updateCoordinate(newCoordinate:coordinate)
//            }
//        }
//
        .task(id: [
            viewModel.lastCoordinate?.latitude,
            viewModel.lastCoordinate?.longitude
        ]) {
            if let coordinate = viewModel.lastCoordinate {
                await weatherViewModel.updateCoordinate(
                    newCoordinate: coordinate
                )
            }
        }
        
        
//        .onChange(of: viewModel.lastCoordinate!) {
//            Task {
//                if let coordinate = viewModel.lastCoordinate {
//                    await weatherViewModel.updateCoordinate(newCoordinate:coordinate)
//                }
//            }
//        }
       
    }
}

#Preview {
    ContentView()
}
