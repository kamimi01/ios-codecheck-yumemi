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
            description: "",
            stargazersCount: 10,
            watchersCount: 20,
            forksCount: 30,
            openIssuesCount: 40,
            owner: repoOwner
        )
        return repo
    }

    static func mockNoImage() -> GitHubRepository {
        let repoOwner = GitHubRepoOwner(
            avatarURL: ""
        )
        let repo = GitHubRepository(
            fullName: "kamimi01/ios-codecheck-yumemi",
            language: "swift",
            description: "",
            stargazersCount: 10,
            watchersCount: 20,
            forksCount: 30,
            openIssuesCount: 40,
            owner: repoOwner
        )
        return repo
    }

    static func mockForSort() -> [GitHubRepository] {
        let repoOwner = GitHubRepoOwner(
            avatarURL: ""
        )

        return [
            GitHubRepository(
                fullName: "starSort",
                language: "swift",
                description: "",
                stargazersCount: 40,
                watchersCount: 10,
                forksCount: 10,
                openIssuesCount: 20,
                owner: repoOwner
            ),
            GitHubRepository(
                fullName: "watcherSort",
                language: "swift",
                description: "",
                stargazersCount: 20,
                watchersCount: 30,
                forksCount: 20,
                openIssuesCount: 10,
                owner: repoOwner
            ),
            GitHubRepository(
                fullName: "forkSort",
                language: "swift",
                description: "",
                stargazersCount: 10,
                watchersCount: 20,
                forksCount: 30,
                openIssuesCount: 20,
                owner: repoOwner
            ),
            GitHubRepository(
                fullName: "issueSort",
                language: "swift",
                description: "",
                stargazersCount: 30,
                watchersCount: 20,
                forksCount: 30,
                openIssuesCount: 30,
                owner: repoOwner
            )
        ]
    }
}
