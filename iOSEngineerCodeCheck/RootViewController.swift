//
//  RootViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

class RootViewModel:ObservableObject{
    
    @Published var repositories: [Repository] = []
    @Published var searchText: String = ""
    private let apiClient = GitHubAPIClient() // APIクライアントを保持
    private var cancellables = Set<AnyCancellable>() // Combine用
    init() {
          // searchTextが変更されたら自動で検索を実行する処理
          $searchText
              .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // 0.8秒待ってから実行
              .removeDuplicates() // 同じテキストでの連続検索を防ぐ
              .filter { !$0.isEmpty } // 空文字の場合は検索しない
              .sink { [weak self] query in
                  self?.searchRepositories(searchtext: query)
              }
              .store(in: &cancellables)
      }
    func searchRepositories(searchtext: String?) {
        guard let word = searchtext, !word.isEmpty else { return }
        
        // APIクライアントに検索を依頼
        apiClient.searchRepositories(query: word) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
