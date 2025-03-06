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
//        storage.get(forKey: key, type: User.self) ?? User(name: "", age: nil, children: [])
        if let user = storage.get(forKey: key, type: User.self) {
            print("[getUser] Загружены данные: \(user)")
            return user
        }
        print("[getUser] Данных нет")
        return User(name: "", age: nil, children: [])
    }
    
    func updateUser(_ user: User) {
        print("[updateUser] Сохранение: \(user)")
        storage.set(user, forKey: key)
    }
    
    func clearAll() {
        storage.remove(forKey: key)
    }
    
    
}

