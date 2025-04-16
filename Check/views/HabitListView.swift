import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    @State private var selectedHabit: Habit?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    NavigationLink {
                        HabitDetailView(habit: habit)
                    } label: {
                        HabitRow(habit: habit)
                    }
                }
                .onDelete(perform: deleteHabits)
            }
            .listStyle(.plain)
            .navigationTitle("Habits")
            .overlay {
                if habits.isEmpty {
                    ContentUnavailableView {
                        Label("No Habits", systemImage: "list.bullet.clipboard")
                    } description: {
                        Text("Add a habit to get started")
                    }
                }
            }
        }
    }
    
    private func deleteHabits(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(habits[index])
        }
    }
}

struct HabitRow: View {
    @Environment(\.modelContext) private var modelContext
    let habit: Habit
    @State private var isCompleted = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                Text(habit.frequency.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: toggleCompletion) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .onAppear {
            isCompleted = habit.isCompleted(on: Date())
        }
    }
    
    private func toggleCompletion() {
        habit.toggleCompletion(on: Date())
        isCompleted.toggle()
    }
}
