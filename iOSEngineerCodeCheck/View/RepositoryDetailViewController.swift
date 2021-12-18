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

    weak var searchRepositoryVC: SearchRepositoryViewController?
    private let model = RepositoryDetailModel()
    private var presenter: RepositoryDetailPresenterInput!
    /// プレゼンタークラスをDIする
    func inject(presenter: RepositoryDetailPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    /// 初期表示時のデータ準備
    private func setup() {
        guard let searchRepositoryVC = searchRepositoryVC,
              let selectedRowIndex = searchRepositoryVC.selectedRowindex
        else {
            return
        }
        let repo = searchRepositoryVC.repositories[selectedRowIndex]

        languageLabel.text = "Written in \(unwrap(repo.language))"
        starsLabel.text = "\(unwrap(repo.stargazersCount)) stars"
        watchesLabel.text = "\(unwrap(repo.watchersCount)) watchers"
        forksLabel.text = "\(unwrap(repo.forksCount)) forks"
        issuesLabel.text = "\(unwrap(repo.openIssuesCount)) open issues"
        getImage()
    }

    /// リポジトリ所有者の画像取得
    func getImage() {
        guard let searchRepositoryVC = searchRepositoryVC,
              let selectedRowIndex = searchRepositoryVC.selectedRowindex
        else {
            return
        }
        let repo = searchRepositoryVC.repositories[selectedRowIndex]

        titleLabel.text = repo.fullName

        guard let imgURL = repo.owner.avatarURL
        else {
            return
        }

        model.getImage(imageURL: imgURL) { [weak self] result in
            guard let self = self,
                  let result = result,
                  let uiImage = UIImage(data: result)
            else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = uiImage
            }
        }
    }

    /// String?のアンラップ
    private func unwrap(_ target: String?) -> String {
        guard let target = target else {
            return "-"
        }
        return target
    }

    /// Int?のアンラップ
    private func unwrap(_ target: Int?) -> Int {
        guard let target = target else {
            return 0
        }
        return target
    }
}
