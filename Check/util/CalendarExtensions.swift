// In Calendar+Extensions.swift
import Foundation

extension Calendar {
    /// Calculates the number of days in a specific year.
    func numberOfDays(in year: Int) -> Int {
        guard let date = date(from: DateComponents(year: year, month: 1, day: 1)),
              let range = range(of: .day, in: .year, for: date) else {
            return 0
        }
        return range.count
    }

    /// Calculates the number of weeks in a specific year based on the ISO 8601 standard.
    /// December 28th is always in the last week of the year.
    func numberOfWeeks(in year: Int) -> Int {
        // Use December 28th, as it's guaranteed to be in the last week of the year according to ISO 8601.
        guard let date = date(from: DateComponents(year: year, month: 12, day: 28)) else {
            // Handle cases where the date might not be valid, though unlikely for Dec 28th.
            print("Error: Could not determine the date for December 28th, \(year).")
            return 0 // Or handle error appropriately
        }
        // Get the week number for Dec 28th.
        let weekNumber = component(.weekOfYear, from: date)
        return weekNumber
    }
}
