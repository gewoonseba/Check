import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            VStack {

                HabitListView()
                
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)

    // Sample Data Generation
    let calendar = Calendar.current
    let today = Date()

    // Habits
    let habit1 = Habit(name: "Read Daily", frequency: .daily, createdAt: calendar.date(byAdding: .month, value: -2, to: today)!)
    let habit2 = Habit(name: "Workout Weekly", frequency: .weekly, createdAt: calendar.date(byAdding: .year, value: -1, to: today)!)
    let habit3 = Habit(name: "Monthly Review", frequency: .monthly, createdAt: calendar.date(byAdding: .year, value: -2, to: today)!)
    let habit4 = Habit(name: "Drink Water Daily", frequency: .daily, createdAt: today)
    let habit5 = Habit(name: "Meditate", frequency: .daily, createdAt: calendar.date(byAdding: .day, value: -10, to: today)!)


    // Completions (spread over years)
    for i in 0..<30 { // Daily habit completions (past month)
        if Bool.random() {
            habit1.completions.append(HabitCompletion(date: calendar.date(byAdding: .day, value: -i, to: today)!, habit: habit1))
        }
        if Bool.random() {
             habit5.completions.append(HabitCompletion(date: calendar.date(byAdding: .day, value: -i, to: today)!, habit: habit5))
        }
    }
    
    for i in 0..<104 { // Weekly habit completions (past 2 years)
        if Bool.random() {
             habit2.completions.append(HabitCompletion(date: calendar.date(byAdding: .weekOfYear, value: -i, to: today)!, habit: habit2))
        }
    }

    for i in 0..<36 { // Monthly habit completions (past 3 years)
        if Bool.random() {
             habit3.completions.append(HabitCompletion(date: calendar.date(byAdding: .month, value: -i, to: today)!, habit: habit3))
        }
    }
    
    // Add some more recent water completions
    for i in 0..<5 {
        habit4.completions.append(HabitCompletion(date: calendar.date(byAdding: .day, value: -i, to: today)!, habit: habit4))
    }


    // Add to container
    container.mainContext.insert(habit1)
    container.mainContext.insert(habit2)
    container.mainContext.insert(habit3)
    container.mainContext.insert(habit4)
    container.mainContext.insert(habit5)
    
    // Note: HabitCompletions are automatically added via the relationship

    return ContentView()
        .modelContainer(container)
}
