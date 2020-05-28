//
//  SceneDelegate.swift
//  Thingers
//
//  Created by Stefan Arentz on 2020-05-27.
//  Copyright © 2020 Stefan Arentz. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView.environmentObject(storeWithSampleData()))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
