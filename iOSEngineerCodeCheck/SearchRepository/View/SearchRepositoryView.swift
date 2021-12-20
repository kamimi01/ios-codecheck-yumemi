//
//  SearchRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct SearchRepositoryView: View {
    @State private var inputText = ""
    @State private var tmpList = [1,2,3,4,5,6]

    var body: some View {
        NavigationView {
            VStack {
                List(tmpList, id: \.self) { num in
                    NavigationLink(destination: RepositoryDetailView()) {
                        RepositoryCellView()
                    }
                }
                .listStyle(PlainListStyle())
            }
            .searchable(
                text: $inputText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "リポジトリ名"
            )
            .navigationBarTitle("検索", displayMode: .inline)
        }
    }
}

struct SearchRepository_Previews: PreviewProvider {
    static var previews: some View {
        SearchRepositoryView()
    }
}
