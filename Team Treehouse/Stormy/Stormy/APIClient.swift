//
//  APIClient.swift
//  Stormy
//
//  Created by Davide Callegari on 25/04/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

public let BrokensealNetworkingErrorDomain = "com.brokenseal.Stormy.NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 11

typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, NSError?) -> Void
typealias JSONTask = URLSessionDataTask

enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol EndPoint {
    var baseUrl: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

protocol JSONDecodable {
    init?(json: [String: AnyObject])
}

protocol APIClient {
    var configuration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    init(config: URLSessionConfiguration, APIKey: String)
    
    func JSONTaskWithRequest(request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask
    func fetch<T:JSONDecodable>(request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResult<T>) -> Void)
}


extension APIClient {
    func JSONTaskWithRequest(request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask {
        let task = session.dataTask(with: request) { data, response, error in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let error = NSError(
                    domain: BrokensealNetworkingErrorDomain,
                    code: MissingHTTPResponseError,
                    userInfo: [
                        NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                    ]
                )
                completion(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error as NSError)
                }
            } else {
                switch HTTPResponse.statusCode {
                    case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completion(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completion(nil, HTTPResponse, error)
                    }
                default:
                    // DOH
                    completion(nil, nil, NSError(
                        domain: BrokensealNetworkingErrorDomain,
                        code: MissingHTTPResponseError,
                        userInfo: [
                            NSLocalizedDescriptionKey: NSLocalizedString(
                                "Wrong HTTP Response",
                                comment: "HTTP Response code: \(HTTPResponse.statusCode)"
                            )
                        ]
                    ))
                }
            }
        }
        
        return task
    }
    
    func fetch<T:JSONDecodable>(request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWithRequest(request: request) { json, response, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(.Failure(error))
                    } else {
                        let error = NSError(
                            domain: BrokensealNetworkingErrorDomain,
                            code: UnexpectedResponseError,
                            userInfo: [
                                NSLocalizedDescriptionKey: NSLocalizedString(
                                    "Generic fetch issue",
                                    comment: ""
                                )
                            ]
                        )
                        completion(.Failure(error))
                    }
                    return
                }
                
                if let value = parse(json) {
                    completion(.Success(value))
                } else {
                    let error = NSError(
                        domain: BrokensealNetworkingErrorDomain,
                        code: UnexpectedResponseError,
                        userInfo: [
                            NSLocalizedDescriptionKey: NSLocalizedString(
                                "Parsing failure",
                                comment: ""
                            )
                        ]
                    )
                    completion(.Failure(error))
                }
            }
        }
        
        task.resume()
    }
}
