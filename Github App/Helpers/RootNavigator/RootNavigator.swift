//
//  RootNavigator.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation
import UIKit

final class RootNavigator {
    let navigationController = UINavigationController()

    public func openApp(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        RepoListNavigator(navigationController: navigationController).openRepoList()
    }
}
