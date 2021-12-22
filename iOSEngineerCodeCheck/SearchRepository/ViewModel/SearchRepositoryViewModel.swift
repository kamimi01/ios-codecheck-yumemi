//
//  SearchRepositoryViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol SearchRepositoryViewModelProtocol: ObservableObject {
    var keyword: String { get set }
    var repositories: [GitHubRepository] { get }
    var isShownErrorAlert: Bool { get set }
    var imageData: [String: Data?] { get }
    var isShownProgressView: Bool { get set }
    var orderType: OrderType { get set }
    func didTapSearchButton()
    func didTapClearButton()
    func didTapOrderButton(_ type: OrderType)
}

class SearchRepositoryViewModel: SearchRepositoryViewModelProtocol {
    @Published var keyword = ""
    @Published var repositories = [GitHubRepository]()
    @Published var isShownErrorAlert = false
    @Published var imageData = [String: Data?]()
    @Published var isShownProgressView = false
    @Published var orderType = OrderType.star

    private var model: SearchRepositoryModelInput

    init(model: SearchRepositoryModelInput = SearchRepositoryModel()) {
        self.model = model
    }

    /// 検索バーでエンターが押下された時の処理
    func didTapSearchButton() {
        guard !keyword.isEmpty else {
            return
        }

        isShownProgressView = true
        model.fetchRepositories(searchKeyword: keyword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.repositories = response
                    self.sort(.star)
                    self.isShownProgressView = false
                }
                self.getImage(repositories: response)
            case .failure:
                DispatchQueue.main.async {
                    self.isShownErrorAlert.toggle()
                    self.isShownProgressView = false
                }
            }
        }
    }

    /// 画像取得処理
    private func getImage(repositories: [GitHubRepository]) {
        DispatchQueue.global().async {
            repositories.forEach { [weak self] repo in
                guard let self = self,
                      let url = repo.owner.avatarURL else {
                    return
                }
                self.model.getImage(imageURL: url) { [weak self] result in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.imageData[repo.uuid] = result
                    }
                }
            }
        }
    }

    /// キャンセルボタンが押下された時の処理
    func didTapClearButton() {
        model.cancel()
    }

    /// ソートボタンが押下された時の処理
    func didTapOrderButton(_ type: OrderType) {
        isShownProgressView = true
        sort(type)
        isShownProgressView = false
    }

    private func sort(_ type: OrderType) {
        orderType = type
        switch type {
        case .star:
            repositories.sort {
                $0.stargazersCount ?? 0 > $1.stargazersCount ?? 0
            }
        case .fork:
            repositories.sort {
                $0.forksCount ?? 0 > $1.forksCount ?? 0
            }
        case .watcher:
            repositories.sort {
                $0.watchersCount ?? 0 > $1.watchersCount ?? 0
            }
        case .issue:
            repositories.sort {
                $0.openIssuesCount ?? 0 > $1.openIssuesCount ?? 0
            }
        }
    }
}
