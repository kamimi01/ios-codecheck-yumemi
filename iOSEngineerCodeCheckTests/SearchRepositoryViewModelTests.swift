//
//  SearchRepositoryViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Mika Urakawa on 2021/12/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class SearchRepositoryModelInputSpy: SearchRepositoryModelInput {
    private(set) var countOfInvokingCancel: Int = 0
    private(set) var countOfInvokingFetchRepositories: Int = 0

    var fetchRepositoriesWithKeyword: ((String) -> Void)?
    var cancelWithNothing: (() -> Void)?

    // FIXME: spyメソッドにするのではなくstubメソッドとして実装したかった
    /// - seealso: https://github.com/kamimi01/ios-codecheck-yumemi/issues/25
    func fetchRepositories(searchKeyword: String, completionHandler: @escaping (Result<[GitHubRepository], GitHubClientError>) -> Void) {
        countOfInvokingFetchRepositories += 1
        fetchRepositoriesWithKeyword?(searchKeyword)
    }

    func cancel() {
        countOfInvokingCancel += 1
        cancelWithNothing?()
    }

    func getImage(imageURL: String, completionHandler: @escaping (Data?) -> Void) {
        // do nothing
    }
}

class SearchRepositoryViewModelTests: XCTestCase {
    var viewModel: SearchRepositoryViewModel!
    var spy: SearchRepositoryModelInputSpy!

    override func setUp() {
        spy = SearchRepositoryModelInputSpy()
        viewModel = .init(model: spy)
    }

    override func tearDown() {
    }

    func testDidTapSearchButton() throws {
        XCTContext.runActivity(named: "検索バーが押下時処理") { _ in
            XCTContext.runActivity(named: "リポジトリ検索成功時にView更新処理が呼ばれること") { _ in
                let searchKeyword = "swift"
                viewModel.keyword = searchKeyword
                let repositories = [GitHubRepository.mock()]
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるfetchRepositoriesの実行を待つ")
                // テスト用のスパイメソッドのため、repositoriesは使用されていないが、実際は使用される
                // swiftlint:disable unused_closure_parameter
                spy.fetchRepositoriesWithKeyword = { repositories in
                    exp.fulfill()
                }

                XCTAssertTrue(spy.countOfInvokingFetchRepositories == 0)
                viewModel.didTapSearchButton()
                wait(for: [exp], timeout: 5)
                XCTAssertTrue(spy.countOfInvokingFetchRepositories == 1)
            }
        }
    }

    func testDidTapClearButton() {
        XCTContext.runActivity(named: "クリアボタン押下時処理") { _ in
            XCTContext.runActivity(named: "タスクのキャンセル処理が呼ばれること") { _ in
                let exp = XCTestExpectation(description: "didClearButton内部で呼ばれるcancelの実行を待つ")
                spy.cancelWithNothing = {
                    exp.fulfill()
                }

                XCTAssertTrue(spy.countOfInvokingCancel == 0)
                viewModel.didTapClearButton()
                wait(for: [exp], timeout: 1)
                XCTAssertTrue(spy.countOfInvokingCancel == 1)
            }
        }
    }

    func testDidTapOrderButton() {
        XCTContext.runActivity(named: "ソートボタン押下時処理") { _ in
            XCTContext.runActivity(named: "Star数でソートされること") { _ in
                viewModel.repositories = GitHubRepository.mockForSort()

                viewModel.didTapOrderButton(.star)

                XCTAssertTrue(viewModel.repositories.first?.fullName == "starSort")
                XCTAssertTrue(viewModel.repositories.last?.fullName == "forkSort")
            }

            XCTContext.runActivity(named: "Watcher数でソートされること") { _ in
                viewModel.repositories = GitHubRepository.mockForSort()

                viewModel.didTapOrderButton(.watcher)

                XCTAssertTrue(viewModel.repositories.first?.fullName == "watcherSort")
                XCTAssertTrue(viewModel.repositories.last?.fullName == "starSort")
            }

            XCTContext.runActivity(named: "Forks数でソートされること") { _ in
                viewModel.repositories = GitHubRepository.mockForSort()

                viewModel.didTapOrderButton(.fork)

                XCTAssertTrue(viewModel.repositories.first?.fullName == "forkSort")
                XCTAssertTrue(viewModel.repositories.last?.fullName == "starSort")
            }

            XCTContext.runActivity(named: "Issues数でソートされること") { _ in
                viewModel.repositories = GitHubRepository.mockForSort()

                viewModel.didTapOrderButton(.issue)

                XCTAssertTrue(viewModel.repositories.first?.fullName == "issueSort")
                XCTAssertTrue(viewModel.repositories.last?.fullName == "watcherSort")
            }
        }
    }
}
