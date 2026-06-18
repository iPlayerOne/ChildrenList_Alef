import Foundation

final class UserInfoViewModel {
    private let userStore: UserStorage
    private(set) var userCache: User
    
    var onDataUpdated: (() -> Void)?
    
    init(userStore: UserStorage) {
        self.userStore = userStore
        self.userCache = userStore.getUser()
    }
    
    func updateUser(name: String, age: Int?) {
        guard userCache.name != name || userCache.age != age else { return }
        userCache = User(name: name, age: age, children: userCache.children)
        saveData()
    }
    
    func addChild() {
        guard userCache.children.count < 5 else { return }
        var updatedChildren = userCache.children
        updatedChildren.append(Child(name: "", age: nil))
        
        userCache = User(name: userCache.name, age: userCache.age, children: updatedChildren)
        saveData()
    }
    
    func updateChild(at index: Int, name: String, age: Int?) {
        guard index < userCache.children.count else { return }
        userCache.children[index] = Child(name: name, age: age)
        saveData()
    }
    
    func removeChild(at index: Int) {
        guard index < userCache.children.count else { return }
        userCache.children.remove(at: index)
        saveData()
    }
    
    func clearData() {
        userCache = User(name: "", age: nil, children: [])
        userStore.clearAll()
        saveData()
    }
    
    func saveData() {
        userStore.updateUser(userCache)
        onDataUpdated?()
    }
}
