import UIKit

final class NameAgeView: UIView {
    private let nameTextField = PaddedTextField()
    private let ageTextField = PaddedTextField()
    
    var onNameChanged: ((String) -> Void)?
    var onAgeChanged: ((Int?) -> Void)?
    
    var currentName: String {
        get { nameTextField.text ?? "" }
        set { nameTextField.text = newValue }
    }
    
    var currentAge: Int? {
        get { Int(ageTextField.text ?? "") }
        set { ageTextField.text = newValue.map { "\($0)" } ?? "" }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        nameTextField.setPlaceholder("Имя")
        nameTextField.autocorrectionType = .no
        nameTextField.spellCheckingType = .no
        nameTextField.inputAssistantItem.leadingBarButtonGroups = []
        nameTextField.inputAssistantItem.trailingBarButtonGroups = []
        nameTextField.delegate = self
        nameTextField.addKeyboardToolbar(
            target: self,
            previousSelector: #selector(previousField),
            nextSelector: #selector(nextField),
            doneSelector: #selector(dismissKeyboard)
        )
        
        ageTextField.setPlaceholder("Возраст")
        ageTextField.keyboardType = .numberPad
        ageTextField.delegate = self
        ageTextField.addKeyboardToolbar(
            target: self,
            previousSelector: #selector(previousField),
            nextSelector: #selector(nextField),
            doneSelector: #selector(dismissKeyboard)
        )
        
        let stack = UIStackView(arrangedSubviews: [nameTextField, ageTextField])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingDidEnd)
        ageTextField.addTarget(self, action: #selector(ageChanged), for: .editingDidEnd)
    }
    
    @objc private func nameChanged() {
        onNameChanged?(currentName)
    }
    
    @objc private func ageChanged() {
        onAgeChanged?(Int(ageTextField.text ?? ""))
    }
    
    @objc private func previousField() {
        if ageTextField.isFirstResponder {
            nameTextField.becomeFirstResponder()
        }
    }
    
    @objc private func nextField() {
        if nameTextField.isFirstResponder {
            ageTextField.becomeFirstResponder()
        }
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    func resetFields() {
        nameTextField.text = ""
        ageTextField.text = ""
    }
}

extension NameAgeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField == ageTextField ? (string.isEmpty || string.rangeOfCharacter(from: .decimalDigits) != nil) : true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            let newName = textField.text ?? ""
            if newName != currentName {
                onNameChanged?(newName)
            }
        } else if textField == ageTextField {
            let newAge = Int(textField.text ?? "")
            if newAge != currentAge {
                onAgeChanged?(newAge)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            ageTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
