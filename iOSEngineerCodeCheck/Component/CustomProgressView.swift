//
//  CustomProgressView.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct CustomProgressView: ViewModifier {
    @Binding var isShownProgressView: Bool

    func body(content: Content) -> some View {
        ZStack { content
            if isShownProgressView {
                Color.gray.opacity(0.2)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            }
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            Text("テスト1")
            Text("テスト2")
        }
        .background(Color.yellow)
        .customProgressView(.constant(true))
    }
}
