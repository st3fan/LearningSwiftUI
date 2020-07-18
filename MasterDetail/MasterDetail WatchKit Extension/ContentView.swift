//
//  ContentView.swift
//  MasterDetail WatchKit Extension
//
//  Created by Stefan Arentz on 18/07/2020.
//  Copyright © 2020 Example. All rights reserved.
//

import SwiftUI

class Message: Identifiable {
    let identifier: String
    let date: Date
    let title: String
    let body: String
    let category: String
    
    var id: String {
        identifier
    }

    init(identifier: String, date: Date, title: String, body: String, category: String) {
        self.identifier = identifier
        self.date = date
        self.title = title
        self.body = body
        self.category = category
    }
}

class Category: ObservableObject, Identifiable {
    let name: String
    @Published var messages: [Message] = []
    
    var id: String {
        name
    }

    init(name: String, messages: [Message] = []) {
        self.name = name
        self.messages = messages
    }
}

/**
 * MessageStore is a simple in-memory data store. To keep this a simple example, there
 * is no persistence.
 */

class MessageStore: ObservableObject {
    
    @Published var messages: [Message] = []

    @Published var categories: [Category] = []

    static let sharedInstance = MessageStore()
        
    // MARK: -
    
    func insert(message: Message) throws {
        messages.append(message)
        messages.sort  { $0.date > $1.date }

        if message.category != "" {
            if let category = categories.first(where: { $0.name == message.category }) {
                category.messages.append(message)
                category.messages.sort { $0.date > $1.date }
            } else {
                categories.append(Category(name: message.category, messages: [message]))
            }
        }
    }
    
    func delete(message: Message) throws {
        messages.removeAll { (m) -> Bool in
            m.identifier == message.identifier
        }
        if message.category != "" {
            if let category = categories.first(where: { $0.name == message.category }) {
                category.messages.removeAll { (m) -> Bool in
                    m.identifier == message.identifier
                }
                // If the category is empty, remove it?
                if category.messages.isEmpty {
                    categories.removeAll { (c) -> Bool in
                        c.name == message.category
                    }
                }
            }
        }
    }
    
    func reset() throws {
        self.categories = []
        self.messages = []
    }
}

//

struct MessageDetailView: View {
    let message: Message
    var body: some View {
        Text(message.body)
    }
}

//

struct MessageCellView: View {
    let message: Message
    var body: some View {
        NavigationLink(destination: MessageDetailView(message: message)) {
            VStack(alignment: .leading) {
                Text(title(for: self.message)).bold().lineLimit(1)
                Text(self.format(date: self.message.date)).font(.system(size: 13))
            }
        }.padding()
    }
    
    func title(for message: Message) -> String {
        if message.title != "" {
            return message.title
        }
        return message.body
    }
    
    func format(date: Date) -> String {
        let now = Date()
        if date.distance(to: now) < 60 {
            return "just moments ago"
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.dateTimeStyle = .named
            return formatter.localizedString(for: date, relativeTo: now)
        }
    }
}

//

struct AllMessagesView: View {
    @ObservedObject var messageStore = MessageStore.sharedInstance

    @ViewBuilder
    var body: some View {
        if messageStore.messages.count == 0 {
            Text("No messages").multilineTextAlignment(.center)
                .navigationBarTitle("All Messages")
        } else {
            List {
                ForEach(messageStore.messages) { message in
                    MessageCellView(message: message)
                }.onDelete(perform: deleteMessages)
            }
            .navigationBarTitle("All Messages")
        }
    }

    func deleteMessages(at offsets: IndexSet) {
        for index in offsets {
            do {
                try messageStore.delete(message: messageStore.messages[index])
            } catch {
                NSLog("Failed to delete message: \(error.localizedDescription)")
            }
        }
    }
}

//

struct CategoryMessagesView: View {
    @ObservedObject var messageStore = MessageStore.sharedInstance

    @ObservedObject var category: Category

    var body: some View {
        Group {
            if category.messages.count == 0 {
                Text("No messages in category “\(category.name)”").multilineTextAlignment(.center)
            } else {
                List {
                    ForEach(category.messages) { message in
                        MessageCellView(message: message)
                    }.onDelete(perform: deleteMessages)
                }
            }
        }.navigationBarTitle(category.name)
    }

    func deleteMessages(at offsets: IndexSet) {
        for index in offsets {
            do {
                try messageStore.delete(message: category.messages[index])
            } catch {
                NSLog("Cannot delete message: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var messageStore = MessageStore.sharedInstance

    var body: some View {
        List {
            Section {
                NavigationLink(destination: AllMessagesView()) {
                    HStack {
                        Image(systemName: "tray.2")
                        Text("All Messages")
                        Spacer()
                        Text("\(messageStore.messages.count)")
                            .font(messageCountFont())
                            .bold()
                            .layoutPriority(1)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Section {
                Group {
                    if messageStore.categories.count > 0 {
                        Section {
                            ForEach(messageStore.categories) { category in
                                NavigationLink(destination: CategoryMessagesView(category: category)) {
                                    HStack {
                                        Image(systemName: "tray") // .foregroundColor(.green)
                                        Text("\(category.name)").lineLimit(1).truncationMode(.tail)
                                        Spacer()
                                        Text("\(category.messages.count)")
                                            .font(self.messageCountFont())
                                            .bold()
                                            .layoutPriority(1)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    // TODO This is pretty inefficient
    func messageCountFont() -> Font {
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        return Font(font.withSize(font.pointSize * 0.75))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
