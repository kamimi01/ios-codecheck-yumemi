//
//  RepositoryCellView.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryCellView: View {
    var repository: GitHubRepository
    var imageData: Data?

    var body: some View {
        HStack(spacing: 10) {
            image
            VStack(alignment: .leading, spacing: 10) {
                repoTitle
                HStack {
                    language
                    Spacer()
                    starCount
                }
            }
        }
        .padding(.vertical, 10)
    }
}

extension RepositoryCellView {
    private var image: some View {
        OwnerImageView(imageSize: .small, data: imageData)
    }

    private var repoTitle: some View {
        Text(unwrap(repository.fullName))
            .font(.system(size: 20, weight: .semibold))
    }

    private var language: some View {
        Text(unwrap(repository.language))
            .font(.system(size: 17))
    }

    private var starCount: some View {
        HStack(spacing: 5) {
            Image(systemName: "star")
                .foregroundColor(.gray)
            Text("\(unwrap(repository.stargazersCount))")
                .font(.system(size: 17))
        }
    }

//    /// String?のアンラップ
//    private func unwrap(_ target: String?) -> String {
//        guard let target = target else {
//            return ""
//        }
//        return target
//    }
//
//    /// Int?のアンラップ
//    private func unwrap(_ target: Int?) -> Int {
//        guard let target = target else {
//            return 0
//        }
//        return target
//    }
}

struct RepositoryCellView_Previews: PreviewProvider {
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
        RepositoryCellView(repository: stubRepo)
    }
}
