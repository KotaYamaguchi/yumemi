//
//  RootView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kota Yamaguchi on 2025/08/16.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @State private var searchText = ""
    var body :some View {
        NavigationStack{
            
            List{
                
            }
            .searchable(text: $searchText, prompt: Text("GitHubのリポジトリを検索できるよー"))
            .navigationTitle("GitHubリポジトリ検索")
        }
        
    }
}
    

#Preview {
    RootView()
}
