//
//  SearchRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct SearchRepositoryView: View {
    @ObservedObject private var viewModel = SearchRepositoryViewModel()
    @Environment(\.isSearching) var isSearching

    var body: some View {
        NavigationView {
            VStack {
                List(0..<viewModel.repositories.count, id: \.self) { index in
                    NavigationLink(destination: RepositoryDetailView(
                        repository: viewModel.repositories[index],
                        imageData: viewModel.imageData[viewModel.repositories[index].uuid] as? Data
                    )) {
                        RepositoryCellView(
                            repository: viewModel.repositories[index],
                            imageData: viewModel.imageData[viewModel.repositories[index].uuid] as? Data
                        )
                    }
                }
                .listStyle(PlainListStyle())
            }
            .searchable(
                text: $viewModel.keyword,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "リポジトリ名"
            )
            .onSubmit(of: .search) {
                viewModel.didTapSearchButton()
            }
            .alert("取得失敗", isPresented: $viewModel.isShownErrorAlert) {
                // do nothing
            } message: {
                Text("リポジトリ情報の取得に失敗しました。\nもう一度試すか、別のワードで検索してください")
            }
            .onChange(of: viewModel.keyword) { newValue in
                if newValue.isEmpty {
                    viewModel.didTapClearButton()
                }
            }
            .onChange(of: isSearching) { newValue in
                if newValue {
                    print("テスト")
                }
            }
            .navigationBarTitle("検索", displayMode: .inline)
        }
        .customProgressView($viewModel.isShownProgressView)
    }
}

struct SearchRepository_Previews: PreviewProvider {
    static var previews: some View {
        SearchRepositoryView()
    }
}
