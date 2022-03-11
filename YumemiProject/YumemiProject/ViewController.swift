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
        let fetchedWeatherData = YumemiWeather.fetchWeather()
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
    }
    
}

