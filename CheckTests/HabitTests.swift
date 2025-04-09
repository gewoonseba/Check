import XCTest
@testable import Check
import SwiftData

final class HabitTests: XCTestCase {
    func testDailyHabitCompletion() {
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
    
    func testWeeklyHabitCompletion() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .weekly)
        let today = Date()
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: today)!
        let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: today)!
        let laterThisWeek = Calendar.current.date(byAdding: .day, value: 2, to: today)!
        
        // When
        habit.completions.append(HabitCompletion(date: today, habit: habit))
        
        // Then
        XCTAssertTrue(habit.isCompleted(on: today), "Habit should be completed for the current week")
        XCTAssertTrue(habit.isCompleted(on: laterThisWeek), "Habit should be completed for later this week")
        XCTAssertFalse(habit.isCompleted(on: lastWeek), "Habit should not be completed for last week")
        XCTAssertFalse(habit.isCompleted(on: nextWeek), "Habit should not be completed for next week")
    }
    
    func testMonthlyHabitCompletion() {
        // Given
        let habit = Habit(name: "Test Habit", frequency: .monthly)
        let today = Date()
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        let laterThisMonth = Calendar.current.date(byAdding: .day, value: 15, to: today)!
        
        // When
        habit.completions.append(HabitCompletion(date: today, habit: habit))
        
        // Then
        XCTAssertTrue(habit.isCompleted(on: today), "Habit should be completed for the current month")
        XCTAssertTrue(habit.isCompleted(on: laterThisMonth), "Habit should be completed for later this month")
        XCTAssertFalse(habit.isCompleted(on: lastMonth), "Habit should not be completed for last month")
        XCTAssertFalse(habit.isCompleted(on: nextMonth), "Habit should not be completed for next month")
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