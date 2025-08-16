//
//  DetailViewController.swift
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
    
    // 表示に必要なデータだけを保持する
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let repo = repository else { return }
        
        // 受け取ったデータをUIに設定
        titleLabel.text = repo.fullName
        languageLabel.text = "Written in \(repo.language ?? "N/A")"
        starsCountLabel.text = "\(repo.stargazersCount) stars"
        watcherCountLabel.text = "\(repo.watchersCount) watchers"
        forksCountLabel.text = "\(repo.forksCount) forks"
        issuesCountLabel.text = "\(repo.openIssuesCount) open issues"
        
        loadImage(from: repo.owner.avatarURL)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print("Image download error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }.resume()
    }
}
