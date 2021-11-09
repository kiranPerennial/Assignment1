//
//  LoginAction.swift
//  Assignment1
//
//  Created by APPLE on 09/11/21.
//

import Foundation
import ReSwift

struct SignupAction: Action {
  let user: User
}

struct TaskListAction: Action {
}

struct NewTaskAction: Action {
    var newTask: Task
}
