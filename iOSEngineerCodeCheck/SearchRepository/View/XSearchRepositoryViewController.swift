//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class XSearchRepositoryViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var repositories: [GitHubRepository] = []

    private var presenter: SearchRepositoryPresenterInput!
    /// プレゼンタークラスをDIする
    func inject(presenter: SearchRepositoryPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    /// 初期表示時のデータ準備
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        // xibの登録
        let nibName = ""
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: nibName)
        searchBar.text = "リポジトリ名"
        searchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didTapSearchButton(keyword: searchBar.text)
    }
}

extension XSearchRepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "",
            for: indexPath
        ) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        if let repository = presenter.repository(forRow: indexPath.row) {
            cell.configure(repository: repository)
        }
        return cell
    }
}

extension XSearchRepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapSelectRow(at: indexPath)
    }
}

extension XSearchRepositoryViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter.didTapClearButton()
        }
    }
}

extension XSearchRepositoryViewController: SearchRepositoryPresenterOutput {
    /// リポジトリ一覧のViewを更新
    func updateRepositories(_ repositories: [GitHubRepository]) {
        self.tableView.reloadData()
    }

    /// リポジトリ一覧の取得に失敗した場合にアラートを表示
    func showAPIError() {
        let alert = UIAlertController(
            title: "取得失敗",
            message: "リポジトリ情報の取得に失敗しました。\nもう一度試すか、別のワードで検索してください。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    /// リポジトリ詳細画面へ遷移
    func transitionToRepositoryDetail(repository: GitHubRepository) {
//        guard let repositoryDetailVC = R.storyboard.repositoryDetail.repositoryDetailViewController()
//        else {
//            return
//        }
//
//        let model = RepositoryDetailModel()
//        let presenter = RepositoryDetailPresenter(
//            repository: repository,
//            view: repositoryDetailVC,
//            model: model
//        )
//        repositoryDetailVC.inject(presenter: presenter)
//
//        navigationController?.pushViewController(repositoryDetailVC, animated: true)
    }
}
