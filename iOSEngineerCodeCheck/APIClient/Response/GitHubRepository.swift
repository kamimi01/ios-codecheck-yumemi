//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubRepository: Decodable {
    let uuid = UUID().uuidString
    let fullName: String?
    let language: String?
    let description: String?
    let stargazersCount: Int?
    let watchersCount: Int?
    let forksCount: Int?
    let openIssuesCount: Int?
    let owner: GitHubRepoOwner

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case language
        case description
        case stargazersCount = "stargazers_count"
        case watchersCount = "wachers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner
    }
}
