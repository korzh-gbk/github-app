//
//  ServiceProvider.swift
//  Github App
//
//  Created by Artem Korzh on 26.01.2022.
//

import Foundation

final class ServiceProvider {

    static let shared = ServiceProvider()
    private var container: [String: ServiceEntryProtocol] = [:]

    public func register<T>(serviceType: T.Type, factory: @escaping (ServiceProvider) -> T) {
        let key = "\(serviceType)"
        container[key] = ServiceEntry(factory: factory)
    }

    public func resolve<T>(serviceType: T.Type) -> T? {
        let key = "\(serviceType)"
        guard let entry = container[key] as? ServiceEntry<T> else {
            return nil
        }
        return entry.getEntry(provider: self)
    }

}
