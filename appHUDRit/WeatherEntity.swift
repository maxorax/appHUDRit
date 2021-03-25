//
//  weather.swift
//  HUDapp
//
//  Created by Maxorax on 18.03.2021.
//

import Foundation

struct WeatherEntity: Decodable {
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}
