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
          Text(String(year))
            .font(.title)
            .padding()

          TimeGridView(habit: habit, selectedDate: selectedDate, year: year)
        }

        // Sticky section at the bottom
        VStack {
          DatePicker(
            "Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date
          )
          .labelsHidden()  // Hide the label for a cleaner look
          .padding(.horizontal)

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
        .background(.bar)  // Or any other background to make it visually distinct
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
