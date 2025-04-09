import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query private var habits: [Habit]
    let timeframe: Timeframe
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Habit Completion")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if habits.isEmpty {
                        ContentUnavailableView {
                            Label("No Data", systemImage: "chart.bar.xaxis")
                        } description: {
                            Text("Add habits to see statistics")
                        }
                    } else {
                        CompletionChart(habits: habits, timeframe: timeframe)
                            .frame(height: 200)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        HabitStreaksList(habits: habits)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
        }
    }
}

struct CompletionChart: View {
    let habits: [Habit]
    let timeframe: Timeframe
    
    @State private var chartData: [ChartData] = []
    
    var body: some View {
        Chart {
            ForEach(chartData) { data in
                BarMark(
                    x: .value("Date", data.date, unit: .day),
                    y: .value("Completed", data.completedCount)
                )
                .foregroundStyle(Color.green.gradient)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: getStrideCount())) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.day())
                    }
                }
            }
        }
        .onAppear {
            generateChartData()
        }
        .onChange(of: timeframe) {
            generateChartData()
        }
        .onChange(of: habits) {
            generateChartData()
        }
    }
    
    private func getStrideCount() -> Int {
        switch timeframe {
        case .weekly: return 1
        case .monthly: return 7
        case .quarterly: return 14
        case .yearly: return 30
        }
    }
    
    private func generateChartData() {
        let calendar = Calendar.current
        let today = Date()
        
        var dateComponents = DateComponents()
        var startDate: Date
        var numberOfDays: Int
        
        switch timeframe {
        case .weekly:
            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            numberOfDays = 7
            
        case .monthly:
            dateComponents.day = 1
            dateComponents.month = calendar.component(.month, from: today)
            dateComponents.year = calendar.component(.year, from: today)
            startDate = calendar.date(from: dateComponents)!
            
            let range = calendar.range(of: .day, in: .month, for: startDate)!
            numberOfDays = range.count
            
        case .quarterly:
            let month = calendar.component(.month, from: today)
            let quarterStartMonth = ((month - 1) / 3) * 3 + 1
            
            dateComponents.day = 1
            dateComponents.month = quarterStartMonth
            dateComponents.year = calendar.component(.year, from: today)
            startDate = calendar.date(from: dateComponents)!
            numberOfDays = 90 // Approximation
            
        case .yearly:
            dateComponents.day = 1
            dateComponents.month = 1
            dateComponents.year = calendar.component(.year, from: today)
            startDate = calendar.date(from: dateComponents)!
            numberOfDays = 365 // Approximation
        }
        
        var newChartData: [ChartData] = []
        
        for dayOffset in 0..<numberOfDays {
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate)!
            let completedCount = habits.filter { $0.isCompleted(on: date) }.count
            
            newChartData.append(ChartData(date: date, completedCount: completedCount))
        }
        
        chartData = newChartData
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let completedCount: Int
}

struct HabitStreaksList: View {
    let habits: [Habit]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Streaks")
                .font(.headline)
            
            ForEach(habits) { habit in
                HStack {
                    Text(habit.name)
                    Spacer()
                    Text("\(calculateStreak(for: habit)) days")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private func calculateStreak(for habit: Habit) -> Int {
        let calendar = Calendar.current
        let today = Date()
        var streak = 0
        
        for dayOffset in 0..<100 { // Check up to 100 days back
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            
            if habit.isCompleted(on: date) {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
}
