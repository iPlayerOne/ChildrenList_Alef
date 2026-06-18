import Foundation

struct User: Codable, Equatable {
    var name: String
    var age: Int?
    var children: [Child]
    
    func with(
        name: String? = nil,
        age: Int? = nil,
        children: [Child]? = nil
    ) -> User {
        User(
            name: name ?? self.name,
            age: age ?? self.age,
            children: children ?? self.children)
        }
}

struct Child: Codable, Equatable {
    var name: String
    var age: Int?
}

