import SwiftUI

@main
struct SmartStudyApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn = false  // Check if the user is logged in

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                DashboardView()  // Show dashboard if logged in
            } else {
                AuthView()  // Show login screen if not logged in
            }
        }
    }
}
