//
//  ForgotAppApp.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-02-23.
//

import SwiftUI
import ComposableArchitecture

@main
struct ForgotAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView (
                    store: .init(
                        initialState: .init(),
                        reducer: appReducer.debugActions(),
                        environment: .init(
                            localSearch: .live,
                            localSearchCompleter: .live,
                            mainQueue: .main
                        )
                    )
                )
            }
        }
    }
}
