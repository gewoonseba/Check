import SwiftData
import SwiftUI

struct HabitDetailView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @Bindable var habit: Habit
  @State private var showingEditSheet = false
  @State private var selectedDate = Date()

  var body: some View {
    NavigationStack {
      VStack {
        ScrollView {
          let year = Calendar.current.component(.year, from: Date())
          let calendar = Calendar.current
          let firstDayOfYear =
            calendar.date(from: DateComponents(year: year, month: 1, day: 1)) ?? Date()
          let lastDayOfYear =
            calendar.date(from: DateComponents(year: year, month: 12, day: 31)) ?? Date()
          Text(String(year))
            .font(.title)
            .padding()

          HStack {
            TimeGridView(habit: habit, selectedDate: selectedDate, year: year)
            VerticalDateScrubber(
              startDate: firstDayOfYear, endDate: lastDayOfYear, selectedDate: $selectedDate)
          }
        }

        // Sticky section at the bottom
        VStack {

          Button {
            habit.toggleCompletion(on: selectedDate)
          } label: {
            Text(habit.isCompleted(on: selectedDate) ? "Mark as Not Done" : "Mark as Done")
              .frame(maxWidth: .infinity)  // Make label take full width for consistent button size
          }
          .buttonStyle(.borderedProminent)
          .padding()
        }
        .padding()
        .frame(maxWidth: .infinity)
      }
      .navigationTitle(habit.name)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Edit") {
            showingEditSheet = true
          }
        }
      }
      .sheet(isPresented: $showingEditSheet) {
        EditHabitView(habit: habit)
      }
    }
  }
}

struct EditHabitView: View {
  @Environment(\.dismiss) private var dismiss
  @Bindable var habit: Habit

  var body: some View {
    NavigationStack {
      Form {
        Section("Habit Details") {
          TextField("Habit Name", text: $habit.name)

          Picker("Frequency", selection: $habit.frequency) {
            ForEach(FrequencyType.allCases, id: \.self) { frequency in
              Text(frequency.rawValue).tag(frequency)
            }
          }
          .pickerStyle(.menu)
        }
      }
      .navigationTitle("Edit Habit")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }

        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            dismiss()
          }
          .disabled(habit.name.isEmpty)
        }
      }
    }
  }
}
