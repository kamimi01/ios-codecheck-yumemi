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
    var searchKeyword: String!
    var url: String!
    var selectedRowindex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchKeyword = searchBar.text!

        if searchKeyword.count == 0 {
            return
        }

        // GithubAPIでリポジトリのデータを取得
        url = "https://api.github.com/search/repositories?q=\(searchKeyword!)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any],
                      let items = json["items"] as? [[String: Any]] else {
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
            let dtl = segue.destination as? RepositoryDetailViewController
            dtl?.searchRepositoryVC = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
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
