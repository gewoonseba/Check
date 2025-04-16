import SwiftUI

struct TimeGridView: View {
    let habit: Habit
    let selectedDate: Date
    let year: Int = Calendar.current.component(.year, from: Date())
    let squareSize: CGFloat = 15.0
    let spacing: CGFloat = 2.0

    /// Start of the year for date calculations.
    private var startOfYear: Date {
        Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
    }

    /// The total number of items (squares) for this frequency in a year.
    private var totalCount: Int {
        switch habit.frequency {
        case .daily:
            // Note: Still ignoring leap years for simplicity
            return 365
        case .weekly:
            // Standard number of weeks in a year
            return 52
        case .monthly:
            return 12
        }
    }

    /// The number of columns the grid should have for this frequency.
    private var columnsCount: Int {
        switch habit.frequency {
        case .daily:
            return 7 // 7 days a week
        case .weekly:
            return 13 // Approx 4 rows of 13 weeks = 52 weeks (1 quarter per row)
        case .monthly:
            return 3 // 3 months per row (1 quarter per row)
        }
    }

    /// Creates the grid column layout based on the frequency type.
    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.fixed(squareSize), spacing: spacing),
            count: columnsCount
        )
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            // Using 0..<totalCount to be more idiomatic with zero-based indexing
            ForEach(0..<totalCount, id: \.self) { itemIndex in
                let (isCompleted, isFuture, isSelected) = checkStatus(for: itemIndex) // Updated to return future status
                
                // Calculate color based on status
                let color: Color = {
                    if isFuture {
                        return Color.gray.opacity(0.1) // Very light gray for future items
                    } else {
                        return isCompleted ? Color.green : Color.gray.opacity(0.3) // Existing logic for past/present
                    }
                }() // Immediately invoke the closure to assign the color

                Rectangle()
                    .fill(color) // Use conditional color
                    .frame(width: squareSize, height: squareSize)
                    .border(isSelected ? Color.blue : Color.clear, width: 2)
                    .help(getHelpText(for: itemIndex)) // Updated help text logic
            }
        }
        .padding()
    }

    /// Checks if the habit is completed for the given item index and if it's in the future.
    private func checkStatus(for itemIndex: Int) -> (isCompleted: Bool, isFuture: Bool, isSelected: Bool) {
        let calendar = Calendar.current
        let now = Date()

        switch habit.frequency {
        case .daily:
            guard let date = calendar.date(byAdding: .day, value: itemIndex, to: startOfYear) else {
                return (false, false, false) // Default if date calculation fails
            }
            let isFuture = calendar.compare(date, to: now, toGranularity: .day) == .orderedDescending
            let isCompleted = habit.isCompleted(on: date)
            let isSelected = calendar.compare(date, to: selectedDate, toGranularity: .day) == .orderedSame
            return (isCompleted, isFuture, isSelected)

        case .weekly:
            // weekOfYear component is 1-based
            let week = itemIndex + 1
            // Approximate the start date of the week for comparison
            guard let approxWeekStartDate = calendar.date(byAdding: .weekOfYear, value: itemIndex, to: startOfYear) else {
                 return (false, false, false)
            }
            let isFuture = calendar.compare(approxWeekStartDate, to: now, toGranularity: .weekOfYear) == .orderedDescending
            let isCompleted = habit.isCompleted(onWeek: week, ofYear: year)
            let isSelected = calendar.compare(approxWeekStartDate, to: selectedDate, toGranularity: .weekOfYear) == .orderedSame
            return (isCompleted, isFuture, isSelected)

        case .monthly:
            // month component is 1-based
            let month = itemIndex + 1
            guard let monthStartDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
                 return (false, false, false)
            }
            let isFuture = calendar.compare(monthStartDate, to: now, toGranularity: .month) == .orderedDescending
            let isCompleted = habit.isCompleted(onMonth: month, ofYear: year)
            let isSelected = calendar.compare(monthStartDate, to: selectedDate, toGranularity: .month) == .orderedSame
            return (isCompleted, isFuture, isSelected)
        }
    }

    /// Provides appropriate help text based on the frequency and item index.
    private func getHelpText(for itemIndex: Int) -> String {
        let calendar = Calendar.current
        switch habit.frequency {
        case .daily:
            guard let date = calendar.date(byAdding: .day, value: itemIndex, to: startOfYear) else {
                return "Day \(itemIndex + 1)"
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        case .weekly:
            return "Week \(itemIndex + 1)"
        case .monthly:
            // Use DateFormatter to get month name
            let month = itemIndex + 1
            guard let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
                return "Month \(month)"
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM" // Format for full month name
            return dateFormatter.string(from: date)
        }
    }
}
