//
//  RepositoryDetailModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryDetailModelInput {
    func getImage(
        imageURL: String,
        completionHandler: @escaping(Data?) -> Void
    )
}

final class RepositoryDetailModel: RepositoryDetailModelInput {
    /// 画像取得
    func getImage(
        imageURL: String,
        completionHandler: @escaping(Data?) -> Void
    ) {
        guard let url = URL(string: imageURL) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
}
