//
//  AddExamForm.swift
//  SmartStudy
//
//  Created by rose Hu on 10/05/2025.
//

import SwiftUI
import CoreData

struct AddExamForm: View {
    @Environment(\.managedObjectContext) private var viewContext  // Managed Object Context
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
                Section(header: Text("Exam Info")) {
                    TextField("Title", text: $title)
                    TextField("Subject", text: $subject)
                    TextField("Building", text: $building)
                    
                    // Optional description
                    TextField("Description (Optional)", text: $description)
                }
                
                Section(header: Text("Exam Date and Time")) {
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                    
                    DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                }
            }
            .navigationTitle("Add New Exam")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Add") {
                addExam()
            })
        }
    }
    
    private func addExam() {
        // Ensure title, subject, and building are not empty
        guard !title.isEmpty, !subject.isEmpty, !building.isEmpty else { return }
        
        // Create a new Exam entity and set the values
        let newExam = Exam(context: viewContext)
        newExam.id = UUID()  // Assign a UUID to the ID field
        newExam.title = title
        newExam.subject = subject
        newExam.descriptionText = description.isEmpty ? "No description" : description  // Default to "No description" if empty
        newExam.date = date
        newExam.time = time
        newExam.building = building
        
        // Save the context
        do {
            try viewContext.save()
            dismiss()
        } catch {
            // Handle error (e.g., show an alert)
            print("Error saving exam: \(error.localizedDescription)")
        }
    }

}
