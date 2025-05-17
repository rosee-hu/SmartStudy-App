import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Add sample Assignments
        for i in 0..<5 {
            let newAssignment = Assignment(context: viewContext)
            newAssignment.title = "Assignment \(i + 1)"
            newAssignment.deadlineDate = Calendar.current.date(byAdding: .day, value: i * 2, to: Date())  // due in 2, 4, 6, etc. days
        }
        
        // Add sample Exams
        for i in 0..<3 {
            let newExam = Exam(context: viewContext)
            newExam.title = "Exam \(i + 1)"
            newExam.date = Calendar.current.date(byAdding: .day, value: 10 + i * 5, to: Date())  // Exam in 10, 15, 20, etc. days
        }
        
        do {
            try viewContext.save()
        } catch {
            // Handle error properly
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SmartStudy")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle error properly
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
