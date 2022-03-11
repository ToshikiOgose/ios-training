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
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    // 天気JSONデータ構造体
    struct WeatherJson: Codable {  // Codableインターフェースを実装する
        let max_temp: Int
        let min_temp: Int
        let weather: String
    }
    // 送信用JSONデータ構造体
    struct SendingParams:Codable {
        var area: String
        var date: Date?
    }
    // UI変数
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @objc func foreground(notification: Notification) {
        getWeatherData()
    }
    @objc func background(notification: Notification) {
        print("バックグラウンド")
    }
    // 初期呼出
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.changedScreen = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foreground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(background(notification:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil
        )
        // Do any additional setup after loading the view.
    }
    @IBAction func closingScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        appDelegate.changedScreen = false
    }
    // Reloadボタン押下時、天気データの取得
    @IBAction func fetchWeatherData(_ sender: Any) {
        getWeatherData()
    }
    func getWeatherData(){
        do {
            // 送信JSONデータ作成
            let sendingParamJson = SendingParams(area: "tokyo", date: Date())
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            // 送信JSONデータをバイト化
            let sendingParamData = try! encoder.encode(sendingParamJson)
            // 送信JSONデータを文字列化
            let sendingParamJsonString = String(data: sendingParamData, encoding: .utf8)!
            // 送信JSONデータを送信
            let fetchedWeatherData = try YumemiWeather.fetchWeather(sendingParamJsonString)
            // 取得データをバイト化
            let weatherData = fetchedWeatherData.data(using: .utf8)
            // 取得データをJSON化
            let weatherJsonData = try! JSONDecoder().decode(WeatherJson.self, from: weatherData!)
            // 画像データの決定
            let fetchedDataImage = UIImage(named:weatherJsonData.weather)
            // 画像データをセット
            weatherImageView.image = fetchedDataImage
            // 画像の色分岐
            switch weatherJsonData.weather {
            case "rainy":
                weatherImageView.tintColor = .blue
            case "sunny":
                weatherImageView.tintColor = .red
            default:
                weatherImageView.tintColor = .gray
            }
            // 最低最高気温を設定
            minTemp.text = String(describing: weatherJsonData.min_temp)
            maxTemp.text = String(describing: weatherJsonData.max_temp)
        }catch{
            // エラー分岐処理
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

