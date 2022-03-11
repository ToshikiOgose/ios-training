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

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var reloadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func fetchWeatherData(_ sender: Any) {
        do {
            let fetchedWeatherData = try YumemiWeather.fetchWeather(at:"tokyo")
            let fetchedDataImage = UIImage(named:fetchedWeatherData)
            //fetchedDataImage?.withTintColor(.orange)
            weatherImageView.image = fetchedDataImage
            switch fetchedWeatherData {
            case "rainy":
                weatherImageView.tintColor = .blue
            case "sunny":
                weatherImageView.tintColor = .red
            default:
                weatherImageView.tintColor = .gray
            }
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

