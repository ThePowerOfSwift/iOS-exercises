//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 4/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController {
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = LocationManager()
    
    lazy var forecastApiClient = {
        return ForecastClient(APIKey: DARK_SKY_API_SECRET_KEY)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.getPermission()
        
        fetchCurrentWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        fetchCurrentWeather()
    }
    
    func fetchCurrentWeather(){
        toggleRefreshAnimation(to: true)
        
        locationManager.getCurrentCoordinates() {coordinate in
            self.forecastApiClient.fetchCurrentWeather(coordinate: coordinate) { result in
                self.toggleRefreshAnimation(to: false)
                
                switch result {
                case .Success(let currentWeather):
                    self.display(weather: currentWeather)
                case .Failure(let error as NSError):
                    DispatchQueue.main.async {
                        self.showAlert("Unable to retrieve forecast", message: error.localizedDescription)
                    }
                default:
                    fatalError("meh")
                }
            }
        }
    }
    
    func display(weather: CurrentWeather){
        currentTemperatureLabel.text = weather.temperatureString
        currentHumidityLabel.text = weather.humidityString
        currentPrecipitationLabel.text = weather.precipitationProbabilityString
        currentSummaryLabel.text = weather.summary
        currentWeatherIcon.image = weather.icon
    }
    
    func toggleRefreshAnimation(to: Bool){
        refreshButton.isHidden = to
        
        if to {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension CurrentWeather {
    var temperatureString : String {
        return "\(Int(temperature))°"
    }
    
    var humidityString : String {
        return "\(Int(humidity * 100))%"
    }
    
    var precipitationProbabilityString : String {
        return "\(Int(precipitationProbability * 100))%"
    }
}
