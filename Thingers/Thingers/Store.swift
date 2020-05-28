//
//  Store.swift
//  Thingers
//
//  Created by Stefan Arentz on 2020-05-27.
//  Copyright © 2020 Stefan Arentz. All rights reserved.
//

import Foundation

struct Task: Identifiable {
    let id = UUID()
    var text: String = ""
    var done: Bool = false
}

struct Todo: Identifiable {
    let id = UUID()
    var title: String
    var tasks: [Task]
}

class Store: ObservableObject {
    @Published var todos: [Todo] = []
}

#if DEBUG
func makeTodo(title: String, tasks: String ...) -> Todo {
    return Todo(title: title, tasks: tasks.map { Task(text: $0) })
}

func storeWithSampleData() -> Store {
    let store = Store()
    store.todos = [
        makeTodo(title: "Master Plan", tasks: "Learn Swift", "Build a killer app", "Profit!"),
        makeTodo(title: "Shopping List", tasks: "Bacon", "Eggs", "Bread"),
    ]
    return store
}
#endif
