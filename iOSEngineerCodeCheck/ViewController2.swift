//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var languageLabel: UILabel!
    @IBOutlet weak private var starsLabel: UILabel!
    @IBOutlet weak private var watchesLabel: UILabel!
    @IBOutlet weak private var forksLabel: UILabel!
    @IBOutlet weak private var issuesLabel: UILabel!

    var vc1: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let repo = vc1.repo[vc1.idx]

        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchesLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()

    }

    func getImage() {
        let repo = vc1.repo[vc1.idx]

        titleLabel.text = repo["full_name"] as? String

        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.imageView.image = img
                    }
                }.resume()
            }
        }
    }
}
