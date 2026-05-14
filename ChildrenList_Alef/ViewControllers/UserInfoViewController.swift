import UIKit

final class UserInfoViewController: UIViewController {
    private let vm: UserInfoViewModel
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let headerView: UserInfoHeaderView = {
        let view = UserInfoHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let clearButton: CustomButton = {
        let button = CustomButton(style: .outlineRed, title: "Очистить")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(vm: UserInfoViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupBindings()
        vm.onDataUpdated?()
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        vm.saveData()
        unregisterForKeyboardNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChildCell.self, forCellReuseIdentifier: "ChildCell")
        
        [headerView, tableView, clearButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -16),
            
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            clearButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupActions() {
        headerView.onAddChild = { [weak self] in
            guard let self = self, self.vm.userCache.children.count < 5 else { return }
            
            self.vm.updateUser(
                name: self.headerView.nameAgeView.currentName,
                age: self.headerView.nameAgeView.currentAge
            )

            self.vm.addChild()
        }
        
        headerView.onUserInfoUpdated = { [weak self] name, age in
            self?.vm.updateUser(name: name, age: age)
        }
        
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        vm.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.headerView.update(
                    name: self.vm.userCache.name,
                    age: self.vm.userCache.age
                )
                self.headerView.addButton.isHidden = self.vm.userCache.children.count >= 5
                self.tableView.reloadData()
            }
        }
    }
    
    func saveData() {
        vm.saveData()
    }
    
    @objc private func clearTapped() {
        showConfirmationAlert(
            title: "Очистить данные",
            message: nil,
            confirmTitle: "Сбросить",
            confirmStyle: .destructive
        ) { [weak self] in
            self?.vm.clearData()
        }
    }
}

extension UserInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.userCache.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath) as? ChildCell else {
            return UITableViewCell()
        }
        
        let child = vm.userCache.children[indexPath.row]
        cell.configure(with: child)
        
        cell.onChildUpdated = { [weak self] name, age in
            guard let self = self else { return }
            vm.updateChild(at: indexPath.row, name: name, age: age)
        }
        
        cell.onRemoveTapped = { [weak self] in
            guard let self = self else { return }
            vm.removeChild(at: indexPath.row)
        }
        
        return cell
    }
}
