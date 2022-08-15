//
//  UITableViewCell.swift
//  ScheduleApp
//
//  Created by nader said on 11/08/2022.
//

import UIKit

extension UITableViewCell
{
    static var reuseIdentfier : String
    {
        return String(describing: self)
    }
}
