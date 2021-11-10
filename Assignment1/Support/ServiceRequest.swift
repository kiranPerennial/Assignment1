import Foundation
public class ServiceRequest {
    
    fileprivate init() { }
    
    static fileprivate func getURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    static func store(_ object: User,as fileName: String) {
        let url = getURL().appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        do {
            var allUsers = [object]
            if FileManager.default.fileExists(atPath: url.path), let users = retrieve(fileName, as: [User].self) {
                for user in users {
                    if user.email != object.email || user.password != object.password {
                        allUsers.append(user)
                    }
                }
                try FileManager.default.removeItem(at: url)
            }
            let data = try encoder.encode(allUsers)
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func retrieve(_ fileName: String, as type: Array<User>.Type) -> [User]? {
        let url = getURL().appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            return []
        }
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                print(model)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(url.path)!")
        }
    }

    static func fileExists(_ fileName: String) -> Bool {
        let url = getURL().appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
