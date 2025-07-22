//
//  ContentView.swift
//  WeatherProto
//
//  Created by Lexi Singson on 4/29/25.
//

import SwiftUI
import OpenMeteoSdk

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather : WeatherData?
    @State var isRed = true
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    //Text("Weather data fetched: \(_weather)")
                    WeatherView(weather: weather)
                        .environmentObject(locationManager)
                        .environmentObject(weatherManager)
                        .overlay(content: {
                            CloudTransition()
                        }
                        )
                        
                    
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.GetCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting Weather Data: \(error)")
                            }
                        }
                }
            } else if locationManager.isLoading {
                LoadingView()
            } else {
                WelcomeView()
                    .environmentObject(locationManager)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [.sunnyGradient1, .sunnyGradient2]), startPoint: .topLeading, endPoint: .bottomTrailing))
        
    }
        
}

#Preview {
    ContentView()
}
