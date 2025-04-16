import XCTest
@testable import Check
import SwiftData

final class HabitTests: XCTestCase {
    func testCompletionOnDay() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .daily)
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        // When
        habit.completions.append(HabitCompletion(date: today, habit: habit))
        
        // Then
        XCTAssertTrue(habit.isCompleted(on: today), "Habit should be completed for today")
        XCTAssertFalse(habit.isCompleted(on: yesterday), "Habit should not be completed for yesterday")
        XCTAssertFalse(habit.isCompleted(on: tomorrow), "Habit should not be completed for tomorrow")
    }
    
    func testCompletionOnWeek() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .weekly)

        let calendar = Calendar.current

        // April 16, 2025 is in week 16 of 2025
        let dateComponents = DateComponents(year: 2025, month: 4, day: 16)
        let habitDate = calendar.date(from: dateComponents)!

        
        // When
        habit.completions.append(HabitCompletion(date: habitDate, habit: habit))
        
        // Then
        XCTAssertTrue(habit.isCompleted(onWeek: 16, ofYear: 2025), "Habit should be completed for week 16 of 2025")
        XCTAssertFalse(habit.isCompleted(onWeek: 17, ofYear: 2025), "Habit should not be completed for week 17 of 2025")
        XCTAssertFalse(habit.isCompleted(onWeek: 16, ofYear: 2024), "Habit should not be completed for week 17 of 2025")
    }
    
    func testMonthlyHabitCompletion() {
        /// Given
        let habit = Habit(name: "Test Habit", frequency: .weekly)

        let calendar = Calendar.current

        // April 16, 2025 is in month 4 of 2025
        let dateComponents = DateComponents(year: 2025, month: 4, day: 16)
        let habitDate = calendar.date(from: dateComponents)!

        
        // When
        habit.completions.append(HabitCompletion(date: habitDate, habit: habit))
        
        // Then
        XCTAssertTrue(habit.isCompleted(onMonth: 4, ofYear: 2025), "Habit should be completed for month 4 of 2025")
        XCTAssertFalse(habit.isCompleted(onMonth: 3, ofYear: 2025), "Habit should not be completed for month 3 of 2025")
        XCTAssertFalse(habit.isCompleted(onMonth: 4, ofYear: 2024), "Habit should not be completed for month 4 of 2024")
    }
    
    func testToggleCompletionAddingCompletion() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .daily)
        let today = Date()
        
        // When
        XCTAssertFalse(habit.isCompleted(on: today), "Habit should not be completed initially")
        habit.toggleCompletion(on: today)
        
        // Then
        XCTAssertTrue(habit.isCompleted(on: today), "Habit should be completed after toggling")
        XCTAssertEqual(habit.completions.count, 1, "Should have exactly one completion")
    }
    
    func testToggleCompletionRemovingCompletion() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .daily)
        let today = Date()
        habit.completions.append(HabitCompletion(date: today, habit: habit)) // Add completion
        XCTAssertTrue(habit.isCompleted(on: today), "Habit should be completed after first toggle")
        
        // When
        habit.toggleCompletion(on: today) // Remove completion
        
        // Then
        XCTAssertFalse(habit.isCompleted(on: today), "Habit should not be completed after second toggle")
        XCTAssertEqual(habit.completions.count, 0, "Should have no completions")
    }
    
    func testToggleCompletionMultipleDates() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .daily)
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        // When
        habit.toggleCompletion(on: today)
        habit.toggleCompletion(on: tomorrow)
        
        // Then
        XCTAssertTrue(habit.isCompleted(on: today), "Today's habit should be completed")
        XCTAssertTrue(habit.isCompleted(on: tomorrow), "Tomorrow's habit should be completed")
        XCTAssertEqual(habit.completions.count, 2, "Should have two completions")
        
        // When toggling today's completion off
        habit.toggleCompletion(on: today)
        
        // Then
        XCTAssertFalse(habit.isCompleted(on: today), "Today's habit should not be completed")
        XCTAssertTrue(habit.isCompleted(on: tomorrow), "Tomorrow's habit should still be completed")
        XCTAssertEqual(habit.completions.count, 1, "Should have one completion")
    }

    func testToggleCompletionForMultipleCompletionsOnSameDay() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .daily)
        let today = Date()
        habit.completions.append(HabitCompletion(date: today, habit: habit)) // Add completion
        habit.completions.append(HabitCompletion(date: today, habit: habit)) // Add completion

        // When
        habit.toggleCompletion(on: today)

        // Then
        XCTAssertFalse(habit.isCompleted(on: today), "Habit should not be completed after toggling")
        XCTAssertEqual(habit.completions.count, 0, "Should have no completions")

        
    }
} 