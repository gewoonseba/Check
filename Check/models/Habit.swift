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
        return completions.contains { completion in
            let calendar = Calendar.current
            return calendar.isDate(completion.date, equalTo: date, toGranularity: .day)
        }
    }

    func isCompleted(onWeek week: Int, ofYear year: Int) -> Bool {
        return completions.contains { completion in
            let calendar = Calendar.current
            return calendar.component(.weekOfYear, from: completion.date) == week &&
                   calendar.component(.year, from: completion.date) == year
        }
    }

    func isCompleted(onMonth month: Int, ofYear year: Int) -> Bool {
        return completions.contains { completion in
            let calendar = Calendar.current
            return calendar.component(.month, from: completion.date) == month &&
                   calendar.component(.year, from: completion.date) == year
        }
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
