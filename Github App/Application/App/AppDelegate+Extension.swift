//
//  AppDelegate+Extension.swift
//  Github App
//
//  Created by Artem Korzh on 26.01.2022.
//

import Foundation

extension AppDelegate {
    func setupApplication() {
        registerServices()
    }

    private func registerServices() {
        ServiceProvider.shared.register(serviceType: GithubResourceProtocol.self, factory: {_ in NetworkService() })
    }
}
