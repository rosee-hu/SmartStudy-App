import SwiftUI
import CoreData

struct ExamsView: View {
    @FetchRequest(
        entity: Exam.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exam.date, ascending: true)]
    ) var exams: FetchedResults<Exam>  // Fetched results from Core Data
    
    @State private var showingAddExamForm = false  // Show Add Exam form
    
    var body: some View {
        NavigationView {
            VStack {
                // Title
                Text("Upcoming Exams")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Check if there are any exams scheduled
                if exams.isEmpty {
                    Text("No exams scheduled yet. Tap the '+' button to add a new exam.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // List of Exams
                    List(exams, id: \.self) { exam in
                        VStack(alignment: .leading) {
                            Text(exam.title ?? "Untitled")
                                .font(.headline)
                            Text(exam.subject ?? "No subject")
                                .font(.subheadline)
                            Text("Date: \(exam.date?.formatted(.dateTime.day().month().year()) ?? "N/A") at \(exam.time?.formatted(.dateTime.hour().minute()) ?? "N/A")")
                                .font(.subheadline)
                            Text(exam.building ?? "No building")
                                .font(.subheadline)
                            Text(exam.descriptionText ?? "No description")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Spacer to push the "+" button to the bottom
                Spacer()
                
                // "+" Button to show Add Exam Form
                Button(action: {
                    showingAddExamForm.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 65))  // Increase icon size here (e.g., 40)
                        .foregroundColor(Color(hex: "#66b8a0"))  // Icon color to #66b8a0
                }
                .padding()
                .background(Color.white)  // White button background
                .clipShape(Circle())  // Make the button round
                .padding(.bottom, 20)
                
                .sheet(isPresented: $showingAddExamForm) {
                    AddExamForm()
                }
            }
        }
    }
}
