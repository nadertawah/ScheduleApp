//
//  WeekVM.swift
//  ScheduleApp
//
//  Created by nader said on 23/07/2022.
//

import Foundation

class WeekVM
{
    init(_ weekIndex : Int,_ firstDayOfWeek : Date,dataPersistant : DataPersistantProtocol)
    {
        self.dataPersistant = dataPersistant
        self.weekIndex = weekIndex
        getDaysArr(weekIndex,firstDayOfWeek)
        getTasks(index: 0)
    }
    
    
    //MARK: - Var(s)
    @Published private(set) var tasks = [Task]()
    private(set) var days = [Date]()
    private(set) var weekIndex : Int
    private(set) var dataPersistant : DataPersistantProtocol!
    
    //MARK: - intent(s)
    func deleteTask(index : Int)
    {
        self.dataPersistant.deleteObj(obj: self.tasks.remove(at: index))
    }
    
    //MARK: - Helper Funcs
    func getDaysArr(_ weekIndex : Int,_ firstDayOfWeek : Date)
    {
        var daysCount = 7
        let weekIndex = weekIndex % 4
        if weekIndex == 3
        {
            daysCount = firstDayOfWeek.daysInMonth().count - 21
        }
        
        var date = firstDayOfWeek
        for _ in 0..<daysCount
        {
            days.append(date)
            date = date.addDay()
        }
    }
    
    func createWeekLabelStr() -> String
    {
        let firstDay = Calendar.current.component(.day, from: days[0])
        let lastDay = Calendar.current.component(.day, from: days[days.count - 1])
        return "\(firstDay)-\(lastDay) \(days[0].getMonthNameAndYear())"
    }
    
    func getTasks(index: Int)
    {
        let dayStr = days[index].dateToString()
        
        let predicate = NSPredicate(format: "year == \(days[0].getYear()) && week == \(weekIndex)")
        dataPersistant.get(type: Task.self, predicate: predicate)
        { [weak self] in self?.tasks = $0.filter(
            { Task in
            Task.from?.dateToString() == dayStr
                
            })
        }
    }
    
}
