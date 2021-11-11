//
//  Exercise+Printer.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-07.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

extension Exercise {

    func getBike(gear_id: String) -> String {

        if(gear_id == "b3772069") {
            return "Road"
        } else if(gear_id == "b443874") {
            return "Cross"
        }
        return "Unknown"
    }

    func getDate(fromDateString dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        return dateFormatter.date(from:dateString)!
    }

    func getType(date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour], from: date)

        if let hour = components.hour {
            if hour < 12 {
                return "to work"
            } else {
                return "to home"
            }
        }

        return ""
    }

    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd" // This your string date format
        return dateFormatter.string(from: date)
    }

    func getMonth(date: Date) -> String {
        let components = Calendar.current.dateComponents([.month], from: date)
        let month = components.month ?? -1
        return "\(month)"
    }

    func getLink(activity id: Int) -> String {
        return "https://www.strava.com/activities/\(id)"
    }

    func getHours(time: Int) -> String {
        return "\(time/3600)"
    }

    func getMinutes(time: Int) -> String {
        return "\((time/60) % 60)"
    }

    func getSeconds(time: Int) -> String {
        return "\(time % 60)"
    }

    func getTime(time: Int) -> String {
        let float = Float(time)
        return (String(format: "%.2f", float/3600))
    }

    func getDistance(distanceInMeters: Double) -> String {
        let float = Double(distanceInMeters)
        return (String(format: "%.2f", float/1000))
    }

    func getElevationGain(amount: Double) -> String {
        return (String(format: "%.0f", amount))
    }

    func getAverageSpeed(amount metersPerSecond: Double) -> String {
        return (String(format: "%.1f", metersPerSecond * 3.6))
    }

    func getClimbing(elevationGain gain: Double, distanceInMeters: Double) -> String {
        return (String(format: "%.2f", gain/(distance/1000)))
    }

    func getWatts(watts: Double?) -> String {
        guard let watts = watts else {
            return ""
        }
        return (String(format: "%.0f", watts))
    }

    func getMaxWatts(watts: Int?) -> String {
        guard let watts = watts else {
            return ""
        }
        return ("\(watts)")
    }

    func getWattsPerSpeed(watts: Double?, speed metersPerSecond: Double) -> String {
        guard let watts = watts else {
            return ""
        }
        return (String(format: "%.2f", watts/(metersPerSecond * 3.6)))
    }

    func printCommute() {
        let date = getDate(fromDateString: start_date)
        var strings = [String]()
        strings += getBike(gear_id: gear_id)
        strings += getType(date: date)
        strings += getDate(date: date)
        strings += getMonth(date: date)
        strings += getLink(activity: id)
        strings += getHours(time: moving_time)
        strings += getMinutes(time: moving_time)
        strings += getSeconds(time: moving_time)
        strings += getTime(time: moving_time)
        strings += getDistance(distanceInMeters: distance)
        strings += getElevationGain(amount: total_elevation_gain)
        strings += getAverageSpeed(amount: average_speed)
        strings += getClimbing(elevationGain: total_elevation_gain, distanceInMeters: distance)
        strings += getWatts(watts: average_watts)
        strings += getMaxWatts(watts: max_watts)
        strings += getWattsPerSpeed(watts: average_watts, speed: average_speed)
        print(strings)
    }

    func printColumns() {
        var strings = [String]()
        strings += "Bike\t"
        strings += "Type"
        strings += "Date"
        strings += "Mon"
        strings += "Link\t\t\t\t\t\t\t\t\t\t"
        strings += "H"
        strings += "M"
        strings += "S"
        strings += "Time"
        strings += "Dist"
        strings += "EleG"
        strings += "AvgSpeed"
        strings += "Clmbng"
        strings += "Watts"
        strings += "MWatts"
        strings += "WattsPerSpeed"
        print(strings)
    }

    func print(_ strings: [String]) {
        var combined = strings.first ?? ""
        for string in strings.dropFirst() {
            combined += ",\(string)"
        }
        Swift.print(combined)
    }
}

func += <V> ( left: inout [V], right: V) {
    left.append(right)
}


