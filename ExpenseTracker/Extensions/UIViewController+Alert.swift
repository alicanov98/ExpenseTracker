//
//  AlertViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 03.08.26.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String,
        message: String
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okayAction = UIAlertAction(
            title: "OK",
            style: .default
        )

        alertController.addAction(okayAction)

        present(
            alertController,
            animated: true
        )
    }
}
