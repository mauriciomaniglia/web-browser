import Foundation

public final class Helpers {
    public static func loadJsonContent(filename: String) -> String? {
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else { return nil }

        do {
            let data = try Data(contentsOf: url)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension Date {
    func relativeTimeString() -> String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(self) {
            return "Today, \(formattedTime())"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday, \(formattedTime())"
        } else if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
                  self >= startOfWeek {
            let weekday = calendar.component(.weekday, from: self)
            let weekdayString = calendar.weekdaySymbols[weekday - 1]
            return "\(weekdayString), \(formattedTime())"
        } else {
            return formattedDateAndTime()
        }
    }

    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    private func formattedDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
