//
//  Configuration.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Configuration {
    static let shared = Configuration()

    var apiHost = ""

    private init() {
        if let apiHost = Bundle.main.object(forInfoDictionaryKey: "APIHost") as? String,
           !apiHost.isEmpty {
            self.apiHost = apiHost
        }
    }
}
