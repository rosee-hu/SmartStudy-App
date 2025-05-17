import SwiftUI
import CoreData

struct AssignmentsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.deadlineDate, ascending: true)],
        animation: .default)
    private var assignments: FetchedResults<Assignment>
    
    @State private var showingAddAssignmentForm = false  // Show Add Assignment form
    
    var body: some View {
        NavigationView {
            VStack {
                // Title
                Text("Future Assignments")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Check if there are any assignments scheduled
                if assignments.isEmpty {
                    Text("No assignments scheduled yet. Tap the '+' button to add a new assignment.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // List of Assignments
                    List(assignments) { assignment in
                        VStack(alignment: .leading) {
                            Text(assignment.title ?? "No title")
                                .font(.headline)
                            Text(assignment.subject ?? "No subject")
                                .font(.subheadline)
                            Text("Deadline: " + formatDate(assignment.deadlineDate) + " at " + formatTime(assignment.deadlineTime))
                                .font(.subheadline)
                            Text(assignment.assignmentDescription ?? "No description")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Spacer to push the "+" button to the bottom
                Spacer()
                
                // "+" Button to show Add Assignment Form
                Button(action: {
                    showingAddAssignmentForm.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 65))  // Increase icon size here (e.g., 40)
                        .foregroundColor(Color(hex: "#66b8a0"))  // Icon color to #66b8a0
                }
                .padding()
                .background(Color.white)  // White button background
                .clipShape(Circle())  // Make the button round
                .padding(.bottom, 20)
                
                .sheet(isPresented: $showingAddAssignmentForm) {
                    AddAssignmentForm()
                }
            }
        }
    }
    
    // Helper function to format the date
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    // Helper function to format the time
    private func formatTime(_ time: Date?) -> String {
        guard let time = time else { return "Unknown Time" }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter.string(from: time)
    }
}

struct AddAssignmentForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var subject = ""
    @State private var description = ""  // Optional description
    @State private var deadlineDate = Date()
    @State private var deadlineTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Assignment Info")) {
                    TextField("Title", text: $title)
                    TextField("Subject", text: $subject)
                    
                    // Optional description
                    TextField("Description (Optional)", text: $description)
                }
                
                Section(header: Text("Deadline")) {
                    DatePicker("Select Deadline Date", selection: $deadlineDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                    
                    DatePicker("Select Deadline Time", selection: $deadlineTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                }
            }
            .navigationTitle("Add New Assignment")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Add") {
                addAssignment()
            })
        }
    }
    
    private func addAssignment() {
        // Ensure title and subject are not empty
        guard !title.isEmpty, !subject.isEmpty else { return }
        
        // Create a new Assignment entity and set the values
        let newAssignment = Assignment(context: viewContext)
        newAssignment.id = UUID()
        newAssignment.title = title
        newAssignment.subject = subject
        newAssignment.assignmentDescription = description.isEmpty ? "No description" : description  // Default to "No description" if empty
        newAssignment.deadlineDate = deadlineDate
        newAssignment.deadlineTime = deadlineTime
        
        // Save the context
        do {
            try viewContext.save()
            dismiss()
        } catch {
            // Handle error (e.g., show an alert)
            print("Error saving assignment: \(error.localizedDescription)")
        }
    }
}
