import UIKit

final class UserInfoHeaderView: UIView {
    
    private let userTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Персональные данные"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let childrenTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дети (макс.5)"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let nameAgeView = NameAgeView()
    let addButton = CustomButton(style: .outlineBlue, title: "Добавить ребенка")
    
    var onAddChild: (() -> Void)?
    var onUserInfoUpdated: ((String, Int?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let childrenHeader = makeChildrenHeaderStack()
        let mainStack = makeMainStack(with: childrenHeader)
        
        addSubview(mainStack)
        setupConstraints(for: mainStack)
        setupActions()
    }
    
    private func makeChildrenHeaderStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [childrenTitleLabel, addButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }
    
    private func makeMainStack(with childrenHeader: UIStackView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [userTitleLabel, nameAgeView, childrenHeader])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func setupConstraints(for stack: UIStackView) {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        nameAgeView.onNameChanged = { [weak self] newName in
            self?.onUserInfoUpdated?(newName, self?.nameAgeView.currentAge)
        }
        
        nameAgeView.onAgeChanged = { [weak self] newAge in
            self?.onUserInfoUpdated?(self?.nameAgeView.currentName ?? "", newAge)
        }
    }
    
    func update(name: String, age: Int?) {
        nameAgeView.currentName = name
        nameAgeView.currentAge = age
    }
    
    @objc private func addTapped() {
        onAddChild?()
    }
}

