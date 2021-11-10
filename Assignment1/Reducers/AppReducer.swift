//
//  AppReducer.swift
//  Assignment1
//
//  Created by APPLE on 09/11/21.
//

import Foundation
import ReSwift
func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState(user: nil)
    switch action {
    case let newTaskAction as NewTaskAction:
        state.user!.taskList.append(newTaskAction.newTask)
        ServiceRequest.store(state.user!, as: "TaskList.json")
        if let allUser = ServiceRequest.retrieve("TaskList.json", as: [User].self) {
            for user in allUser {
                if user.email == state.user!.email {
                    state.user = user
                    break
                }
            }
        }
    case _ as TaskListAction:
        if let allUser = ServiceRequest.retrieve("TaskList.json", as: [User].self) {
            for user in allUser {
                if user.email == state.user!.email {
                    state.user = user
                    break
                }
            }
        }
    case let newTask as LoginAction:
        state.user = newTask.user
    case let newTask as SignupAction:
        ServiceRequest.store(newTask.user, as: "TaskList.json")
        state.user = newTask.user
    default: break
    }
    return state
}
