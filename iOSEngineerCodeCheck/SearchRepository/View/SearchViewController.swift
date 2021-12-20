//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/20.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import SwiftUI

class SearchViewController: UIHostingController<RepositoryDetailView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: RepositoryDetailView());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
