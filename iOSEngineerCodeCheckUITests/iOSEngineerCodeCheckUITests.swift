//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class SeachRepositoryPage {
    static let sortButtonID = "SeachRepositoryView_sortButton"
}

class RepositoryCellPage {
    static let repoTitleID = "RepositoryCellView_repoTitle"
    static let languageID = "RepositoryCellView_language"
    static let starCountID = "RepositoryCellView_starcount"
}

class RepositoryDetailPage {
    static let repoTitleID = "RepositoryDetailView_title"
    static let starCountID = "RepositoryDetailView_starcount"
    static let descriptionID = "RepositoryDetailView_description"
    static let watchersCountID = "RepositoryDetailView_watcherscount"
    static let forksCountID = "RepositoryDetailView_forkscount"
    static let issuesCountID = "RepositoryDetailView_issuescount"
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
            let image = app.images.element
            let repoTitleLabel = app.tables.cells.containing(.staticText, identifier: RepositoryCellPage.repoTitleID).element(boundBy: 0)
            let languageLabel = app.tables.cells.containing(.staticText, identifier: RepositoryCellPage.languageID).element(boundBy: 0)
            let starCount = app.staticTexts[RepositoryCellPage.starCountID]

            XCTAssertTrue(image.waitForExistence(timeout: 3))
            XCTAssertTrue(repoTitleLabel.waitForExistence(timeout: 3))
            XCTAssertTrue(repoTitleLabel.staticTexts.count != 0)
            XCTAssertTrue(languageLabel.waitForExistence(timeout: 3))
            XCTAssertTrue(starCount.waitForExistence(timeout: 3))
        }

        XCTContext.runActivity(named: "リポジトリの詳細情報が表示される") { _ in
            // リポジトリ詳細画面へ遷移
            app.tables.cells.element(boundBy: 0).tap()
            // リポジトリ詳細画面のUI要素を取得
            let image = app.images.element
            let repoTitle = app.staticTexts[RepositoryDetailPage.repoTitleID]
            let starCount = app.staticTexts[RepositoryDetailPage.starCountID]
            let description = app.staticTexts[RepositoryDetailPage.descriptionID]
            let watchersCount = app.staticTexts[RepositoryDetailPage.watchersCountID]
            let forksCount = app.staticTexts[RepositoryDetailPage.forksCountID]
            let issuesCount = app.staticTexts[RepositoryDetailPage.issuesCountID]

            XCTAssertTrue(image.waitForExistence(timeout: 3))
            XCTAssertTrue(repoTitle.waitForExistence(timeout: 3))
            XCTAssertTrue(starCount.waitForExistence(timeout: 3))
            XCTAssertTrue(description.waitForExistence(timeout: 3))
            XCTAssertTrue(watchersCount.waitForExistence(timeout: 3))
            XCTAssertTrue(forksCount.waitForExistence(timeout: 3))
            XCTAssertTrue(issuesCount.waitForExistence(timeout: 3))
        }
    }

    func testSortRepositories() {
        XCTContext.runActivity(named: "ソートボタンを押下し、アクションシートが表示される。ボタンを押下するとリポジトリ一覧が再度表示される") { _ in
            // 検索バーのUI要素を特定する
            let searchField = app.searchFields.element
            searchField.tap()
            // 検索バーに文字列を入力する
            searchField.typeText("swift")
            // エンターを押下する
            app.buttons["Search"].tap()
            // ソートボタンを押下する
            let sortButton = app.buttons[SeachRepositoryPage.sortButtonID]
            sortButton.tap()
            // アクションシートのボタンを押下する
            let sortOptionButton = app.buttons["forks"]
            sortOptionButton.tap()

            let image = app.images.element
            let repoTitleLabel = app.tables.cells.containing(.staticText, identifier: RepositoryCellPage.repoTitleID).element(boundBy: 0)
            let languageLabel = app.tables.cells.containing(.staticText, identifier: RepositoryCellPage.languageID).element(boundBy: 0)
            let starCount = app.staticTexts[RepositoryCellPage.starCountID]

            XCTAssertTrue(image.waitForExistence(timeout: 3))
            XCTAssertTrue(repoTitleLabel.waitForExistence(timeout: 3))
            XCTAssertTrue(repoTitleLabel.staticTexts.count != 0)
            XCTAssertTrue(languageLabel.waitForExistence(timeout: 3))
            XCTAssertTrue(starCount.waitForExistence(timeout: 3))
        }
    }
}
