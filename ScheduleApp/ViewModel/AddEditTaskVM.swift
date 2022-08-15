//
//  AddTaskVM.swift
//  ScheduleApp
//
//  Created by nader said on 03/08/2022.
//

import Foundation

class AddEditTaskVM
{
    init(task: Task?, _ weekIndex : Int,_ date: Date,dataPersistant : DataPersistantProtocol)
    {
        self.dataPersistant = dataPersistant
        self.date = date
        self.weekIndex = weekIndex
        self.task = task
    }
    
    //MARK: - Var(s)
    private(set) var date : Date
    private(set) var weekIndex : Int
    private(set) var task : Task?
    var dataPersistant : DataPersistantProtocol
    
    //MARK: - intent(s)
    func saveTask(title: String, details:String, colorData: Data,from: Date, to: Date)
    {
        let taskDict = [Task.kTITLE: title, Task.kDETAILS: details, Task.kCOLOR: colorData, Task.kFROM: from,Task.kTO: to, Task.kYEAR:date.getYear(), Task.kWEEK:weekIndex] as [String:Any]
        
        //edit or insert
        if let task = task
        {
            dataPersistant.editObject(obj: task, valuesForKeys: taskDict)
        }
        else
        {
            dataPersistant.insertObject(entityName: Task.entityName, valuesForKeys: taskDict)
        }
    }
    
    //MARK: - Helper Funcs
   
}
