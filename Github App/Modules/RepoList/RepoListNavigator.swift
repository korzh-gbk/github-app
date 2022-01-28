//
//  RepoListNavigator.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation
import UIKit

struct RepoListNavigator {
    let navigationController: UINavigationController

    public func openRepoList() {
        let githubResource = ServiceProvider.shared.resolve(serviceType: GithubResourceProtocol.self)!
        let viewModel = RepoListViewModel(githubResource: githubResource)
        let controller = RepoListViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}
