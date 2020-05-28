//
//  DetailView.swift
//  Thingers
//
//  Created by Stefan Arentz on 2020-05-27.
//  Copyright © 2020 Stefan Arentz. All rights reserved.
//

import SwiftUI

// TODO All this firstIndex() stuff is horrible - is there really not a better way to do this?

struct TaskTextView: View {
    @Binding var task: Task
    @State var editing: Bool = false
    
    var body: some View {
        TextField("New Task", text: $task.text)
            .font(.title)
    }
}

struct DetailView: View {
    @Binding var todo: Todo
    
    var body: some View {
        List(todo.tasks) { task in
            HStack {
                Button(action: { self.todo.tasks[ self.todo.tasks.firstIndex(where: { $0.id == task.id })!].done.toggle() }) {
                    Image(systemName: "checkmark.rectangle")
                        .foregroundColor(self.todo.tasks[ self.todo.tasks.firstIndex(where: { $0.id == task.id })!].done ? Color.black : Color(white: 0.90))
                        .font(.title)
                        .padding([.leading, .trailing])
                }
                TaskTextView(task: self.$todo.tasks[ self.todo.tasks.firstIndex(where: { $0.id == task.id })!])
                    .padding([.top, .bottom])
            }.buttonStyle(PlainButtonStyle())
        }
        .navigationBarTitle(Text(todo.title))
        .navigationBarItems(
                            trailing: Button(action: {withAnimation { self.todo.tasks.insert(Task(), at: 0) } }) {
                Image(systemName: "plus")
            }
        )
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let todo = Todo(title: "Some list of things", tasks: [Task(text: "Buy a pound of bacon", done: true), Task(text: "Clean the car"), Task(text: "Write an essay"), Task(text: "Read that book")])
        return NavigationView {
            DetailView(todo: .constant(todo))
        }
    }
}

