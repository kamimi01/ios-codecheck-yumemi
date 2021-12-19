//
//  SearchRepositoryPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

protocol SearchRepositoryPresenterInput {
    var numberOfRepositories: Int { get }
    func repository(forRow row: Int) -> GitHubRepository?
    func didTapSearchButton(keyword: String?)
    func didTapSelectRow(at indexPath: IndexPath)
    func didTapClearButton()
}

protocol SearchRepositoryPresenterOutput: AnyObject {
    func updateRepositories(_ repositories: [GitHubRepository])
    func transitionToRepositoryDetail(repository: GitHubRepository)
}

final class SearchRepositoryPresenter: SearchRepositoryPresenterInput {
    private(set) var repositories: [GitHubRepository] = []
    private weak var view: SearchRepositoryPresenterOutput!
    private var model: SearchRepositoryModelInput

    init(
        view: SearchRepositoryPresenterOutput,
        model: SearchRepositoryModelInput
    ) {
        self.view = view
        self.model = model
    }

    /// 検索にヒットしたリポジトリ数
    var numberOfRepositories: Int {
        return repositories.count
    }

    /// 押下されたセルのリポジトリ情報の取得
    func repository(forRow row: Int) -> GitHubRepository? {
        guard row < repositories.count else {
            return nil
        }
        return repositories[row]
    }

    /// 検索バーが押下された時の処理
    func didTapSearchButton(keyword: String?) {
        guard let keyword = keyword,
              keyword.count != 0
        else {
            return
        }

        model.fetchRepositories(searchKeyword: keyword) { [weak self] result in
            guard let self = self else { return }
            guard let result = result else {
                // TODO: エラー処理を行う
                return
            }
            self.repositories = result
            DispatchQueue.main.async {
                self.view.updateRepositories(result)
            }
        }
    }

    /// セルが押下された時の処理
    func didTapSelectRow(at indexPath: IndexPath) {
        guard let repository = repository(forRow: indexPath.row) else {
            return
        }
        view.transitionToRepositoryDetail(repository: repository)
    }

    /// キャンセルボタンが押下された時の処理
    func didTapClearButton() {
        model.cancel()
    }
}
