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

    var repositories: [[String: Any]] = []
    var task: URLSessionTask?
    var searchKeyword: String?
    var selectedRowindex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

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

        // GithubAPIでリポジトリのデータを取得
        let url = "https://api.github.com/search/repositories?q=\(searchKeyword)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] (data, res, err) in
            guard let self = self,
                  let data = data
            else {
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let items = json["items"] as? [[String: Any]]
                else {
                    return
                }
                self.repositories = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                // TODO: エラー処理
            }
        }
        task?.resume()
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
        cell.textLabel?.text = castToString(repository["full_name"])
        cell.detailTextLabel?.text = castToString(repository["language"])
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowindex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }

    private func castToString(_ target: Any?) -> String {
        guard let target = target,
              let targetString = target as? String
        else {
            return "-"
        }
        return targetString
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
