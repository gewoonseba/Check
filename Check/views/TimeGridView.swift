import SwiftUI

struct TimeGridView: View {
    let frequency: FrequencyType // Use the enum from your Habit model
    let squareSize: CGFloat = 15.0
    let spacing: CGFloat = 2.0

    /// The total number of items (squares) for this frequency in a year.
    private var totalCount: Int {
        switch frequency {
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
        switch frequency {
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
                // Represent each item as a simple colored square
                Rectangle()
                    .fill(.gray.opacity(0.3)) // Placeholder color
                    .frame(width: squareSize, height: squareSize)
                    .border(.gray.opacity(0.5), width: 0.5) // Optional border
                    // Example: Add a simple tooltip showing the index + 1
                    .help("Item \(itemIndex + 1)")
            }
        }
        .padding()
    }
}
