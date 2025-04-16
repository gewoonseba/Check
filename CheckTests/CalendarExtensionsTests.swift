import XCTest
import Foundation // Required for Calendar
@testable import Check // Import your main app module to access the extension

class CalendarExtensionTests: XCTestCase {

    // Use a consistent calendar for tests to avoid locale/setting variations
    // Gregorian is standard for these leap year/week calculations.
    let calendar = Calendar.current

    // MARK: - numberOfDays

    func testNumberOfDays_LeapYear_ShouldReturn366() {
        // Arrange: A known leap year
        let leapYear = 2024

        // Act
        let days = calendar.numberOfDays(in: leapYear)

        // Assert
        XCTAssertEqual(days, 366, "A leap year (\(leapYear)) should have 366 days.")
    }

    func testNumberOfDays_CommonYear_ShouldReturn365() {
        // Arrange: A known common year
        let commonYear = 2023

        // Act
        let days = calendar.numberOfDays(in: commonYear)

        // Assert
        XCTAssertEqual(days, 365, "A common year (\(commonYear)) should have 365 days.")
    }

    func testNumberOfDays_CenturyLeapYear_ShouldReturn366() {
        // Arrange: A century leap year
        let leapYear = 2000

        // Act
        let days = calendar.numberOfDays(in: leapYear)

        // Assert
        XCTAssertEqual(days, 366, "A century leap year (\(leapYear)) should have 366 days.")
    }

    func testNumberOfDays_CenturyCommonYear_ShouldReturn365() {
        // Arrange: A century common year
        let commonYear = 1900

        // Act
        let days = calendar.numberOfDays(in: commonYear)

        // Assert
        XCTAssertEqual(days, 365, "A century common year (\(commonYear)) should have 365 days.")
    }

    // MARK: - numberOfWeeks

    // Note: Week count can depend on the calendar's firstWeekday and minimumDaysInFirstWeek.
    // The range(of: .weekOfYear, ...) method inherently uses these calendar properties.
    // We test against known results for the Gregorian calendar standard.

    func testNumberOfWeeks_YearWith52Weeks_ShouldReturn52() {
        // Arrange: Years known to typically have 52 weeks in Gregorian/ISO 8601
        let years = [2021, 2022, 2023, 2024, 2025] // 2024 is leap but ends Sunday -> 52 weeks

        // Act & Assert
        for year in years {
            let weeks = calendar.numberOfWeeks(in: year)
            XCTAssertEqual(weeks, 52, "Year \(year) should have 52 weeks.")
        }
    }

    func testNumberOfWeeks_YearWith53Weeks_ShouldReturn53() {
        // Arrange: Years known to typically have 53 weeks in Gregorian/ISO 8601
        // Examples:
        // - Common year starting on Thursday (e.g., 2015, 2026)
        // - Leap year starting on Wednesday or Thursday (e.g., 2020 starts Wed)
        let years = [2020, 2026, 2032]

        // Act & Assert
        for year in years {
            let weeks = calendar.numberOfWeeks(in: year)
            XCTAssertEqual(weeks, 53, "Year \(year) should have 53 weeks.")
        }
    }
}
