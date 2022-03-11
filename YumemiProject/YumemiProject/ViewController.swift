//
//  ViewController.swift
//  YumemiProject
//
//  Created by 生越 歳規（Toshiki Ogose） on 2022/03/10.
//

import UIKit
import Foundation
import YumemiWeather

class ViewController: UIViewController {
    struct WeatherJson: Codable {  // Codableインターフェースを実装する
        let max_temp: Int
        let min_temp: Int
        let weather: String
    }
    struct SendingParams:Codable {
        var area: String
        var date: Date?
    }
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func fetchWeatherData(_ sender: Any) {
        do {
            let sendingParamJson = SendingParams(area: "tokyo", date: Date())
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            let sendingParamData = try! encoder.encode(sendingParamJson)
            let sendingParamJsonString = String(data: sendingParamData, encoding: .utf8)!
            let fetchedWeatherData = try YumemiWeather.fetchWeather(sendingParamJsonString)
            let weatherData = fetchedWeatherData.data(using: .utf8)
            let weatherJsonData = try! JSONDecoder().decode(WeatherJson.self, from: weatherData!)
            let fetchedDataImage = UIImage(named:weatherJsonData.weather)
            //fetchedDataImage?.withTintColor(.orange)
            weatherImageView.image = fetchedDataImage
            switch weatherJsonData.weather {
            case "rainy":
                weatherImageView.tintColor = .blue
            case "sunny":
                weatherImageView.tintColor = .red
            default:
                weatherImageView.tintColor = .gray
            }
            minTemp.text = String(describing: weatherJsonData.min_temp)
            maxTemp.text = String(describing: weatherJsonData.max_temp)
        }catch{
            let errorString:String = String(describing:(type(of: error)))
            let message:String
            switch errorString {
            case "invalidParameterError":
                message = "入力情報に問題があります"
            case "unknownError":
                message = "調査のためにQAまでご連絡ください"
            default:
                message = "サポートまで連絡して下さい"
            }
            let alert = UIAlertController(title: errorString,
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

