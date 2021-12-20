//
//  OwnerImageView.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI

enum OwnerImageSizeType {
    case big
    case small

    var size: CGFloat {
        switch self {
        case .big: return 200
        case .small: return 50
        }
    }
}

struct OwnerImageView: View {
    var imageSize: OwnerImageSizeType
    var data: Data?

    var body: some View {
        Group {
            if let data = data,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image("noImage")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: imageSize.size, height: imageSize.size)
    }
}

struct OwnerImageView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerImageView(imageSize: .big)
    }
}
