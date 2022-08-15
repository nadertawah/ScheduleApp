//
//  UIColor.swift
//  ScheduleApp
//
//  Created by nader said on 06/08/2022.
//

import UIKit

extension UIColor
{
    static func color(data:Data) -> UIColor?
    {
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data
    {
        return try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}


extension UIColor
{
    func getTextColorForBackground() -> UIColor?
    {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        {
            if (red + green + blue) > 1.5
            {
                return .black
            }
            else
            {
                return .white
            }
        }
        else
        {
            return nil
        }
    }
}
