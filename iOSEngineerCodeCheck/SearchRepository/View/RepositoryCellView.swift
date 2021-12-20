//
//  RepositoryCellView.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryCellView: View {
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
        Image("noImage")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }

    private var repoTitle: some View {
        Text("リポジトリ")
            .font(.system(size: 20, weight: .semibold))
    }

    private var language: some View {
        Text("言語")
            .font(.system(size: 17))
    }

    private var starCount: some View {
        HStack(spacing: 5) {
            Image(systemName: "star")
                .foregroundColor(.gray)
            Text("10")
                .font(.system(size: 17))
        }
    }
}

struct RepositoryCellView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryCellView()
    }
}
