//
//  CalenderVM.swift
//  ScheduleApp
//
//  Created by nader said on 22/07/2022.
//

import Foundation

class CalenderVM
{
    init(dataPersistant: DataPersistantProtocol)
    {
        self.dataPersistant = dataPersistant
        date = Date().localDate()
    }
    
    //MARK: - Var(s)
    @Published private(set) var date : Date
    @Published private(set) var yearTasks : [Task] = []
    private(set) var dataPersistant: DataPersistantProtocol
    private(set) var weeksWithTasks : [Int] = []
    
    //MARK: - intent(s)
    func nextYear()
    {
        date = date.addYear()
    }
    func previousYear()
    {
        date = date.substractYear()
    }
    
    //MARK: - Helper Funcs
    func getYearTasks()
    {
        let predicate = NSPredicate(format: "year == \(date.getYear())")
        dataPersistant.get(type: Task.self, predicate: predicate)
        {
            [weak self] in
            self?.weeksWithTasks = Array(Set($0.compactMap{Task in Int(Task.week) }))
            self?.yearTasks = $0
        }
    }
}
