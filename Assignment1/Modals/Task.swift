import Foundation

struct User:Codable {
    let email:String
    let password:String
    var taskList:[Task]
}

struct Task:Codable {
    let title:String
    let dateTime:String
}
