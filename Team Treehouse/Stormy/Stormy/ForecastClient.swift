//
//  ForecastClient.swift
//  Stormy
//
//  Created by Davide Callegari on 26/04/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation


struct Coordinate {
    let latitude: Double
    let longitude: Double
}

enum Forecast : EndPoint {
    case Current(token: String, coordinate: Coordinate)
    
    var baseUrl: URL {
        return URL(string: "https://api.darksky.net")!
    }
    
    var path : String {
        switch self {
        case .Current(let token, let coordinate):
            return "/forecast/\(token)/\(coordinate.latitude),\(coordinate.longitude)"
        }
    }
    
    var request : URLRequest {
        let url = URL(string: path, relativeTo: baseUrl)!
        return URLRequest(url: url)
    }
}


final class ForecastClient : APIClient {
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    private let token: String
    
    init(config: URLSessionConfiguration, APIKey: String) {
        self.configuration = config
        self.token = APIKey
    }
    
    convenience init(APIKey: String) {
        self.init(config: URLSessionConfiguration.default, APIKey: APIKey)
    }
    
    func fetchCurrentWeather(coordinate: Coordinate, completion: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = Forecast.Current(token: self.token, coordinate: coordinate).request
        
        fetch(request: request, parse: { (json) -> CurrentWeather? in
            if let currently = json["currently"] as? [String: AnyObject] {
                return CurrentWeather(json: currently)
            } else {
                return nil
            }
        }, completion: completion)
    }
}
