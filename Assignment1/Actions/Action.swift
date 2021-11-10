import Foundation
import ReSwift

struct SignupAction: Action {
  let user: User
}

struct LoginAction: Action {
  let user: User
}

struct TaskListAction: Action {
}

struct AddUpdateTaskAction: Action {
    var newTask: Task
    var selectedTask: Task?
}

struct UpdateTaskAction: Action {
    var selectedTask: Task
}

struct CreateTaskAction: Action {
    
}

struct DeleteTaskAction: Action {
    var deleteTask: Task
}

