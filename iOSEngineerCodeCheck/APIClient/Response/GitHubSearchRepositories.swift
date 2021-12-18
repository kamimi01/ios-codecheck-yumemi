//
//  GitHubSearchRepositories.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubSearchRepositories: Decodable {
    let items: [GitHubRepository]

    enum CodingKeys: String, CodingKey {
        case items
    }
}
