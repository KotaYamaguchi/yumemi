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
        NavigationStack {
            List {
                ForEach(rootViewModel.repositories) { repository in
                    NavigationLink(destination: DetailView(repository: repository)) {
                        repositoryRow(repository: repository)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
            }
            .listStyle(.plain)
            .searchable(text: $rootViewModel.searchText, prompt: Text("GitHubのリポジトリを検索できるよー"))
            .navigationTitle("GitHubリポジトリ検索")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func repositoryRow(repository: Repository) -> some View {
        HStack(spacing: 16) {
            // Avatar
            AsyncImage(url: URL(string: repository.owner.avatarURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.title3)
                            .foregroundColor(.gray)
                    )
            }
            
            // Repository Info
            VStack(alignment: .leading, spacing: 8) {
                // Repository Name
                Text(repository.fullName)
                    .font(.headline.weight(.medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Language and Stats Row
                HStack(spacing: 16) {
                    // Language
                    if let language = repository.language {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(languageColor(for: language))
                                .frame(width: 10, height: 10)
                            Text(language)
                                .font(.caption.weight(.medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Stars
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(formatNumber(repository.stargazersCount))
                            .font(.caption.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                    
                    // Forks
                    HStack(spacing: 4) {
                        Image(systemName: "tuningfork")
                            .font(.caption)
                            .foregroundColor(.primary)
                        Text(formatNumber(repository.forksCount))
                            .font(.caption.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            
            if number >= 1000000 {
                return "\(formatter.string(from: NSNumber(value: Double(number) / 1000000.0)) ?? "0")M"
            } else {
                return "\(formatter.string(from: NSNumber(value: Double(number) / 1000.0)) ?? "0")K"
            }
        }
        return "\(number)"
    }
    
    private func languageColor(for language: String) -> Color {
        switch language.lowercased() {
        case "swift": return .orange
        case "javascript", "typescript": return .yellow
        case "python": return .blue
        case "java": return .red
        case "kotlin": return .purple
        case "go": return .cyan
        case "rust": return .brown
        case "c++", "c": return .blue
        case "ruby": return .red
        case "php": return .indigo
        default: return .gray
        }
    }
}

#Preview {
    RootView()
}
