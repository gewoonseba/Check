import SwiftUI

/// A minimal vertical scrubber for selecting a date, with today at the bottom.
struct VerticalDateScrubber: View {
  let startDate: Date
  var endDate: Date = .init()
  @Binding var selectedDate: Date

  @State private var dragOffset: CGFloat = 0

  var body: some View {
    GeometryReader { geometry in

      let trackHeight = geometry.size.height
      let trackTop = CGFloat(0)
      let totalDays = CGFloat(Calendar.current.numberOfDaysBetween(startDate, endDate) ?? 1)
      let knobDiameter: CGFloat = 32

      HStack {
        // Labels
        VStack {
          Text(formattedDate(startDate))
            .font(.caption)
            .foregroundColor(.gray)

          Spacer()

          Text(formattedDate(endDate))
            .font(.caption)
            .foregroundColor(.gray)
        }

        // Slider
        ZStack(alignment: .top) {
          // Track
          RoundedRectangle(cornerRadius: geometry.size.width / 2)
            .fill(Color(.systemGray5))
            .frame(width: 12, height: trackHeight)

          // Knob
          Circle()
            .fill(Color.white)
            .shadow(radius: 4)
            .frame(width: knobDiameter, height: knobDiameter)
            .offset(y: knobYOffest(for: selectedDate, trackHeight: trackHeight))
            .gesture(
              DragGesture()
                .onChanged { value in
                  // Clamp drag to track
                  let y = min(max(value.location.y - trackTop, 0), trackHeight)
                  let progress = y / trackHeight
                  let day = Int(round(progress * totalDays))
                  if let newDate = Calendar.current.date(byAdding: .day, value: day, to: startDate)
                  {
                    selectedDate = newDate
                  }
                }
            )
            .alignmentGuide(.top) { d in d.height / 2 }

          // Floating label
          //   HStack {
          //     RoundedRectangle(cornerRadius: 6)
          //       .fill(Color.white)
          //       .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
          //       .overlay(
          //         Text(formattedDate(selectedDate))
          //           .font(.system(size: 16, weight: .semibold))
          //           .foregroundColor(.black)
          //           .padding(.horizontal, 12)
          //       )
          //     Spacer()
          //   }
          //   .offset(x: -44, y: knobY(for: selectedDate, trackHeight: trackHeight) - trackHeight / 2)
          //   .animation(.easeInOut, value: selectedDate)
        }
      }
      .overlay(
        Text(formattedDate(selectedDate))
          .font(.caption)
          .foregroundColor(.gray)
          .padding(.horizontal)
      )
    }
  }

  // Helper for formatting dates
  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }

  // Helper: calculate knob Y offset for a given date
  // startDate == offest 0
  // endDate == maximum offset
  private func knobYOffest(for date: Date, trackHeight: CGFloat) -> CGFloat {
    let totalDays = CGFloat(Calendar.current.numberOfDaysBetween(startDate, endDate) ?? 1)
    let selectedDays = CGFloat(Calendar.current.numberOfDaysBetween(startDate, date) ?? 0)
    return (selectedDays / totalDays) * trackHeight
  }
}

#Preview {
  @Previewable @State var date = Calendar.current.startOfDay(
    for: Date(timeIntervalSince1970: 1_747_206_000))  // 2025-05-14
  let endDate = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: 1_747_206_000))  // 2025-05-14
  let startDate = Calendar.current.date(byAdding: .day, value: -60, to: endDate)!
  return VerticalDateScrubber(startDate: startDate, endDate: endDate, selectedDate: $date)
}
