//
//  WeatherManager.swift
//  WeatherProto
//
//  Created by Lexi Singson on 4/29/25.
//

import Foundation
import CoreLocation
import OpenMeteoSdk


class WeatherManager : ObservableObject {
    
    func GetCurrentWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees) async throws -> WeatherData {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,wind_speed_10m_max,wind_gusts_10m_max,wind_direction_10m_dominant,uv_index_max,uv_index_clear_sky_max,daylight_duration,sunshine_duration,sunset,sunrise,rain_sum,showers_sum,snowfall_sum,precipitation_sum,precipitation_probability_max,precipitation_hours&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,wind_speed_10m,wind_direction_10m,wind_gusts_10m,snowfall,showers,rain,precipitation,weather_code,cloud_cover&timezone=auto&format=flatbuffers") else { fatalError("Missing URL")
        }
        
        let responses = try await WeatherApiResponse.fetch(url: url)
        
        /// Process first location. Add a for-loop for multiple locations or weather models
        let response = responses[0]
        
        /// Attributes for timezone and location
        let utcOffsetSeconds = response.utcOffsetSeconds
        let timezone = response.timezone
        let timezoneAbbreviation = response.timezoneAbbreviation
        let latitude = response.latitude
        let longitude = response.longitude
        
        let current = response.current!
        let daily = response.daily!
        
        /// Note: The order of weather variables in the URL query and the `at` indices below need to match!
        let data = WeatherData(
            current: .init(
                time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                temperature2m: current.variables(at: 0)!.value,
                relativeHumidity2m: current.variables(at: 1)!.value,
                apparentTemperature: current.variables(at: 2)!.value,
                isDay: current.variables(at: 3)!.value,
                windSpeed10m: current.variables(at: 4)!.value,
                windDirection10m: current.variables(at: 5)!.value,
                windGusts10m: current.variables(at: 6)!.value,
                snowfall: current.variables(at: 7)!.value,
                showers: current.variables(at: 8)!.value,
                rain: current.variables(at: 9)!.value,
                precipitation: current.variables(at: 10)!.value,
                weatherCode: current.variables(at: 11)!.value,
                cloudCover: current.variables(at: 12)!.value
            ),
            daily: .init(
                time: daily.getDateTime(offset: utcOffsetSeconds),
                weatherCode: daily.variables(at: 0)!.values,
                temperature2mMax: daily.variables(at: 1)!.values,
                temperature2mMin: daily.variables(at: 2)!.values,
                apparentTemperatureMax: daily.variables(at: 3)!.values,
                apparentTemperatureMin: daily.variables(at: 4)!.values,
                windSpeed10mMax: daily.variables(at: 5)!.values,
                windGusts10mMax: daily.variables(at: 6)!.values,
                windDirection10mDominant: daily.variables(at: 7)!.values,
                uvIndexMax: daily.variables(at: 8)!.values,
                uvIndexClearSkyMax: daily.variables(at: 9)!.values,
                daylightDuration: daily.variables(at: 10)!.values,
                sunshineDuration: daily.variables(at: 11)!.values,
                sunset: daily.variables(at: 12)!.valuesInt64,
                sunrise: daily.variables(at: 13)!.valuesInt64,
                rainSum: daily.variables(at: 14)!.values,
                showersSum: daily.variables(at: 15)!.values,
                snowfallSum: daily.variables(at: 16)!.values,
                precipitationSum: daily.variables(at: 17)!.values,
                precipitationProbabilityMax: daily.variables(at: 18)!.values,
                precipitationHours: daily.variables(at: 19)!.values
            )
        )

        /// Timezone `.gmt` is deliberately used.
        /// By adding `utcOffsetSeconds` before, local-time is inferred
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                    
        for (i, date) in data.daily.time.enumerated() {
            print(dateFormatter.string(from: date))
            print(data.daily.weatherCode[i])
            print(data.daily.temperature2mMax[i])
            print(data.daily.temperature2mMin[i])
            print(data.daily.apparentTemperatureMax[i])
            print(data.daily.apparentTemperatureMin[i])
            print(data.daily.windSpeed10mMax[i])
            print(data.daily.windGusts10mMax[i])
            print(data.daily.windDirection10mDominant[i])
            print(data.daily.uvIndexMax[i])
            print(data.daily.uvIndexClearSkyMax[i])
            print(data.daily.daylightDuration[i])
            print(data.daily.sunshineDuration[i])
            print(data.daily.sunset[i])
            print(data.daily.sunrise[i])
            print(data.daily.rainSum[i])
            print(data.daily.showersSum[i])
            print(data.daily.snowfallSum[i])
            print(data.daily.precipitationSum[i])
            print(data.daily.precipitationProbabilityMax[i])
            print(data.daily.precipitationHours[i])
        }
        
        return data
    }
    
    func interpret(weather : Float?) -> String{
        var condition = ""
        switch Int(weather ?? -1.0) {
        case 0:
            condition = "Sun"
            break;
        case 1:
            condition = "Sun"//"mainly clear"
            break;
        case 2:
            condition = "PartlyCloudy" //"partly cloudly"
            break;
            
        case 3:
            condition = "Overcast"
            break;
            
        case 45, 48:
            condition = "Fog"
            break;
        
        case 51, 53, 55:
            condition = "Drizzle"
            break;
        
        case 66, 67, 81, 82:
            condition = "Rain"
            break;
            
        case 71, 73, 75, 77:
            condition = "SnowFall"
            break;
        
        case 80:
            condition = "Drizzle"
            break;
    
        case 85:
            condition = "slight snow showers"
            break;
        case 86:
            condition = "heavy snow showers"
            break;
            
        case 95:
            condition = "Thunderstorm"
            break;
        case 96, 99:
            condition = "thunderstorm /w hail"
            break;
        default:
            print(weather)
            condition = "unknown"
            break;
            
        }
        return condition
    }
}

    struct WeatherData {
        let current: Current
            let daily: Daily

            struct Current {
                let time: Date
                let temperature2m: Float
                let relativeHumidity2m: Float
                let apparentTemperature: Float
                let isDay: Float
                let windSpeed10m: Float
                let windDirection10m: Float
                let windGusts10m: Float
                let snowfall: Float
                let showers: Float
                let rain: Float
                let precipitation: Float
                let weatherCode: Float
                let cloudCover: Float
            }
            struct Daily {
                let time: [Date]
                let weatherCode: [Float]
                let temperature2mMax: [Float]
                let temperature2mMin: [Float]
                let apparentTemperatureMax: [Float]
                let apparentTemperatureMin: [Float]
                let windSpeed10mMax: [Float]
                let windGusts10mMax: [Float]
                let windDirection10mDominant: [Float]
                let uvIndexMax: [Float]
                let uvIndexClearSkyMax: [Float]
                let daylightDuration: [Float]
                let sunshineDuration: [Float]
                let sunset: [Int64]
                let sunrise: [Int64]
                let rainSum: [Float]
                let showersSum: [Float]
                let snowfallSum: [Float]
                let precipitationSum: [Float]
                let precipitationProbabilityMax: [Float]
                let precipitationHours: [Float]
            }
        
       
    }


