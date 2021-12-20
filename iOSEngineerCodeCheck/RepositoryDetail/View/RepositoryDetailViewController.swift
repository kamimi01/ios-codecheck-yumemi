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

    weak var searchRepositoryVC: XSearchRepositoryViewController?
    private let model = RepositoryDetailModel()
    private var presenter: RepositoryDetailPresenterInput!
    /// プレゼンタークラスをDIする
    func inject(presenter: RepositoryDetailPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    /// 初期表示時のデータ準備
    private func setup() {
        let repository = presenter.repository

        titleLabel.text = repository.fullName
        languageLabel.text = "Written in \(unwrap(repository.language))"
        starsLabel.text = "\(unwrap(repository.stargazersCount)) stars"
        watchesLabel.text = "\(unwrap(repository.watchersCount)) watchers"
        forksLabel.text = "\(unwrap(repository.forksCount)) forks"
        issuesLabel.text = "\(unwrap(repository.openIssuesCount)) open issues"
    }
}

extension RepositoryDetailViewController {
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

extension RepositoryDetailViewController: RepositoryDetailPresenterOutput {
    /// レポジトリ所有者の画像取得
    func getImage(data: Data?) {
        var uiImage: UIImage? {
            // 画像データが取得できなかった場合は、noImageの画像を表示
            guard let data = data,
                  let uiImage = UIImage(data: data)
            else {
                guard let noImage = UIImage(named: R.image.noImage.name)
                else {
                    return nil
                }
                return noImage
            }
            return uiImage
        }

        guard let uiImage = uiImage else {
            return
        }
        self.imageView.image = uiImage
    }
}
