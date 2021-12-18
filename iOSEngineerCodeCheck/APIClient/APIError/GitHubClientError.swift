//
//  GitHubClientError.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum GitHubClientError: Error {
    // 通信に失敗
    case connectionError(Error)
    // レスポンスのパースに失敗
    case responseParseError(Error)
    // APIからエラーレスポンスを受け取った
    case apiError(GitHubAPIError)
}
