//
//  ContributorDetailsNavigator.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import UIKit

struct ContributorDetailsNavigator {
    let navigationController: UINavigationController

    public func openContributorDetails(login: String) {
        let githubResource = ServiceProvider.shared.resolve(serviceType: GithubResourceProtocol.self)!
        let viewModel = ContributorDetailsViewModel(login: login, githubResource: githubResource)
        let controller = ContributorDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}
