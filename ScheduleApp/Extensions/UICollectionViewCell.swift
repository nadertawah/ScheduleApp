//
//  UICollectionViewCell.swift
//  ScheduleApp
//
//  Created by nader said on 22/07/2022.
//

import UIKit

extension UICollectionViewCell
{
    static var reuseIdentfier : String
    {
        return String(describing: self)
    }
}
