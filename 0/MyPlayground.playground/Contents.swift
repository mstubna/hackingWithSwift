import UIKit

struct TaylorFan {
    // static variable
    static var FAVORITESONG = "Shake it Off"
    
    // properties have willSet and didSet observers
    var name: String {
        willSet {
            print("I'm changing from \(name) to \(newValue)")
        }
        
        didSet {
            print("I just changed from \(oldValue) to \(name)")
        }
    }

    var age: Int
    
    // optional variable
    var occupation: String?
    
    // structs can have methods
    func favoriteSong() -> String {
        return TaylorFan.FAVORITESONG
    }

    // pattern for unwrapping optionals
    func description() -> String {
        if let unwrappedOccupation = occupation {
            return "name: \(name), age: \(age), occupation: \(unwrappedOccupation)"
        } else {
            return "name: \(name), age: \(age)"
        }
    }
    
    // another possibility for dealing with optionals is to use optional coalescing
    func descriptionAlternative() -> String {
        let unwrappedOccupation = occupation ?? "unknown"
        return "name: \(name), age: \(age), occupation: \(unwrappedOccupation)"
    }
    
    //    // strings inside of strings aren't valid until Swift 2.1, otherwise we could do
    //    func descriptionAlternative() -> String {
    //        return "name: \(name), age: \(age), occupation: \(occupation ?? "unknown")"
    //    }
}

// structs have member-wise constructors
let fan = TaylorFan(name: "James", age: 25, occupation: nil)

// structs are copy by value
var fanCopy = fan
fanCopy.name = "Fred"
fanCopy.age = 27
fanCopy.occupation = "Engineer"

// prints results
print(fan.description())
print(fan.descriptionAlternative())
print(fan.favoriteSong())
print(fanCopy.description())
print(fanCopy.descriptionAlternative())
