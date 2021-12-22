//
//  SearchRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct SearchRepositoryView<ViewModel: SearchRepositoryViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
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
    class SearchRepositoryViewModelMock: SearchRepositoryViewModelProtocol {
        @Published var keyword = ""
        @Published var isShownErrorAlert = false
        @Published var imageData: [String: Data?] = [:]
        @Published var isShownProgressView = false
        @Published var repositories = [GitHubRepository]()

        init() {
            let stubOwner = GitHubRepoOwner(avatarURL: "https://example.com")
            self.repositories = [
                GitHubRepository(
                    fullName: "リポジトリ",
                    language: "Swift",
                    description: "詳細",
                    stargazersCount: 10,
                    watchersCount: 20,
                    forksCount: 30,
                    openIssuesCount: 40,
                    owner: stubOwner
                )
            ]
        }

        func didTapSearchButton() {
            print("検索ボタンがタップされた")
        }

        func didTapClearButton() {
            print("クリアボタンがタップされた")
        }
    }

    static var previews: some View {
        SearchRepositoryView(viewModel: SearchRepositoryViewModelMock())
    }
}
