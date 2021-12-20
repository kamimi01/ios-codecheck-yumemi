//
//  SearchRepositoryViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class SearchRepositoryViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var repositories = [GitHubRepository]()
    @Published var isShownErrorAlert = false
    @Published var imageData = [String: Data?]()

    private var model: SearchRepositoryModelInput

    init(model: SearchRepositoryModel = SearchRepositoryModel()) {
        self.model = model
    }

    /// 検索バーでエンターが押下された時の処理
    func didTapSearchButton() {
        guard !keyword.isEmpty else {
            return
        }

        model.fetchRepositories(searchKeyword: keyword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.repositories = response
                }
                self.getImage(repositories: response)
            case .failure:
                DispatchQueue.main.async {
                    self.isShownErrorAlert.toggle()
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
}
