//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var languageLabel: UILabel!
    @IBOutlet weak private var starsLabel: UILabel!
    @IBOutlet weak private var watchesLabel: UILabel!
    @IBOutlet weak private var forksLabel: UILabel!
    @IBOutlet weak private var issuesLabel: UILabel!

    var searchRepositoryVC: SearchRepositoryViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        guard let selectedRowIndex = searchRepositoryVC.selectedRowindex else {
            return
        }
        let repo = searchRepositoryVC.repositories[selectedRowIndex]

        languageLabel.text = "Written in \(castToString(repo["language"]))"
        starsLabel.text = "\(castToStringThoughInt(repo["stargazers_count"])) stars"
        watchesLabel.text = "\(castToStringThoughInt(repo["wachers_count"])) watchers"
        forksLabel.text = "\(castToStringThoughInt(repo["forks_count"])) forks"
        issuesLabel.text = "\(castToStringThoughInt(repo["open_issues_count"])) open issues"
        getImage()
    }

    func getImage() {
        guard let selectedRowIndex = searchRepositoryVC.selectedRowindex else {
            return
        }
        let repo = searchRepositoryVC.repositories[selectedRowIndex]

        titleLabel.text = castToString(repo["full_name"])

        guard let owner = repo["owner"] as? [String: Any],
              let imgURL = owner["avatar_url"] as? String
        else {
            return
        }
        URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }

    private func castToString(_ target: Any?) -> String {
        guard let target = target,
              let targetString = target as? String
        else {
            return "-"
        }
        return targetString
    }

    private func castToStringThoughInt(_ target: Any?) -> String {
        guard let target = target,
              let targetInt = target as? Int
        else {
            return "-"
        }
        return String(targetInt)
    }
}
