//
//  Result.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)

    init(value: T) {
        self = .success(value)
    }

    init(error: Error) {
        self = .failure(error)
    }
}
