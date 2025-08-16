//
//  RootViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var repositorySearchBar: UISearchBar!
    
    private var repositories: [Repository] = []
    private let apiClient = GitHubAPIClient() // APIクライアントを保持
    private var searchTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositorySearchBar.text = "GitHubのリポジトリを検索できるよー"
        repositorySearchBar.delegate = self
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 編集が開始される直前に、検索バーのテキストを空にする
        searchBar.text = ""
        return true // trueを返すことで編集を許可する
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let word = searchBar.text, !word.isEmpty else { return }
        searchBar.resignFirstResponder() // キーボードを閉じる
        
        // APIクライアントに検索を依頼
        apiClient.searchRepositories(query: word) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let repositories):
                self.repositories = repositories
                self.tableView.reloadData()
            case .failure(let error):
                // TODO: ユーザーにエラーを通知するアラートなどを表示
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "Detail" {
             guard let detailVC = segue.destination as? DetailViewController,
                   let selectedRepository = sender as? Repository else {
                 return
             }
             // 選択されたリポジトリのデータモデルを直接渡す
             detailVC.repository = selectedRepository
         }
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return repositories.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
         let repository = repositories[indexPath.row]
         cell.textLabel?.text = repository.fullName
         cell.detailTextLabel?.text = repository.language
         return cell
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedRepository = repositories[indexPath.row]
         // Segueにデータモデルを渡す
         performSegue(withIdentifier: "Detail", sender: selectedRepository)
     }
}
