import SwiftUI
import CoreData

// ClassDetails Struct to represent each class
struct ClassDetails: Identifiable {
    var id = UUID()
    var title: String
    var subject: String
    var description: String
    var date: String
    var time: String
    var building: String
}

struct ClassesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Class.date, ascending: true)],
        animation: .default)
    private var classes: FetchedResults<Class>
    
    @State private var showingAddClassForm = false  // Show Add Class form
    
    var body: some View {
        NavigationView {
            VStack {
                // Title
                Text("Scheduled Classes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Check if there are any classes scheduled
                if classes.isEmpty {
                    Text("No classes scheduled yet. Tap the '+' button to add a new class.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // List of Classes
                    List {
                        ForEach(classes) { classInfo in
                            VStack(alignment: .leading) {
                                Text(classInfo.title ?? "No title")
                                    .font(.headline)
                                Text(classInfo.subject ?? "No subject")
                                    .font(.subheadline)
                                Text(classInfo.dateFormatted)
                                    .font(.subheadline)
                                Text(classInfo.timeFormatted)
                                    .font(.subheadline)
                                Text(classInfo.building ?? "No building")
                                    .font(.subheadline)
                                Text(classInfo.classDesc ?? "No description")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        .onDelete(perform: deleteClasses)
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Spacer to push the "+" button upwards and prevent it from being under the navigation bar
                Spacer()
                
                // "+" Button to show Add Class Form
                Button(action: {
                    showingAddClassForm.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 65))  // Increase icon size here (e.g., 40)
                        .foregroundColor(Color(hex: "#66b8a0"))  // Icon color to #66b8a0
                }
                .padding()
                .background(Color.white)  // White button background
                .clipShape(Circle())  // Make the button round
                .padding(.bottom, 100)  // Padding to adjust its distance from the bottom navigation bar
                .sheet(isPresented: $showingAddClassForm) {
                    AddClassForm()
                }
            }
            
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
    
    private func deleteClasses(at offsets: IndexSet) {
        for index in offsets {
            let classToDelete = classes[index]
            viewContext.delete(classToDelete)
        }
        
        do {
            try viewContext.save()
        } catch {
            // Handle the error
            print("Error deleting class: \(error.localizedDescription)")
        }
    }
}

struct AddClassForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var subject = ""
    @State private var description = ""  // Optional description
    @State private var date = Date()
    @State private var time = Date()
    @State private var building = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Class Info")) {
                    TextField("Title", text: $title)
                    TextField("Subject", text: $subject)
                    TextField("Building", text: $building)
                    
                    // Optional description
                    TextField("Description (Optional)", text: $description)
                }
                
                Section(header: Text("Class Date and Time")) {
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                    
                    DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                }
            }
            .navigationTitle("Add New Class")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Add") {
                addClass()
            })
        }
    }
    
    private func addClass() {
        // Ensure title, subject, and building are not empty
        guard !title.isEmpty, !subject.isEmpty, !building.isEmpty else { return }
        
        // Create a new Class entity and set the values
        let newClass = Class(context: viewContext)
        newClass.id = UUID()
        newClass.title = title
        newClass.subject = subject
        newClass.classDesc = description.isEmpty ? "No description" : description  // Default to "No description" if empty
        newClass.date = date
        newClass.time = time
        newClass.building = building
        
        // Save the context
        do {
            try viewContext.save()
            dismiss()
        } catch {
            // Handle error (e.g., show an alert)
            print("Error saving class: \(error.localizedDescription)")
        }
    }
}

extension Class {
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self.date ?? Date())
    }
    
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self.time ?? Date())
    }
}
