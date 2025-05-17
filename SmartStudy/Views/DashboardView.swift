import SwiftUI
import CoreData

struct DashboardView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    // Fetch Request for Assignments and Exams from Core Data
    @FetchRequest(entity: Assignment.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.deadlineDate, ascending: true)])
    var assignments: FetchedResults<Assignment>
    
    @FetchRequest(entity: Exam.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Exam.date, ascending: true)])
    var exams: FetchedResults<Exam>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Dashboard Title
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Welcome Message
                Text("Welcome back to Smart Study!")
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack(spacing: 15) {
                    // Classes Button with Icon Above Text
                    NavigationLink(destination: ClassesView()) {
                        VStack {
                            Image(systemName: "book.fill")  // Icon for Classes
                                .font(.title3)  // Smaller icon size
                            Text("Classes")
                                .font(.footnote)  // Smaller font size
                        }
                        .frame(width: 80, height: 50)  // Adjusted size for icon and text
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Assignments Button with Icon Above Text
                    NavigationLink(destination: AssignmentsView()) {
                        VStack {
                            Image(systemName: "list.bullet")  // Icon for Assignments
                                .font(.title3)  // Smaller icon size
                            Text("Assignments")
                                .font(.footnote)  // Smaller font size
                        }
                        .frame(width: 80, height: 50)  // Adjusted size for icon and text
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Exams Button with Icon Above Text
                    NavigationLink(destination: ExamsView()) {
                        VStack {
                            Image(systemName: "calendar.badge.clock")  // Icon for Exams
                                .font(.title3)  // Smaller icon size
                            Text("Exams")
                                .font(.footnote)  // Smaller font size
                        }
                        .frame(width: 80, height: 50)  // Adjusted size for icon and text
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()

                // Upcoming Tasks Section (Aligned to the Left)
                VStack(alignment: .leading) {
                    Text("Upcoming Tasks")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    // Display Assignments - use `id` properly
                    ForEach(assignments.prefix(3), id: \.self) { assignment in
                        Text("Assignment: \(assignment.title ?? "Unknown") - Due: \(formatDate(assignment.deadlineDate))")
                            .padding(.bottom, 2)
                    }
                    
                    // Display Exams - use `id` properly
                    ForEach(exams.prefix(3), id: \.self) { exam in
                        Text("Exam: \(exam.title ?? "Unknown") - Date: \(formatDate(exam.date))")
                            .padding(.bottom, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)  // Ensure the VStack is left-aligned

                Spacer()  // Pushes content above it
                
                // Bottom Navigation Bar (Fixed at the Bottom)
                HStack {
                    NavigationLink(destination: DashboardView()) {
                        VStack {
                            Image(systemName: "house.fill")  // Home icon
                                .font(.title2)
                            Text("Home")
                                .font(.footnote)
                        }
                        .foregroundColor(.black)  // Set icon and text to black
                        .padding()  // Padding for space between icon and text
                    }
                    
                    NavigationLink(destination: PomodoroView()) {
                        VStack {
                            Image(systemName: "clock.fill")  // Pomodoro icon
                                .font(.title2)
                            Text("Pomodoro")
                                .font(.footnote)
                        }
                        .foregroundColor(.black)  // Set icon and text to black
                        .padding()  // Padding for space between icon and text
                    }
                    
                    NavigationLink(destination: ClassesView()) {
                        VStack {
                            Image(systemName: "book.fill")  // Classes icon
                                .font(.title2)
                            Text("Classes")
                                .font(.footnote)
                        }
                        .foregroundColor(.black)  // Set icon and text to black
                        .padding()  // Padding for space between icon and text
                    }
                    
                    NavigationLink(destination: ProgressView()) {
                        VStack {
                            Image(systemName: "chart.bar.fill")  // Progress icon
                                .font(.title2)
                            Text("Progress")
                                .font(.footnote)
                        }
                        .foregroundColor(.black)  // Set icon and text to black
                        .padding()  // Padding for space between icon and text
                    }
                }
                .padding(.bottom, 10)  // Padding at the bottom
                .background(Color.white)  // No background to remove the boxes
                .shadow(radius: 5)  // Shadow for better visibility
                .frame(maxWidth: .infinity)  // Full width
            }
            .padding()
        }
    }
    
    // Helper function to format the date
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
