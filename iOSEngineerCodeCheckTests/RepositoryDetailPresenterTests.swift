//
//  RepositoryDetailPresenterTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Mika Urakawa on 2021/12/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class RepositoryDetailPresenterOutputSpy: RepositoryDetailPresenterOutput {
    private(set) var countOfInvokingGetImage: Int = 0

    var getImageWithData: ((Data?) -> Void)?

    func getImage(data: Data?) {
        countOfInvokingGetImage += 1
        getImageWithData?(data)
    }
}

class RepositoryDetailModelInputStub: RepositoryDetailModelInput {
    private var fetchImageResponse: [String: Data?] = [:]

    /// 画像データのスタブデータを保存しておく
    func addFetchImageResponse(
        data: Data?,
        imageURL url: String
    ) {
        fetchImageResponse[url] = data
    }

    func getImage(imageURL: String, completionHandler: @escaping (Data?) -> Void) {
        guard let response = fetchImageResponse[imageURL]
        else {
            completionHandler(nil)
            return
        }
        completionHandler(response)
    }
}

class RepositoryDetailPresenterTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testViewDidLoad() throws {
        XCTContext.runActivity(named: "リポジトリ詳細画面表示時処理") { _ in
            XCTContext.runActivity(named: "画像取得成功時にView更新処理が呼ばれること") { _ in
                let spy = RepositoryDetailPresenterOutputSpy()
                let stub = RepositoryDetailModelInputStub()
                let repository = GitHubRepository.mock()
                let presenter = RepositoryDetailPresenter(
                    repository: repository,
                    view: spy,
                    model: stub
                )
                let imageData = Data()
                let imageURL = "https://example.com"
                stub.addFetchImageResponse(data: imageData, imageURL: imageURL)
                let exp = XCTestExpectation(description: "viewDidLoad内部処理で呼ばれるgetImageの実行を待つ")

                // テスト用のスパイメソッドのため、repositoriesは使用されていないが、実際は使用される
                // swiftlint:disable unused_closure_parameter
                spy.getImageWithData = { imageData in
                    exp.fulfill()
                }

                let fullName = "kamimi01/ios-codecheck-yumemi"
                XCTAssertTrue(presenter.repository.fullName == fullName)
                presenter.viewDidLoad()
                wait(for: [exp], timeout: 1)

                XCTAssertTrue(spy.countOfInvokingGetImage == 1)
            }

            XCTContext.runActivity(named: "画像URLが存在しない場合でも画像取得処理が呼ばれること") { _ in
                let spy = RepositoryDetailPresenterOutputSpy()
                let stub = RepositoryDetailModelInputStub()
                let repository = GitHubRepository.mockNoImage()
                let presenter = RepositoryDetailPresenter(
                    repository: repository,
                    view: spy,
                    model: stub
                )

                let exp = XCTestExpectation(description: "viewDidLoad内部処理で呼ばれるgetImageの実行を待つ")

                // テスト用のスパイメソッドのため、repositoriesは使用されていないが、実際は使用される
                // swiftlint:disable unused_closure_parameter
                spy.getImageWithData = { imageData in
                    exp.fulfill()
                }

                XCTAssertTrue(spy.countOfInvokingGetImage == 0)
                presenter.viewDidLoad()
                wait(for: [exp], timeout: 1)
                XCTAssertTrue(spy.countOfInvokingGetImage == 1)
            }

            XCTContext.runActivity(named: "画像取得が失敗した場合でもView更新処理が呼ばれること") { _ in
                let spy = RepositoryDetailPresenterOutputSpy()
                let stub = RepositoryDetailModelInputStub()
                let repository = GitHubRepository.mock()
                let presenter = RepositoryDetailPresenter(
                    repository: repository,
                    view: spy,
                    model: stub
                )
                let imageURL = "https://example.com"
                stub.addFetchImageResponse(data: nil, imageURL: imageURL)
                let exp = XCTestExpectation(description: "viewDidLoad内部処理で呼ばれるgetImageの実行を待つ")

                // テスト用のスパイメソッドのため、repositoriesは使用されていないが、実際は使用される
                // swiftlint:disable unused_closure_parameter
                spy.getImageWithData = { imageData in
                    exp.fulfill()
                }

                XCTAssertTrue(spy.countOfInvokingGetImage == 0)
                presenter.viewDidLoad()
                wait(for: [exp], timeout: 1)
                XCTAssertTrue(spy.countOfInvokingGetImage == 1)
            }
        }
    }

}
