//
//  UITextField+Extension.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map({ ($0.object as? UITextField)?.text ?? "" })
            .eraseToAnyPublisher()
    }
}
