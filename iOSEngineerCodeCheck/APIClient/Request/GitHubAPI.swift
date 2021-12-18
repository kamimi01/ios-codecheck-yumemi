//
//  GitHubAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

final class GitHubAPI {
    /// リポジトリ検索API
    struct GitHubSearchRepo: GitHubAPIRequest {
        let keyword: String

        typealias Response = GitHubSearchRepositories

        var method: HttpMethod {
            return .get
        }
        var path: String {
            return "/search/repositories"
        }
        var queryItems: [URLQueryItem] {
            return [URLQueryItem(name: "q", value: keyword)]
        }
        var headers: [String: String] {
            return [:]
        }
    }
}
