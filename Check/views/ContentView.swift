import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingAddHabit = false
    @State private var selectedTimeframe: Timeframe = .weekly
    
    var body: some View {
        NavigationStack {
            VStack {
                TimeframeSelector(selectedTimeframe: $selectedTimeframe)
                
                TabView {
                    HabitListView()
                        .tabItem {
                            Label("Habits", systemImage: "list.bullet")
                        }
                    
                    StatsView(timeframe: selectedTimeframe)
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar")
                        }
                }
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

struct TimeframeSelector: View {
    @Binding var selectedTimeframe: Timeframe
    
    var body: some View {
        Picker("Timeframe", selection: $selectedTimeframe) {
            ForEach(Timeframe.allCases) { timeframe in
                Text(timeframe.rawValue).tag(timeframe)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
