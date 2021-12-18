//
//  GitHubClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/18.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class GitHubClient {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()

    func send<Request: GitHubAPIRequest>(
        request: Request,
        completionHandler: @escaping(Result<Request.Response, GitHubClientError>) -> Void
    ) {
        let urlRequest = request.buildURLRequest()
        let task = session.dataTask(with: urlRequest) { data, response, error in

            switch (data, response, error) {
            case (_, _, let error?):
                completionHandler(Result(error: .connectionError(error)))
            case (let data?, let response?, _):
                do {
                    let response = try request.response(from: data, urlRespose: response)
                    completionHandler(Result(value: response))
                } catch let error as GitHubAPIError {
                    completionHandler(Result(error: .apiError(error)))
                } catch {
                    completionHandler(Result(error: .responseParseError(error)))
                }
            default:
                fatalError(
                    "Invalid response combination: \(String(describing: data)), \(String(describing: response)), \(String(describing: error))"
                )
            }
        }

        task.resume()
    }
}
