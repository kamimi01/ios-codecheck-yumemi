//
//  RepositoryDetail.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryDetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            image
            repoTitle
            starCount
            repoDesctiption
            countDetail
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarTitle("詳細", displayMode: .inline)
    }
}

extension RepositoryDetailView {
    private var image: some View {
        Image("noImage")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
    }

    private var repoTitle: some View {
        Text("リポジトリ名")
            .font(.system(size: 25))
    }

    private var starCount: some View {
        HStack {
            Image(systemName: "star")
                .foregroundColor(.gray)
            Text("10")
                .font(.system(size: 17))
        }
    }

    private var repoDesctiption: some View {
        Text("説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明説明")
            .font(.system(size: 17))
    }

    private var countDetail: some View {
        HStack {
            VStack {
                Text("10")
                Text("watchers")
            }
            Spacer()
            VStack {
                Text("10")
                Text("forks")
            }
            Spacer()
            VStack {
                Text("10")
                Text("issues")
            }
        }
        .padding(.horizontal, 20)
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailView()
    }
}
