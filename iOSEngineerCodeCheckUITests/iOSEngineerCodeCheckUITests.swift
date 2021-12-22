//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class SearchRepositoryPage {
    static let repoTitleID = "RepositoryTableViewCell_repoTitle"
    static let languageID = "RepositoryTableViewCell_language"
}

class RepositoryDetailPage {
    static let repoTitleID = "RepositoryDetailViewController_title"
    static let languageID = "RepositoryDetailViewController_language"
    static let watchersCountID = "RepositoryDetailViewController_watcherscount"
    static let forksCountID = "RepositoryDetailViewController_forkscount"
    static let issuesCountID = "RepositoryDetailViewController_issuescount"
}

class IOSEngineerCodeCheckUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
    }

    func testSearchRepository() throws {
        XCTContext.runActivity(named: "リポジトリ検索画面が表示される") { _ in
            let searchField = app.searchFields.element
            XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        }

        XCTContext.runActivity(named: "リポジトリの検索を行い、リポジトリ一覧が表示される") { _ in
            // 検索バーのUI要素を特定する
            let searchField = app.searchFields.element
            searchField.tap()
            // 検索バーに文字列を入力する
            searchField.typeText("swift")
            // エンターを押下する
            app.buttons["Search"].tap()
            // セルのUI要素を特定する
            let repoTitleLabel = app.tables.cells.containing(.staticText, identifier: SearchRepositoryPage.repoTitleID).element(boundBy: 0)
            let languageLabel = app.tables.cells.containing(.staticText, identifier: SearchRepositoryPage.languageID).element(boundBy: 0)

            XCTAssertTrue(repoTitleLabel.waitForExistence(timeout: 3))
            XCTAssertTrue(repoTitleLabel.staticTexts.count != 0)
            XCTAssertTrue(languageLabel.waitForExistence(timeout: 3))
        }

        XCTContext.runActivity(named: "リポジトリの詳細情報が表示される") { _ in
            // リポジトリ詳細画面へ遷移
            app.tables.cells.element(boundBy: 0).tap()
            // リポジトリ詳細画面のUI要素を取得
            let image = app.images.element
            let repoTitle = app.staticTexts[RepositoryDetailPage.repoTitleID]
            let language = app.staticTexts[RepositoryDetailPage.languageID]
            let watchersCount = app.staticTexts[RepositoryDetailPage.watchersCountID]
            let forksCount = app.staticTexts[RepositoryDetailPage.forksCountID]
            let issuesCount = app.staticTexts[RepositoryDetailPage.issuesCountID]

            XCTAssertTrue(image.waitForExistence(timeout: 3))
            XCTAssertTrue(repoTitle.waitForExistence(timeout: 3))
            XCTAssertTrue(language.waitForExistence(timeout: 3))
            XCTAssertTrue(watchersCount.waitForExistence(timeout: 3))
            XCTAssertTrue(forksCount.waitForExistence(timeout: 3))
            XCTAssertTrue(issuesCount.waitForExistence(timeout: 3))
        }
    }
}
