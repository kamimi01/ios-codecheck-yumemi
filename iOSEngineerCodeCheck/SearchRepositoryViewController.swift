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
    var searchKeyword: String?
    var selectedRowindex: Int?

    private let model = SearchRepositoryModel()

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
        searchKeyword = searchBar.text
        guard let searchKeyword = searchKeyword,
              searchKeyword.count != 0
        else {
            return
        }

        model.fetchRepositories(searchKeyword: searchKeyword) { [weak self] result in
            guard let self = self else { return }
            guard let result = result else {
                // TODO: エラー処理を行う
                return
            }
            self.repositories = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let detailView = segue.destination as? RepositoryDetailViewController
            detailView?.searchRepositoryVC = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowindex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
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
