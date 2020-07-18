//
//  HostingController.swift
//  MasterDetail WatchKit Extension
//
//  Created by Stefan Arentz on 18/07/2020.
//  Copyright © 2020 Example. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override func awake(withContext context: Any?) {
        try! MessageStore.sharedInstance.insert(message:Message(identifier: UUID().uuidString, date: Date(),
                                                                title: "Message One", body: "Some Body One", category: ""))
        try! MessageStore.sharedInstance.insert(message: Message(identifier: UUID().uuidString, date: Date(),
                                                                title: "Message Two", body: "Some Body Two", category: ""))
        try! MessageStore.sharedInstance.insert(message: Message(identifier: UUID().uuidString, date: Date(),
                                                                 title: "Message Three", body: "Some Body Three", category: ""))
        try! MessageStore.sharedInstance.insert(message: Message(identifier: UUID().uuidString, date: Date(),
                                                                 title: "Thing One", body: "Some Body", category: "Things"))
        try! MessageStore.sharedInstance.insert(message: Message(identifier: UUID().uuidString, date: Date(),
                                                                 title: "Thing Two", body: "Some Body", category: "Things"))
        try! MessageStore.sharedInstance.insert(message: Message(identifier: UUID().uuidString, date: Date(),
                                                                 title: "Foo Title", body: "Foo Body", category: "Foo"))
        try! MessageStore.sharedInstance.insert(message: Message(identifier: UUID().uuidString, date: Date(),
                                                                 title: "Bar Title", body: "Bar Body", category: "Bar"))
    }
    
    override var body: ContentView {
        return ContentView()
    }
}
