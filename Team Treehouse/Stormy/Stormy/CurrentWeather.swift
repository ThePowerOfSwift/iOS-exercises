//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Davide Callegari on 21/04/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import UIKit
import Foundation

let DARK_SKY_API_SECRET_KEY = "2eb5d5ebc3f4cf268ae4768946eb21ef"

struct CurrentWeather {
    let temperature: Double
    let humidity: Double
    let precipitationProbability: Double
    let summary: String
    let icon: UIImage
}

extension CurrentWeather:JSONDecodable {
    init?(json: [String : AnyObject]) {
        guard let temperature = json["temperature"] as? Double,
            let humidity = json["humidity"] as? Double,
            let precipitationProbability = json["precipProbability"] as? Double,
            let summary = json["summary"] as? String,
            let iconPath = json["icon"] as? String else {
                return nil
        }
        
        let icon = WeatherIcon(rawValue: iconPath).image
        self.temperature = temperature
        self.humidity = humidity
        self.precipitationProbability = precipitationProbability
        self.summary = summary
        self.icon = icon
    }
}
