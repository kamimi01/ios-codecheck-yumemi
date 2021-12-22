//
//  View+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

extension View {
    /// String?のアンラップ
    func unwrap(_ target: String?) -> String {
        guard let target = target else {
            return ""
        }
        return target
    }

    /// Int?のアンラップ
    func unwrap(_ target: Int?) -> Int {
        guard let target = target else {
            return 0
        }
        return target
    }

    func customProgressView(_ isShownProgressView: Binding<Bool>) -> some View {
        self.modifier(CustomProgressView(isShownProgressView: isShownProgressView))
    }
}
