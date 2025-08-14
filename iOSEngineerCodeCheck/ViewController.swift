//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var repositorySearchBar: UISearchBar!
    
    var repositories: [[String: Any]]=[]
    
    var searchTask: URLSessionTask?
    var searchText: String!
    var requestURLString: String!
    var pathIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repositorySearchBar.text = "GitHubのリポジトリを検索できるよー"
        repositorySearchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 検索キーワードを取得し、入力がない場合は早期リターン
        guard let word = searchBar.text, !word.isEmpty else {
            return
        }

        // 既存の通信タスクをキャンセル
        searchTask?.cancel()

        // APIリクエスト用のURLを生成
        let urlString = "https://api.github.com/search/repositories?q=\(word)"
        guard let url = URL(string: urlString) else {
            return // URLが無効な場合は処理を中断
        }

        // URLSessionを使ってAPIリクエストを実行
        searchTask = URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
            // 通信が完了し、データが取得できなかった場合や、selfが解放済みの場合は処理を中断
            guard let self = self, let data = data else {
                return
            }

            do {
                // JSONデータをパースし、リポジトリのリストを抽出
                guard let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let items = obj["items"] as? [[String: Any]] else {
                    return // JSONの形式が期待と異なる場合は処理を中断
                }

                // メインスレッドでUIを更新
                DispatchQueue.main.async {
                    self.repositories = items
                    self.tableView.reloadData()
                }
            } catch {
                // JSONパース中にエラーが発生した場合
                print("JSON parsing error: \(error.localizedDescription)")
                // エラー処理をここに記述することも可能
            }
        }
        
        // 定義したタスクを開始
        searchTask?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let dtl = segue.destination as! ViewController2
            dtl.vc1 = self
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let rp = repositories[indexPath.row]
        cell.textLabel?.text = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        pathIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
