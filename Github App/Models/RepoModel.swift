//
//  RepoModel.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import Foundation

struct RepoModel: Codable {
    let name: String
    let owner: RepoOwnerModel
    let repoDescription: String?
    let htmlURL: URL
    let homepageURL: URL?
    let language: String?
    let createdAt: Date
    let updatedAt: Date
    let subscribersCount: Int
    let forksCount: Int
    let starsCount: Int
    let openIssuesCount: Int


    enum CodingKeys: String, CodingKey {
        case name, owner, language
        case repoDescription = "description"
        case htmlURL = "html_url"
        case homepageURL = "homepage"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case subscribersCount = "subscribers_count"
        case forksCount = "forks_count"
        case starsCount = "stargazers_count"
        case openIssuesCount = "open_issues_count"
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(.name)
        owner = try container.decode(.owner)
        repoDescription = try container.decode(.repoDescription)
        htmlURL = try container.decode(.htmlURL)
        do {
            homepageURL = try container.decode(.homepageURL)
        } catch {
            homepageURL = nil
        }
        language = try container.decode(.language)
        createdAt = try container.decode(.createdAt)
        updatedAt = try container.decode(.updatedAt)
        subscribersCount = try container.decode(.subscribersCount)
        forksCount = try container.decode(.forksCount)
        starsCount = try container.decode(.starsCount)
        openIssuesCount = try container.decode(.openIssuesCount)
    }
}
