//
//  ContentView.swift
//  Thingers
//
//  Created by Stefan Arentz on 2020-05-27.
//  Copyright © 2020 Stefan Arentz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("Todo Lists"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { self.store.todos.insert(Todo(title: "Some Todo List", tasks: [Task()]), at: 0) }
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
            Text("Nothing here")
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(storeWithSampleData())
    }
}
