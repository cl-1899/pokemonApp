//
//  AlertManager.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 19.09.23.
//

import UIKit

class AlertManager {
    static func showAlert(_ alertType: AlertType,  on vc: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController.getAlert(by: alertType)
            vc.present(alertController, animated: true)
        }
    }
}

enum AlertType {
    case loadDataError
    case noNetwork
    
    var title: String {
        switch self {
        case .loadDataError:
            return "Error"
        case .noNetwork:
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .loadDataError:
            return "An Error occured while loading data."
        case .noNetwork:
            return "No network connection."
        }
    }
}

extension UIAlertAction {
    class func getOkAction() -> UIAlertAction {
        return UIAlertAction(title: "OK", style: .default)
    }
}

extension UIAlertController {
    class func getAlert(by type: AlertType) -> UIAlertController {
        let controller = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        controller.addAction(UIAlertAction.getOkAction())

        return controller
    }
}
