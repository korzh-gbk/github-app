//
//  ContributorModel.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import Foundation

struct ContributorModel: Codable {
    let login: String
    let avatarURL: URL?
    let name: String?
    let htmlURL: URL
    let company: String?
    let blogURL: URL?
    let location: String?
    let email: String?
    let bio: String?
    let repoCount: Int
    let gistsCount: Int
    let followersCount: Int
    let followingCount: Int

    enum CodingKeys: String, CodingKey {
        case login, name, company, location, email, bio
        case htmlURL = "html_url"
        case avatarURL = "avatar_url"
        case blogURL = "blog"
        case repoCount = "public_repos"
        case gistsCount = "public_gists"
        case followersCount = "followers"
        case followingCount = "following"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decode(.login)
        avatarURL = try container.decode(.avatarURL)
        name = try container.decode(.name)
        htmlURL = try container.decode(.htmlURL)
        company = try container.decode(.company)
        do {
            blogURL = try container.decode(.blogURL)
        } catch {
            blogURL = nil
        }
        location = try container.decode(.location)
        email = try container.decode(.email)
        bio = try container.decode(.bio)
        repoCount = try container.decode(.repoCount)
        gistsCount = try container.decode(.gistsCount)
        followersCount = try container.decode(.followersCount)
        followingCount = try container.decode(.followingCount)
    }
}
