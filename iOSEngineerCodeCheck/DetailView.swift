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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                headerSection
                
                // Stats Section
                statsSection
                
                Spacer(minLength: 32)
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Avatar
            AsyncImage(url: URL(string: repository.owner.avatarURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding()
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.1), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.2)
                    )
            }
            
            // Repository Name
            VStack(spacing: 8) {
                Text(repository.fullName)
                    .font(.title.weight(.semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Language Badge
                if let language = repository.language {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.primary)
                            .frame(width: 8, height: 8)
                        Text(language)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                }
            }
        }
        .padding(.top, 32)
        .padding(.bottom, 40)
        .padding(.horizontal, 24)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: 0) {
            // Section Title
            HStack {
                Text("Overview")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            // Stats Grid
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    statCard(value: repository.stargazersCount, label: "Stars", icon: "star.fill")
                    statCard(value: repository.watchersCount, label: "Watchers", icon: "eye.fill")
                }
                HStack(spacing: 1) {
                    statCard(value: repository.forksCount, label: "Forks", icon: "tuningfork")
                    statCard(value: repository.openIssuesCount, label: "Issues", icon: "exclamationmark.circle.fill")
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 32)
    }
    
    // MARK: - Helper Views
    private func statCard(value: Int, label: String, icon: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.primary)
            
            Text(formatNumber(value))
                .font(.title2.weight(.bold))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
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
}
