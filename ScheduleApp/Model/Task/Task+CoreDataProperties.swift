//
//  Task+CoreDataProperties.swift
//  ScheduleApp
//
//  Created by nader said on 23/07/2022.
//
//

import Foundation
import CoreData


extension Task
{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task>
    {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var from: Date?
    @NSManaged public var to: Date?
    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var color: Data
    @NSManaged public var year: Int16
    @NSManaged public var week: Int16

}

extension Task : Identifiable
{
    static var entityName : String
    {
        return String(describing: self)
    }
    
    static let kTITLE = "title"
    static let kTO = "to"
    static let kFROM = "from"
    static let kDETAILS = "details"
    static let kCOLOR = "color"
    static let kYEAR = "year"
    static let kWEEK = "week"

}
