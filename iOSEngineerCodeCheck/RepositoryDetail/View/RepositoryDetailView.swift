//
//  RepositoryDetail.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

class RepositoryDetailPage {
    static let repoTitleID = "RepositoryDetailView_title"
    static let starCountID = "RepositoryDetailView_starcount"
    static let descriptionID = "RepositoryDetailView_description"
    static let watchersCountID = "RepositoryDetailView_watcherscount"
    static let forksCountID = "RepositoryDetailView_forkscount"
    static let issuesCountID = "RepositoryDetailView_issuescount"
}

struct RepositoryDetailView: View {
    var repository: GitHubRepository
    var imageData: Data?

    var body: some View {
        VStack(spacing: 20) {
            image
            repoTitle
                .accessibilityIdentifier(RepositoryDetailPage.repoTitleID)
            starCount
                .accessibilityIdentifier(RepositoryDetailPage.starCountID)
            repoDesctiption
                .accessibilityIdentifier(RepositoryDetailPage.descriptionID)
            countDetail
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarTitle("詳細", displayMode: .inline)
    }
}

extension RepositoryDetailView {
    private var image: some View {
        OwnerImageView(imageSize: .big, data: imageData)
    }

    private var repoTitle: some View {
        Text(unwrap(repository.fullName))
            .font(.system(size: 25))
    }

    private var starCount: some View {
        HStack {
            Image(systemName: "star")
                .foregroundColor(.gray)
            Text("\(unwrap(repository.stargazersCount))")
                .font(.system(size: 17))
        }
    }

    private var repoDesctiption: some View {
        Text(unwrap(repository.description))
            .font(.system(size: 17))
    }

    private var countDetail: some View {
        HStack {
            VStack {
                Text("\(unwrap(repository.watchersCount))")
                    .accessibilityIdentifier(RepositoryDetailPage.watchersCountID)
                Text("watchers")
            }
            Spacer()
            VStack {
                Text("\(unwrap(repository.forksCount))")
                    .accessibilityIdentifier(RepositoryDetailPage.forksCountID)
                Text("forks")
            }
            Spacer()
            VStack {
                Text("\(unwrap(repository.openIssuesCount))")
                    .accessibilityIdentifier(RepositoryDetailPage.issuesCountID)
                Text("issues")
            }
        }
        .padding(.horizontal, 20)
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static let stubOwner = GitHubRepoOwner(avatarURL: "https://example.com")
    static let stubRepo = GitHubRepository(
        fullName: "リポジトリ",
        language: "Swift",
        description: "詳細",
        stargazersCount: 10,
        watchersCount: 20,
        forksCount: 30,
        openIssuesCount: 40,
        owner: stubOwner
    )

    static var previews: some View {
        RepositoryDetailView(repository: stubRepo)
    }
}
