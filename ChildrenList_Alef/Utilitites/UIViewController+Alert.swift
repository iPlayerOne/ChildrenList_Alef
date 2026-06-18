import UIKit

extension UIViewController {
    func showConfirmationAlert(
        title: String,
        message: String?,
        confirmTitle: String,
        confirmStyle: UIAlertAction.Style = .default,
        confirmAction: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            confirmAction()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

