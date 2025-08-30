import SwiftUI
import WatchKit

@main
struct RowFitWatchApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
