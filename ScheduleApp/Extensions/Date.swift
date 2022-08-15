//
//  Date.swift
//  ScheduleApp
//
//  Created by nader said on 22/07/2022.
//

import Foundation

extension Date
{    
    func daysInMonth() -> Range<Int>
    {
        Calendar.current.range(of: .day, in: .month, for: self)!
    }

    func firstDayOfTheMonth() -> Date
    {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!.localDate()
    }

    func firstDayOfTheWeek(_ weekIndex : Int) -> Date
    {
        Calendar.current.date(byAdding: .weekOfMonth, value: weekIndex , to: self.firstDayOfTheMonth())!.localDate()
    }
    
    func addDay() -> Date
    {
        Calendar.current.date(byAdding: .day, value: 1, to: self)!.localDate()
    }
    
    func addYear() -> Date
    {
        Calendar.current.date(byAdding: .year, value: 1, to: self)!.localDate()
    }

    func substractYear() -> Date
    {
        Calendar.current.date(byAdding: .year, value: -1, to: self)!.localDate()
    }
    
    func getMonthNameAndYear() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getYear() -> Int
    {
        Calendar.current.component(.year, from: self)
    }

    func localDate() -> Date
    {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}

        return localDate
    }

    func dateToString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: self)
    }

    func setMonth(_ monthIndex : Int) -> Date
    {
        let currentMonth = Calendar.current.component(.month, from: self)
        return Calendar.current.date(byAdding: .month, value: (monthIndex + 1) - currentMonth, to: self)!.localDate()
    }

    func setTime(from date:Date) -> Date
    {
        let hour = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        return Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: self)!
    }
    
    func getTimeStr() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"

        return dateFormatter.string(from: self)
    }
}
