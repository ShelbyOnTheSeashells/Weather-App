//
//  WeatherView.swift
//  WeatherProto
//
//  Created by Lexi Singson on 5/1/25.
//

import SwiftUI
import OpenMeteoSdk
import CoreLocation

func UpdateTime() -> String{
    let time = ""
    return time
}
struct WeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherManager: WeatherManager
    var weather : WeatherData?
    /*@State var time : String = "\(Date().formatted(.dateTime.weekday(.wide))) | \(Date().formatted(.dateTime.month().day())) | \(Date().formatted(.dateTime.hour().minute()))"*/
    
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            HStack {
                let temperature = Int(weather?.current.temperature2m ?? 0)
                Text("\(temperature)°")
                    .font(.system(size: 80, weight: .bold))
                
                
                VStack {
                    Text("\(locationManager.city ?? "City")")
                        .font(.system(size: 45, weight: .bold))
                    TimelineView(.everyMinute) { _ in
                        
                        Text("\(Date().formatted(.dateTime.weekday(.wide))) | \(Date().formatted(.dateTime.month().day())) | \(Date().formatted(.dateTime.hour().minute()))")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    
                }
            }
            .shadow(radius: 2, y: 2)
            .padding(.bottom, 20.0)
            
            Image("\(weatherManager.interpret(weather: weather?.current.weatherCode ?? 1.0))")
                .padding(.bottom, 100)
            Spacer()
            
            VStack {
                Spacer()
                    .frame(height: 30)
                Text("Weekly Forecast")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.sunnyGradient1)
                    
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack {
                        DayCard(day: "SUN", index: 0, weather: weather, weatherManager: weatherManager)
                        DayCard(day: "MON", index: 1, weather: weather, weatherManager: weatherManager)
                        DayCard(day: "TUE", index : 2, weather: weather, weatherManager: weatherManager)
                        DayCard(day: "WED", index: 3, weather: weather, weatherManager: weatherManager)
                        DayCard(day: "THU", index: 4, weather: weather, weatherManager: weatherManager)
                        DayCard(day: "FRI", index: 5, weather: weather, weatherManager: weatherManager)
                        DayCard(day: "SAT", index: 6, weather: weather, weatherManager: weatherManager)
                    }
                    
                    .padding(.vertical, 20)
                    
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [.white, .cloudShade]), startPoint: .top, endPoint: .bottom))
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background(
            
            HStack {
                
                Image("ACloud").resizable().scaledToFit()
                    .padding(.top, 80)
                    
            }
                .padding(.top, 80)
                .background(
                    HStack {
                        Image("BigBlueCloud")
                            .resizable()
                            .scaledToFit()
                    }
                    
                )
        )
        
    }
    
}


#Preview {
    WeatherView()
        .background(LinearGradient(gradient: Gradient(colors: [.sunnyGradient1, .sunnyGradient2]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .environmentObject(LocationManager())
        .environmentObject(WeatherManager())
}

struct DayCard: View {
    var day : String
    var index : Int
    var weather : WeatherData?
    var weatherManager : WeatherManager
    
    
    
    var body: some View {
        let tempMin = Int(weather?.daily.apparentTemperatureMin[index] ?? 4)
        let tempMax = Int(weather?.daily.apparentTemperatureMax[index] ?? 8)
        let total = tempMax - tempMin
        let progress = tempMax - Int(weather?.current.temperature2m ?? 0)
        VStack {
            Text(day)
                .font(.system(size: 18, weight: .semibold))
            Image("\(weatherManager.interpret(weather: weather?.daily.weatherCode[index] ?? 1.0))")
                .resizable().scaledToFit()
                .frame(width: 40, height: 40)
           
           
            Text("\(tempMin)°")
            
            
            ProgressView(value: 2, total: Float(total))
                .rotationEffect(Angle(degrees: 90))
                .progressViewStyle(.linear)
                .padding(.vertical, 22)
                .tint(.yellow)
                
                
            Text("\(tempMax)°")
                
        }
        .foregroundStyle(.sunnyGradient1)
        .frame(width: 60, height: 220)
        .background {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white)
                .shadow(radius: 2, x: 0, y: 3)
        }
        .padding(.horizontal, 5)
    }
    
}
