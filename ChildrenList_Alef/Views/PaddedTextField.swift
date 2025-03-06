import UIKit

final class PaddedTextField: UITextField {
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let padding = UIEdgeInsets(top: 20, left: 6, bottom: 8, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        borderStyle = .roundedRect
        font = .systemFont(ofSize: 16, weight: .regular)
        
        addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4)
        ])
    }
    
    func setPlaceholder(_ text: String) {
        placeholderLabel.text = text
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

