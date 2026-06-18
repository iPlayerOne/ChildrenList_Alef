import UIKit

extension UIViewController {
    
    var scrollableView: UIScrollView? {
        return view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let firstResponder = view.findFirstResponder() else { return }
        
        if let scrollView = self.scrollableView, firstResponder.isDescendant(of: scrollView) {
            let keyboardHeight = keyboardFrame.height
            let bottomPadding: CGFloat = 20
            
            UIView.animate(withDuration: 0.3) {
                scrollView.contentInset.bottom = keyboardHeight + bottomPadding
                scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + bottomPadding
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}
