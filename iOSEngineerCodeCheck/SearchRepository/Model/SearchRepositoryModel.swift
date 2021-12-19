//
//  SearchRepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol SearchRepositoryModelInput {
    func fetchRepositories(
        searchKeyword: String,
        completionHandler: @escaping (Result<[GitHubRepository], GitHubClientError>) -> Void
    )
    func cancel()
}

final class SearchRepositoryModel: SearchRepositoryModelInput {
    private var client = GitHubClient()

    /// リポジトリ一覧の取得
    func fetchRepositories(
        searchKeyword: String,
        completionHandler: @escaping (Result<[GitHubRepository], GitHubClientError>) -> Void
    ) {
        let request = GitHubAPI.GitHubSearchRepo(keyword: searchKeyword)
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                guard let items = response.items else {
                    completionHandler(.failure(.noData))
                    return
                }
                completionHandler(.success(items))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }

    /// 取得処理のキャンセル
    func cancel() {
        client.cancel()
    }
}
