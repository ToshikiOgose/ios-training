//
//  InitialViewController.swift
//  YumemiProject
//
//  Created by 生越 歳規（Toshiki Ogose） on 2022/03/11.
//

import UIKit
import Foundation
class InitialViewController: UIViewController{
    var timer:Timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            // したかったこと　changedScreenの値がFalseか判断して天気の画面を再度開きたかった
            // 試そうとしたことRxSwiftで状態監視しようとしたがそのモジュールがないと言われて中断し先に進むことにした
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            self.performSegue(withIdentifier: "toNext", sender: nil)
            appDelegate.changedScreen = Bool(true)
        }
    }
}
