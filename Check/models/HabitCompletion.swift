import Foundation
import SwiftData

@Model
class HabitCompletion {
    var date: Date
    var habit: Habit?
    
    init(date: Date = Date(), habit: Habit? = nil) {
        self.date = date
        self.habit = habit
    }
}
