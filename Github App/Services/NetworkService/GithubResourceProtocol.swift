//
//  GithubResourceProtocol.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation
import Combine

enum GithubSort: String, Equatable, CaseIterable {
    case stars
    case forks
    case updated
}

protocol GithubResourceProtocol {
    func search(query: String, sort: GithubSort) -> AnyPublisher<RepoListModel, Error>
    func repoDetails(data: RepoData) -> AnyPublisher<RepoModel, Error>
    func contributor(login: String) -> AnyPublisher<ContributorModel, Error>
}
