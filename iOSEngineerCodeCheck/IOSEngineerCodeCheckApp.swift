//
//  IOSEngineerCodeCheckApp.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

@main
struct IOSEngineerCodeCheckApp: App {
    var body: some Scene {
        WindowGroup {
            SearchRepositoryView(viewModel: SearchRepositoryViewModel())
        }
    }
}
