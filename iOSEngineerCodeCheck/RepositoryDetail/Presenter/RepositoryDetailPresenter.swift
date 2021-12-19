//
//  RepositoryDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryDetailPresenterInput {
    var repository: GitHubRepository { get }
    func viewDidLoad()
}

protocol RepositoryDetailPresenterOutput: AnyObject {
    func getImage(data: Data?)
}

class RepositoryDetailPresenter: RepositoryDetailPresenterInput {
    private(set) var repositoryForPresenter: GitHubRepository
    private weak var view: RepositoryDetailPresenterOutput!
    private var model: RepositoryDetailModelInput

    init(
        repository: GitHubRepository,
        view: RepositoryDetailPresenterOutput,
        model: RepositoryDetailModelInput
    ) {
        self.repositoryForPresenter = repository
        self.view = view
        self.model = model
    }

    /// 表示するリポジトリの情報
    var repository: GitHubRepository {
        return self.repositoryForPresenter
    }

    /// リポジトリ詳細画面の初期表示時の処理
    func viewDidLoad() {
        guard let url = repositoryForPresenter.owner.avatarURL
        else {
            return
        }
        model.getImage(imageURL: url) { [weak self] result in
            guard let self = self else {
                return
            }
            guard let result = result
            else {
                DispatchQueue.main.async {
                    self.view.getImage(data: nil)
                }
                return
            }
            DispatchQueue.main.async {
                self.view.getImage(data: result)
            }
        }
    }
}
