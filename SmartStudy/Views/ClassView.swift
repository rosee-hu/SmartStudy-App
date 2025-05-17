//
//  ClassView.swift
//  SmartStudyApp
//
//  Created by rose Hu on 10/05/2025.
//

import SwiftUI

struct ClassView: View {
    @State private var classes = [
        ClassInfo(time: "9:00 AM", subject: "Math", location: "Room 101"),
        ClassInfo(time: "11:00 AM", subject: "English", location: "Room 102"),
        ClassInfo(time: "1:00 PM", subject: "Science", location: "Room 103")
    ]
    
    @State private var newClassTime = ""
    @State private var newClassSubject = ""
    @State private var newClassLocation = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Title and Intro Text
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Classes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Manage and view all your scheduled classes below.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding([.top, .horizontal])
                
                // List of Classes
                List {
                    ForEach(classes) { classInfo in
                        ClassRow(classInfo: classInfo)
                            .padding(.vertical, 5)
                    }
                    .onDelete(perform: deleteClass)
                }
                .padding(.top)
                
                // Add New Class Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Add New Class")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    TextField("Class Time", text: $newClassTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    
                    TextField("Class Subject", text: $newClassSubject)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 5)
                    
                    TextField("Class Location", text: $newClassLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 20)
                    
                    Button(action: addClass) {
                        Text("Add Class")
                            .font(.body)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding([.horizontal, .bottom])
                
                Spacer()
            }
            .navigationBarTitle("Class Schedule", displayMode: .inline)
        }
    }
    
    // Add a new class to the list
    func addClass() {
        let newClass = ClassInfo(time: newClassTime, subject: newClassSubject, location: newClassLocation)
        classes.append(newClass)
        
        // Clear input fields after adding
        newClassTime = ""
        newClassSubject = ""
        newClassLocation = ""
    }
    
    // Delete class from the list
    func deleteClass(at offsets: IndexSet) {
        classes.remove(atOffsets: offsets)
    }
}

struct ClassInfo: Identifiable {
    let id = UUID()
    let time: String
    let subject: String
    let location: String
}

struct ClassRow: View {
    let classInfo: ClassInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(classInfo.time)
                    .font(.headline)
                Text(classInfo.subject)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(classInfo.location)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct ClassView_Previews: PreviewProvider {
    static var previews: some View {
        ClassView()
    }
}
