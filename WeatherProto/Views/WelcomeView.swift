//
//  WelcomeView.swift
//  WeatherProto
//
//  Created by Lexi Singson on 4/29/25.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    var body: some View {
        
        
        VStack(alignment: .center, spacing: 20) {
            Text("Forecast")
                .font(.system(size: 50, weight: .bold))
                .padding(.bottom, 20.0)
                
                
                
            Text("Before we can check out the weather, please share your location so that we can fetch the information in your area.")
                .font(.system(size: 20, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.bottom, 20.0)
                
            
            LocationButton(.currentLocation) {
                locationManager.requestLocation()
            }
            
            .frame(width: 250, height: 50)
            .background(.sunnyGradient1)
            .foregroundStyle(.white)
            .tint(.sunnyGradient1)
            .font(.title2)
            
            .font(.system(size: 20, weight: .bold))
            
            .cornerRadius(20)
            
            
        }
        
        .padding(.bottom, 200.0)
        .padding(.horizontal, 40.0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .foregroundStyle(.sunnyGradient1)
    }
    
}

#Preview {
    WelcomeView()
        .background(LinearGradient(gradient: Gradient(colors: [.sunnyGradient1, .sunnyGradient2]), startPoint: .topLeading, endPoint: .bottomTrailing))
}
