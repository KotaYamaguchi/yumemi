//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    
    @IBOutlet weak var TtlLbl: UILabel!
    
    @IBOutlet weak var LangLbl: UILabel!
    
    @IBOutlet weak var StrsLbl: UILabel!
    @IBOutlet weak var WchsLbl: UILabel!
    @IBOutlet weak var FrksLbl: UILabel!
    @IBOutlet weak var IsssLbl: UILabel!
    
    var vc1: ViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = vc1.repo[vc1.idx]
        
        LangLbl.text = "Written in \(repo["language"] as? String ?? "")"
        StrsLbl.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        WchsLbl.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        FrksLbl.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        IsssLbl.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
        
    }
    
    func getImage() {
        let repo = vc1.repo[vc1.idx]
        TtlLbl.text = repo["full_name"] as? String

        // オプショナルバインディングで安全にオーナー情報と画像URLを取得
        guard let owner = repo["owner"] as? [String: Any],
              let imgURLString = owner["avatar_url"] as? String,
              let imgURL = URL(string: imgURLString) else {
            // いずれかの取得に失敗した場合、以降の処理を中断
            return
        }

        // URLSessionを使って画像を非同期でダウンロード
        URLSession.shared.dataTask(with: imgURL) { [weak self] (data, res, err) in
            // selfが解放済みの場合や、エラーがある場合、データがない場合は処理を中断
            guard let self = self, err == nil, let data = data, let img = UIImage(data: data) else {
                return
            }

            // メインスレッドで画像を表示
            DispatchQueue.main.async {
                self.ImgView.image = img
            }
        }.resume()
    }
    
}
