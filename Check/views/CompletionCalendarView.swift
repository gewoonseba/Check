import SwiftUI
import SwiftData

struct CompletionCalendarView: View {
    let habit: Habit
    let timeframe: Timeframe
    
    @State private var dates: [Date] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                ForEach(dates, id: \.self) { date in
                    CalendarCell(date: date, isCompleted: habit.isCompleted(on: date))
                }
            }
        }
        .onAppear {
            generateDates()
        }
        .onChange(of: timeframe) {
            generateDates()
        }
    }
    
    private func generateDates() {
        let calendar = Calendar.current
        let today = Date()
        
        var dateComponents = DateComponents()
        var startDate: Date
        
        switch timeframe {
        case .weekly:
            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            dates = (0..<7).map { calendar.date(byAdding: .day, value: $0, to: startDate)! }
            
        case .monthly:
            dateComponents.day = 1
            dateComponents.month = calendar.component(.month, from: today)
            dateComponents.year = calendar.component(.year, from: today)
            startDate = calendar.date(from: dateComponents)!
            
            let range = calendar.range(of: .day, in: .month, for: startDate)!
            dates = range.map { calendar.date(byAdding: .day, value: $0 - 1, to: startDate)! }
            
        case .quarterly:
            let month = calendar.component(.month, from: today)
            let quarterStartMonth = ((month - 1) / 3) * 3 + 1
            
            dateComponents.day = 1
            dateComponents.month = quarterStartMonth
            dateComponents.year = calendar.component(.year, from: today)
            startDate = calendar.date(from: dateComponents)!
            
            var currentDate = startDate
            var quarterDates: [Date] = []
            
            for _ in 0..<3 {
                let monthRange = calendar.range(of: .day, in: .month, for: currentDate)!
                let monthDates = monthRange.map { calendar.date(byAdding: .day, value: $0 - 1, to: currentDate)! }
                quarterDates.append(contentsOf: monthDates)
                
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            dates = quarterDates
            
        case .yearly:
            dateComponents.day = 1
            dateComponents.month = 1
            dateComponents.year = calendar.component(.year, from: today)
            startDate = calendar.date(from: dateComponents)!
            
            var yearDates: [Date] = []
            var currentDate = startDate
            
            for _ in 0..<12 {
                let monthRange = calendar.range(of: .day, in: .month, for: currentDate)!
                let monthDates = monthRange.map { calendar.date(byAdding: .day, value: $0 - 1, to: currentDate)! }
                yearDates.append(contentsOf: monthDates)
                
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            dates = yearDates
        }
    }
}

struct CalendarCell: View {
    let date: Date
    let isCompleted: Bool
    
    var body: some View {
        VStack {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.caption)
            
            Circle()
                .fill(isCompleted ? Color.green : Color.gray.opacity(0.3))
                .frame(width: 24, height: 24)
        }
        .padding(4)
        .background(
            isToday(date: date) ? 
                RoundedRectangle(cornerRadius: 4)
                .stroke(Color.blue, lineWidth: 1) : nil
        )
    }
    
    private func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}
