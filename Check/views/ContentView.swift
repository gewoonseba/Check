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
    ContentView()
}
