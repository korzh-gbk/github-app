//
//  RepoDetailsNavigator.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import UIKit

struct RepoDetailsNavigator {
    let navigationController: UINavigationController

    public func openRepoDetails(repoData: RepoData) {
        let githubResource = ServiceProvider.shared.resolve(serviceType: GithubResourceProtocol.self)!
        let viewModel = RepoDetailsViewModel(repoData: repoData, githubResource: githubResource)
        let controller = RepoDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

