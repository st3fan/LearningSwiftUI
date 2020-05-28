//
//  MasterView.swift
//  Thingers
//
//  Created by Stefan Arentz on 2020-05-27.
//  Copyright © 2020 Stefan Arentz. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        List {
            ForEach(store.todos) { todo in
                NavigationLink(destination: DetailView(todo: self.$store.todos[ self.store.todos.firstIndex(where: { $0.id == todo.id })! ])) {
                    Text(todo.title)
                }
            }.onDelete { indices in
                indices.forEach { self.store.todos.remove(at: $0) }
            }
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView().environmentObject(storeWithSampleData())
    }
}
