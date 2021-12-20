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
        VStack(spacing: 10) {
            Image(uiImage: UIImage())
                .border(.yellow)
            HStack(spacing: 60) {
                VStack {
                    Text("リポジトリ名")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("stars")
                    Text("watchers")
                    Text("forks")
                    Text("issues")
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .border(.red)
        }
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailView()
    }
}
