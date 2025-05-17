import SwiftUI
import Charts
import CoreData

struct ProgressView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch progress data for Assignments and Exams
    @FetchRequest(
        entity: Assignment.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.deadlineDate, ascending: true)],
        animation: .default
    ) private var assignments: FetchedResults<Assignment>
    
    @FetchRequest(
        entity: Exam.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exam.date, ascending: true)],
        animation: .default
    ) private var exams: FetchedResults<Exam>

    // Group data by type
    var assignmentData: [(day: String, count: Int)] {
        filteredData(for: "Assignment")
    }

    var examData: [(day: String, count: Int)] {
        filteredData(for: "Exam")
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Your Progress")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Assignments Chart
                ProgressChart(title: "Assignments Completion by Day", data: assignmentData, color: Color.green) // Use predefined color

                // Exams Chart
                ProgressChart(title: "Exams Completion by Day", data: examData, color: Color.blue) // Use predefined color

                Spacer()
            }
            .padding()
            
            // Bottom Navigation Bar (Fixed at the Bottom)
            .overlay(
                VStack {
                    Spacer()  // Push the navigation bar to the bottom
                    
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
                    .background(Color.white)  // Background to white for navigation bar
                    .shadow(radius: 5)  // Shadow for better visibility
                    .frame(maxWidth: .infinity)  // Full width for the navigation bar
                }
            )
        }
    }

    private func filteredData(for type: String) -> [(day: String, count: Int)] {
        let calendar = Calendar.current
        var result: [String: Int] = ["S": 0, "M": 0, "T": 0, "W": 0, "T": 0, "F": 0, "S": 0]

        // Loop through each progress entry and filter by type
        let entries: [NSManagedObject] = type == "Assignment" ? assignments.map { $0 as NSManagedObject } : exams.map { $0 as NSManagedObject }

        // Loop through each filtered entry
        for entry in entries {
            // Ensure we are working with either Assignment or Exam
            if let date = entry.value(forKey: "date") as? Date,
               let completedCount = entry.value(forKey: "completedCount") as? Int {
                let weekday = calendar.component(.weekday, from: date)
                let symbol = calendar.shortWeekdaySymbols[(weekday - 1) % 7].prefix(1)  // "M", "T", etc.
                result[String(symbol), default: 0] += completedCount
            }
        }

        return ["S", "M", "T", "W", "T", "F", "S"].map { day in
            (day: day, count: result[day] ?? 0)
        }
    }
}

struct ProgressChart: View {
    var title: String
    var data: [(day: String, count: Int)]
    var color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)

            Chart {
                ForEach(data, id: \.day) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(item.count > 0 ? color : .gray)
                }
            }
            .frame(height: 300)
            .padding(.bottom, 20)
        }
    }
}
