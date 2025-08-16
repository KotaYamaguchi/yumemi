//
//  RootView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kota Yamaguchi on 2025/08/16.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @StateObject var rootViewModel = RootViewModel()
    var body: some View {
        NavigationStack{
            List {
                // ForEachはListの機能と統合できる
                ForEach(rootViewModel.repositories) { repository in
                    // NavigationLinkに遷移先とデータを正しく設定
                    NavigationLink(destination: DetailView(repository: repository)) {
                        VStack(alignment: .leading) {
                            Text(repository.fullName)
                                .font(.headline)
                            Text(repository.language ?? "N/A")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .searchable(text: $rootViewModel.searchText, prompt: Text("GitHubのリポジトリを検索できるよー"))
            .navigationTitle("GitHubリポジトリ検索")
        }
    }
}

#Preview {
    RootView()
}
