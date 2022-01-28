//
//  UIViewController+Extension.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import Foundation
import UIKit

extension UIViewController {
    public func displayError(error: Error) {
        let alert = UIAlertController(title: "Error occurred", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    public func openURL(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
