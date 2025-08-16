//
//  DetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kota Yamaguchi on 2025/08/16.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let repository: Repository
    var body: some View {
         VStack {
             // AsyncImageを使ってURLから直接画像を読み込む
             AsyncImage(url: URL(string: repository.owner.avatarURL)) { image in
                 image
                     .resizable()
                     .scaledToFit()
                     .clipShape(Circle())
             } placeholder: {
                 // 読み込み中はインジケーターなどを表示
                 ProgressView()
             }
             .frame(width: 100, height: 100)
             .padding()

             Text(repository.fullName)
                 .font(.title)
                 .padding()
             
             Text("Language: \(repository.language ?? "N/A")")
                 .font(.subheadline)
                 .padding(.bottom)

             HStack {
                 // View内でオプショナルを扱う必要がなくなりスッキリする
                 VStack(alignment: .leading) {
                     Text("Stars: \(repository.stargazersCount)")
                     Text("Watchers: \(repository.watchersCount)")
                     Text("Forks: \(repository.forksCount)")
                     Text("Open Issues: \(repository.openIssuesCount)")
                 }
                 Spacer()
             }
             .padding(.horizontal)
             
             Spacer() // 全体を上寄せにする
         }
         .navigationTitle("詳細")
         .navigationBarTitleDisplayMode(.inline)
     }
 }

