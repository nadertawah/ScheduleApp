//
//  DataPersistantProtocol.swift
//  ScheduleApp
//
//  Created by nader said on 06/08/2022.
//

import Foundation
import CoreData

protocol DataPersistantProtocol
{
    func get<T:NSManagedObject>(type : T.Type,predicate : NSPredicate? ,completion : ([T]) -> ())
    func deleteObj<T:NSManagedObject>(type : T.Type,predicate:NSPredicate)
    func deleteObj(obj : NSManagedObject)
    func insertObject(entityName : String,valuesForKeys: [String:Any])
    func editObject<T:NSManagedObject>(type : T.Type,predicate:NSPredicate,valuesForKeys: [String:Any])
    func editObject(obj :NSManagedObject,valuesForKeys: [String:Any])
}
