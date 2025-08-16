//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by Kota Yamaguchi on 2025/08/15.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import Foundation

// APIレスポンス全体に合わせた構造体
struct SearchResponse: Codable {
    let items: [Repository]
}

// リポジトリのデータを保持する構造体
struct Repository: Codable, Identifiable {
    let id: Int
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner

    // JSONのキー(snake_case)をSwiftのプロパティ(camelCase)にマッピングする
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner
    }
}
// オーナー情報（アバター画像URL）を保持する構造体
struct Owner: Codable {
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
