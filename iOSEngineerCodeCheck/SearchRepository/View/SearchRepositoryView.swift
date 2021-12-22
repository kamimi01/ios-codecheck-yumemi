//
//  SearchRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

enum OrderType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case star = "stars"
    case fork = "forks"
    case watcher = "watchers"
    case issue = "issues"
}

struct SearchRepositoryView<ViewModel: SearchRepositoryViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isShownDialog = false

    var body: some View {
        NavigationView {
            VStack(alignment: .trailing) {
                if viewModel.repositories.count != 0 {
                    orderSelection
                        .padding(.trailing, 16)
                }
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
            .navigationBarTitle("検索", displayMode: .inline)
        }
        .customProgressView($viewModel.isShownProgressView)
    }
}

extension SearchRepositoryView {
    private var orderSelection: some View {
        Button(action: {
            isShownDialog.toggle()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.up.arrow.down")
                Text(viewModel.orderType.rawValue)
                    .font(.system(size: 17))
            }
            .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .border(.gray)
        .confirmationDialog("数が大きい順", isPresented: $isShownDialog) {
            ForEach(OrderType.allCases) { type in
                Button(action: {
                    viewModel.didTapOrderButton(type)
                }) {
                    Text(type.rawValue)
                }
            }
        }
    }
}

struct SearchRepository_Previews: PreviewProvider {
    class SearchRepositoryViewModelMock: SearchRepositoryViewModelProtocol {
        @Published var keyword = ""
        @Published var isShownErrorAlert = false
        @Published var imageData: [String: Data?] = [:]
        @Published var isShownProgressView = false
        @Published var repositories = [GitHubRepository]()
        @Published var orderType = OrderType.star

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

        func didTapOrderButton(_ type: OrderType) {
            print("ソートボタンが押下された")
        }
    }

    class SearchRepositoryViewModelLoadingMock: SearchRepositoryViewModelProtocol {
        @Published var keyword = ""
        @Published var isShownErrorAlert = false
        @Published var imageData: [String: Data?] = [:]
        @Published var isShownProgressView = true
        @Published var repositories = [GitHubRepository]()
        @Published var orderType = OrderType.star

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
            print("検索ボタンが押下された")
        }

        func didTapClearButton() {
            print("クリアボタンが押下された")
        }

        func didTapOrderButton(_ type: OrderType) {
            print("ソートボタンが押下された")
        }
    }

    static var previews: some View {
        Group {
            SearchRepositoryView(viewModel: SearchRepositoryViewModelMock())

            SearchRepositoryView(viewModel: SearchRepositoryViewModelLoadingMock())
        }
    }
}
