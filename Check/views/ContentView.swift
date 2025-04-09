import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingAddHabit = false
    @State private var selectedTimeframe: Timeframe = .weekly
    
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

enum Timeframe: String, CaseIterable, Identifiable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"
    
    var id: String { self.rawValue }
}

#Preview {
    ContentView()
}
