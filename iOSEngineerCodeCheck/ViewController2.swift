//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watcherCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var issuesCountLabel: UILabel!
    
    var vc1: RootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repositories = vc1.repositories[vc1.pathIndex]
        
        languageLabel.text = "Written in \(repositories["language"] as? String ?? "")"
        starsCountLabel.text = "\(repositories["stargazers_count"] as? Int ?? 0) stars"
        watcherCountLabel.text = "\(repositories["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repositories["forks_count"] as? Int ?? 0) forks"
        issuesCountLabel.text = "\(repositories["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
        
    }
    
    func getImage() {
        let repositories = vc1.repositories[vc1.pathIndex]
        titleLabel.text = repositories["full_name"] as? String
        // オプショナルバインディングで安全にオーナー情報と画像URLを取得
        guard let owner = repositories["owner"] as? [String: Any],
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
                self.avatarImageView.image = img
            }
        }.resume()
    }
    
}
