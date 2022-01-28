//
//  NetworkService+GithubResource.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation
import Combine

extension NetworkService: GithubResourceProtocol {

    enum Endpoint {
        case repoSearch
        case repoDetails(owner: String, repo: String)
        case contributorDetails(user: String)

        var url: URL {
            switch self {
            case .repoSearch:
                return URL(string: "https://api.github.com/search/repositories")!
            case .repoDetails(let owner, let repo):
                return URL(string: "https://api.github.com/repos/\(owner)/\(repo)")!
            case .contributorDetails(let user):
                return URL(string: "https://api.github.com/users/\(user)")!
            }
        }
    }

    // MARK: Requests

    func search(query: String, sort: GithubSort) -> AnyPublisher<RepoListModel, Error> {
        let request = NetworkRequest(
            endpoint: Endpoint.repoSearch.url,
            query: ["q": query, "sort": sort.rawValue]
        )
        return make(request: request)
    }

    func repoDetails(data: RepoData) -> AnyPublisher<RepoModel, Error> {
        let request = NetworkRequest(endpoint: Endpoint.repoDetails(owner: data.ownerName, repo: data.name).url)
        return make(request: request)
    }

    func contributor(login: String) -> AnyPublisher<ContributorModel, Error> {
        let request = NetworkRequest(endpoint: Endpoint.contributorDetails(user: login).url)
        return make(request: request)
    }
    
}
