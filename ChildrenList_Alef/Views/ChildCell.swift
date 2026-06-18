import UIKit

final class ChildCell: UITableViewCell {
    private let nameAgeView = NameAgeView()
    private let removeButton = CustomButton(style: .clear, title: "Удалить")
    
    var onChildUpdated: ((String, Int?) -> Void)?
    var onRemoveTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with child: Child) {
        nameAgeView.currentName = child.name
        nameAgeView.currentAge = child.age
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [nameAgeView, removeButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        removeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupActions() {
        nameAgeView.onNameChanged = { [weak self] newName in
            self?.onChildUpdated?(newName, self?.nameAgeView.currentAge)
        }
        nameAgeView.onAgeChanged = { [weak self] newAge in
            self?.onChildUpdated?(self?.nameAgeView.currentName ?? "", newAge)
        }
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
    }
    
    @objc private func removeTapped() {
        onRemoveTapped?()
    }
}
