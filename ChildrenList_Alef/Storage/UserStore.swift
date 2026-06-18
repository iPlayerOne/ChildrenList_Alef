protocol UserStorage {
    func getUser() -> User
    func updateUser(_ user: User)
    func clearAll()
}

final class UserStore: UserStorage {
    private let storage: UserDefaultsManager
    private let key = "user"
    
    init(storage: UserDefaultsManager) {
        self.storage = storage
    }
    
    func getUser() -> User {
        if let user = storage.get(forKey: key, type: User.self) {
            AppLogger.shared.debug("[getUser] Загружены данные: \(user)")
            return user
        }
        AppLogger.shared.debug("[getUser] Данных нет")
        return User(name: "", age: nil, children: [])
    }
    
    func updateUser(_ user: User) {
        AppLogger.shared.debug("[updateUser] Сохранение: \(user)")
        storage.set(user, forKey: key)
    }
    
    func clearAll() {
        storage.remove(forKey: key)
    }
}
