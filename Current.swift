//
//  Current.swift
//  Stormy
//
//  Created by Sarvex Jatasra on 12/04/2015.
//  Copyright (c) 2015 Sarvex Jatasra. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipitationProbability: Double
    var summary: String
    var icon: UIImage?

    init(weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as! NSDictionary

        temperature = currentWeather["temperature"] as! Int
        humidity = currentWeather["humidity"] as! Double
        precipitationProbability = currentWeather["precipProbability"] as! Double
        summary = currentWeather["summary"] as! String

        currentTime = dateStringFromUnixTime(currentWeather["time"] as! Int)
        icon = weatherIconFromString(currentWeather["icon"] as! String)
    }

    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)


        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle

        return dateFormatter.stringFromDate(weatherDate)
    }

    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String

        switch stringIcon {
        case "clear-day":
                imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }

        return UIImage(named: imageName)!
    }
}
