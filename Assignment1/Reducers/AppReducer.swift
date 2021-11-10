import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    var curState = state ?? AppState(user: nil)
    
    switch action {
    case let newTaskAction as AddUpdateTaskAction:
        if newTaskAction.selectedTask == nil {
            curState.user!.taskList = curState.user!.taskList.filter{ $0.title != newTaskAction.newTask.title || $0.dateTime != newTaskAction.newTask.dateTime}
            curState.user!.taskList.append(newTaskAction.newTask)
        } else {
            var list = curState.user!.taskList
            for index in 0 ..< list.count {
                if list[index].title == newTaskAction.selectedTask?.title && list[index].dateTime == newTaskAction.selectedTask?.dateTime {
                    list[index] = newTaskAction.newTask
                    break
                }
            }
            curState.user!.taskList = list
        }
        ServiceRequest.store(curState.user!, as: "NewTaskList.json")
        if let allUser = ServiceRequest.retrieve("NewTaskList.json", as: [User].self) {
            for user in allUser {
                if user.email == curState.user!.email && user.password == curState.user!.password {
                    curState.user = user
                    break
                }
            }
        }
    case let newTaskAction as DeleteTaskAction:
        curState.user!.taskList = curState.user!.taskList.filter{ $0.title != newTaskAction.deleteTask.title || $0.dateTime != newTaskAction.deleteTask.dateTime}
        ServiceRequest.store(curState.user!, as: "NewTaskList.json")
    case _ as TaskListAction:
        if let allUser = ServiceRequest.retrieve("NewTaskList.json", as: [User].self) {
            for user in allUser {
                if user.email == curState.user!.email && user.password == curState.user!.password {
                    curState.user = user
                    break
                }
            }
        }
    case let newTask as LoginAction:
        curState.user = newTask.user
    case let newTask as SignupAction:
        ServiceRequest.store(newTask.user, as: "NewTaskList.json")
        curState.user = newTask.user
    case let newTask as UpdateTaskAction:
        curState.selectedTask = newTask.selectedTask
    case _ as CreateTaskAction:
        curState.selectedTask = nil
    default: break
    }
    return curState
}
