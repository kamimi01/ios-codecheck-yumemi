//
//  RepositoryMock.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Mika Urakawa on 2021/12/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
@testable import iOSEngineerCodeCheck

extension GitHubRepository {
    static func mock() -> GitHubRepository {
        let repoOwner = GitHubRepoOwner(
            avatarURL: "https://example.com"
        )
        let repo = GitHubRepository(
            fullName: "kamimi01/ios-codecheck-yumemi",
            language: "swift",
            stargazersCount: 10,
            watchersCount: 20,
            forksCount: 30,
            openIssuesCount: 40,
            owner: repoOwner
        )
        return repo
    }
}
