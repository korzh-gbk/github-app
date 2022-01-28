//
//  RepoListModel.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation

struct RepoListModel: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepoListItemModel]

    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }
}


struct RepoListItemModel: Codable, Identifiable, Hashable {
    let id: UInt
    let name: String
    let repoDescription: String?
    let owner: RepoOwnerModel
    let language: String?
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let starsCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, language, owner
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case repoDescription = "description"
        case starsCount = "stargazers_count"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: RepoListItemModel, rhs: RepoListItemModel) -> Bool {
        lhs.id == rhs.id
    }

}

