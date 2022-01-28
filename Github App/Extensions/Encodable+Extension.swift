//
//  Encodable+Extension.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation

extension Encodable {
    public var encoded: Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            print(error)
            return nil
        }
    }
}
