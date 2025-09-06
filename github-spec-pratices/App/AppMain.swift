import SwiftUI

@main
struct AppMain: App {
    @StateObject private var store = TaskStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskListView()
            }
            .environmentObject(store)
        }
    }
}

