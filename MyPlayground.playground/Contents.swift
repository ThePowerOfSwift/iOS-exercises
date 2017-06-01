import UIKit


enum WeatherIcon: String {
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Fog = "fog"
    case Cloudy = "cloudy"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"
    case UnexpectedType = "default"
    
    init(rawValue: String) {
        self.init(rawValue: rawValue)
        print(self)
    }
}

extension WeatherIcon {
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}

WeatherIcon(rawValue: "wind")
WeatherIcon(rawValue: "partly-cloudy-day")
WeatherIcon(rawValue: "eeee")
