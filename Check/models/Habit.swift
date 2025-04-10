import Foundation
import SwiftData

@Model
class Habit {
    var name: String
    var frequency: FrequencyType
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var completions: [HabitCompletion] = []
    
    init(name: String, frequency: FrequencyType, createdAt: Date = Date()) {
        self.name = name
        self.frequency = frequency
        self.createdAt = createdAt
    }
    
    func isCompleted(on date: Date) -> Bool {
        let calendar = Calendar.current
        return completions.contains { completion in
            switch frequency {
            case .daily:
                return calendar.isDate(completion.date, inSameDayAs: date)
            case .weekly:
                return calendar.isDate(completion.date, equalTo: date, toGranularity: .weekOfYear)
            case .monthly:
                return calendar.isDate(completion.date, equalTo: date, toGranularity: .month)
            }
        }
    }

    func isCompleted(onWeek week: Int, ofYear year: Int) -> Bool {
        return false
    }

    func isCompleted(onMonth month: Int, ofYear year: Int) -> Bool {
        return false
    }
    
    func toggleCompletion(on date: Date) {
        if completions.contains(where: { $0.date == date }) {
            // Remove all completions for this exact date
            completions.removeAll(where: { $0.date == date })
        } else {
            // Add completion for today
            let completion = HabitCompletion(date: date, habit: self)
            completions.append(completion)
        }
    }
}

enum FrequencyType: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}
