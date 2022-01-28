//
//  ServiceEntry.swift
//  Github App
//
//  Created by Artem Korzh on 26.01.2022.
//

import Foundation

protocol ServiceEntryProtocol {
    func getEntry<Service>(provider: ServiceProvider) -> Service?
}

final class ServiceEntry<Service>: ServiceEntryProtocol {
    let factory: (ServiceProvider) -> Service?
    internal init(factory: @escaping (ServiceProvider) -> Service?) {
        self.factory = factory
    }

    func getEntry<Service>(provider: ServiceProvider) -> Service? {
        guard let instance = factory(provider) as? Service else {
            return nil
        }

        return instance
    }
}
