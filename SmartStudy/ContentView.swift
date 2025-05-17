import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch requests for Assignments and Exams
    @FetchRequest(entity: Assignment.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.deadlineDate, ascending: true)], animation: .default)
    private var assignments: FetchedResults<Assignment>
    
    @FetchRequest(entity: Exam.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Exam.date, ascending: true)], animation: .default)
    private var exams: FetchedResults<Exam>

    var body: some View {
        NavigationView {
            List {
                // Display Assignments
                Section(header: Text("Assignments")) {
                    ForEach(assignments) { assignment in
                        NavigationLink {
                            Text("Assignment: \(assignment.title ?? "Untitled") - Due: \(formatDate(assignment.deadlineDate))")
                        } label: {
                            Text("\(assignment.title ?? "Untitled") - Due: \(formatDate(assignment.deadlineDate))")
                        }
                    }
                    .onDelete(perform: deleteAssignments)
                }

                // Display Exams
                Section(header: Text("Exams")) {
                    ForEach(exams) { exam in
                        NavigationLink {
                            Text("Exam: \(exam.title ?? "Untitled") - Date: \(formatDate(exam.date))")
                        } label: {
                            Text("\(exam.title ?? "Untitled") - Date: \(formatDate(exam.date))")
                        }
                    }
                    .onDelete(perform: deleteExams)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    // Helper function to format dates
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // Add new item (for assignments and exams)
    private func addItem() {
        withAnimation {
            // For example, adding a new Assignment (you can adjust this for Exams)
            let newAssignment = Assignment(context: viewContext)
            newAssignment.title = "New Assignment"
            newAssignment.deadlineDate = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Delete selected assignments
    private func deleteAssignments(offsets: IndexSet) {
        withAnimation {
            offsets.map { assignments[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    // Delete selected exams
    private func deleteExams(offsets: IndexSet) {
        withAnimation {
            offsets.map { exams[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    // Save context after adding/deleting
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
