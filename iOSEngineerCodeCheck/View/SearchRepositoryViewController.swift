//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoryViewController: UITableViewController {
    @IBOutlet weak private var searchBar: UISearchBar!

    var repositories: [GitHubRepository] = []
    var task: URLSessionTask?

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
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didTapSearchButton(keyword: searchBar.text)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        if let repository = presenter.repository(forRow: indexPath.row) {
            cell.textLabel?.text = repository.fullName
            cell.detailTextLabel?.text = repository.language
            cell.tag = indexPath.row
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapSelectRow(at: indexPath)
    }
}

extension SearchRepositoryViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
}

extension SearchRepositoryViewController: SearchRepositoryPresenterOutput {
    /// リポジトリ一覧のViewを更新
    func updateRepositories(_ repositories: [GitHubRepository]) {
        self.tableView.reloadData()
    }

    /// リポジトリ詳細画面へ遷移
    func transitionToRepositoryDetail(repository: GitHubRepository) {
        guard let repositoryDetailVC = UIStoryboard(
            name: "GitHubRepository",
            bundle: nil
        )
                .instantiateViewController(
                    withIdentifier: "RepositoryDetailViewController"
                ) as? RepositoryDetailViewController
        else {
            return
        }

        let model = RepositoryDetailModel()
        let presenter = RepositoryDetailPresenter(
            repository: repository,
            view: repositoryDetailVC,
            model: model
        )
        repositoryDetailVC.inject(presenter: presenter)

        navigationController?.pushViewController(repositoryDetailVC, animated: true)
    }
}
