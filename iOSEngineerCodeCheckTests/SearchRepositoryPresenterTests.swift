//
//  SearchRepositoryPresenterTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Mika Urakawa on 2021/12/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class SearchRepositoryPresenterOutputSpy: SearchRepositoryPresenterOutput {
    private(set) var countOfInvokingUpdateRepositories: Int = 0
    private(set) var countOfInvokingTransitionToRepositoryDetail: Int = 0
    private(set) var countOfInvokingShowAPIError: Int = 0

    var updateRepositoriesCalledWithRepositories: (([GitHubRepository]) -> Void)?
    var transitionToRepositoryDetailCalledWithRepository: ((GitHubRepository) -> Void)?
    var showAPIErrorCalledWithNothing: (() -> Void)?

    func updateRepositories(_ repositories: [GitHubRepository]) {
        countOfInvokingUpdateRepositories += 1
        updateRepositoriesCalledWithRepositories?(repositories)
    }

    func transitionToRepositoryDetail(repository: GitHubRepository) {
        countOfInvokingTransitionToRepositoryDetail += 1
        transitionToRepositoryDetailCalledWithRepository?(repository)
    }

    func showAPIError() {
        countOfInvokingShowAPIError += 1
        showAPIErrorCalledWithNothing?()
    }
}

class SearchRepositoryModelInputStub: SearchRepositoryModelInput {
    private var fetchRepositoriesResponse: [String: Result<[GitHubRepository], GitHubClientError>] = [:]
    private(set) var countOfInvokingCancel: Int = 0

    var cancelWithNothing: (() -> Void)?

    /// リポジトリのスタブデータを保存しておく
    func addFetchRepositoryResponse(
        _ result: Result<[GitHubRepository], GitHubClientError>,
        whenQuery searchKeyword: String
    ) {
       fetchRepositoriesResponse[searchKeyword] = result
    }

    func fetchRepositories(searchKeyword: String, completionHandler: @escaping (Result<[GitHubRepository], GitHubClientError>) -> Void) {
        guard let response = fetchRepositoriesResponse[searchKeyword]
        else {
            fatalError("fetchRepositoriesResponse not found when searchKeyword is \(searchKeyword)")
        }
        completionHandler(response)
    }

    func cancel() {
        countOfInvokingCancel += 1
        cancelWithNothing?()
    }
}

class SearchRepositoryPresenterTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testDidTapSearchButton() throws {
        XCTContext.runActivity(named: "検索バーが押下時処理") { _ in
            XCTContext.runActivity(named: "リポジトリ検索成功時にView更新処理が呼ばれること") { _ in
                let spy = SearchRepositoryPresenterOutputSpy()
                let stub = SearchRepositoryModelInputStub()
                let presenter = SearchRepositoryPresenter(view: spy, model: stub)
                let searchKeyword = "swift"
                let repositories = [GitHubRepository.mock()]
                stub.addFetchRepositoryResponse(.success(repositories), whenQuery: searchKeyword)
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるupdateRepositoriesの実行を待つ")
                // テスト用のスパイメソッドのため、repositoriesは使用されていないが、実際は使用される
                // swiftlint:disable unused_closure_parameter
                spy.updateRepositoriesCalledWithRepositories = { repositories in
                    exp.fulfill()
                }

                presenter.didTapSearchButton(keyword: searchKeyword)
                wait(for: [exp], timeout: 1)

                XCTAssertTrue(presenter.numberOfRepositories == 1)
                XCTAssertTrue(spy.countOfInvokingUpdateRepositories == 1)
            }

            XCTContext.runActivity(named: "リポジトリ検索失敗時はView更新処理が呼ばれないこと") { _ in
                let spy = SearchRepositoryPresenterOutputSpy()
                let stub = SearchRepositoryModelInputStub()
                let presenter = SearchRepositoryPresenter(view: spy, model: stub)
                let searchKeyword = "swift"
                let error = GitHubClientError.noData
                stub.addFetchRepositoryResponse(.failure(error), whenQuery: searchKeyword)
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるshowAPIErrorの実行を待つ")

                spy.showAPIErrorCalledWithNothing = {
                    exp.fulfill()
                }

                presenter.didTapSearchButton(keyword: searchKeyword)
                wait(for: [exp], timeout: 1)

                XCTAssertTrue(presenter.numberOfRepositories == 0)
                XCTAssertTrue(spy.countOfInvokingUpdateRepositories == 0)
                XCTAssertTrue(spy.countOfInvokingShowAPIError == 1)
            }

            XCTContext.runActivity(named: "キーワードが空でリポジトリ検索された場合はView更新処理が呼ばれないこと") { _ in
                let spy = SearchRepositoryPresenterOutputSpy()
                let stub = SearchRepositoryModelInputStub()
                let presenter = SearchRepositoryPresenter(view: spy, model: stub)
                let searchKeyword = ""
                let error = GitHubClientError.noData
                stub.addFetchRepositoryResponse(.failure(error), whenQuery: searchKeyword)

                presenter.didTapSearchButton(keyword: searchKeyword)

                XCTAssertTrue(presenter.numberOfRepositories == 0)
                XCTAssertTrue(spy.countOfInvokingUpdateRepositories == 0)
            }
        }
    }

    func testDidTapSelectRow() {
        XCTContext.runActivity(named: "セル押下時の処理") { _ in
            XCTContext.runActivity(named: "成功時にリポジトリ詳細画面への遷移処理が呼ばれること") { _ in
                let spy = SearchRepositoryPresenterOutputSpy()
                let stub = SearchRepositoryModelInputStub()
                let preseter = SearchRepositoryPresenter(view: spy, model: stub)
                let searchKeyword = "swift"
                let repositories = [GitHubRepository.mock()]
                stub.addFetchRepositoryResponse(.success(repositories), whenQuery: searchKeyword)
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるupdateRepositoeisの実行を待つ")
                spy.updateRepositoriesCalledWithRepositories = { repositories in
                    exp.fulfill()
                }

                preseter.didTapSearchButton(keyword: searchKeyword)
                wait(for: [exp], timeout: 1)

                XCTAssertTrue(spy.countOfInvokingTransitionToRepositoryDetail == 0)
                preseter.didTapSelectRow(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToRepositoryDetail == 1)
            }

            XCTContext.runActivity(named: "失敗時にリポジトリ詳細画面への遷移処理が呼ばれないこと") { _ in
                let spy = SearchRepositoryPresenterOutputSpy()
                let stub = SearchRepositoryModelInputStub()
                let presenter = SearchRepositoryPresenter(view: spy, model: stub)
                let searchKeyword = "swift"
                let error = GitHubClientError.noData
                stub.addFetchRepositoryResponse(.failure(error), whenQuery: searchKeyword)
                let exp = XCTestExpectation(description: "didTapSearchButton内部で呼ばれるshowAPIErrorの実行を待つ")

                spy.showAPIErrorCalledWithNothing = {
                    exp.fulfill()
                }

                presenter.didTapSearchButton(keyword: searchKeyword)
                wait(for: [exp], timeout: 1)

                XCTAssertTrue(spy.countOfInvokingTransitionToRepositoryDetail == 0)
                presenter.didTapSelectRow(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToRepositoryDetail == 0)
            }
        }
    }

    func testDidTapClearButton() {
        XCTContext.runActivity(named: "クリアボタン押下時処理") { _ in
            XCTContext.runActivity(named: "タスクのキャンセル処理が呼ばれること") { _ in
                let spy = SearchRepositoryPresenterOutputSpy()
                let stub = SearchRepositoryModelInputStub()
                let presenter = SearchRepositoryPresenter(view: spy, model: stub)
                let exp = XCTestExpectation(description: "didClearButton内部で呼ばれるcancelの実行を待つ")
                stub.cancelWithNothing = {
                    exp.fulfill()
                }

                XCTAssertTrue(stub.countOfInvokingCancel == 0)
                presenter.didTapClearButton()
                wait(for: [exp], timeout: 1)
                XCTAssertTrue(stub.countOfInvokingCancel == 1)
            }
        }
    }
}
