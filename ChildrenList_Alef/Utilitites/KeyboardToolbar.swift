import UIKit

extension UITextField {
    func addKeyboardToolbar(
        target: Any, previousSelector: Selector, nextSelector: Selector,
        doneSelector: Selector
    ) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
//        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        toolbar.tintColor = .systemBlue
        
        let previousButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.up"),
            style: .plain,
            target: target,
            action: previousSelector
        )
        
        let nextButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .plain,
            target: target,
            action: nextSelector
        )
        
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: target,
            action: doneSelector
        )
        
        toolbar.setItems(
            [previousButton, nextButton, space, doneButton], animated: false)
        self.inputAccessoryView = toolbar
    }
}
