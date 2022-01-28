//
//  KeyedDecodingContainer+Extension.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import Foundation

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
}
