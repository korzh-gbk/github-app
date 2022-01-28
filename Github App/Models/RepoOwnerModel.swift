//
//  RepoOwnerModel.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import Foundation

struct RepoOwnerModel: Codable {
    let login: String
    let avatarURL: URL?
    let gravatarId: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case gravatarId = "gravatar_id"
    }
}
