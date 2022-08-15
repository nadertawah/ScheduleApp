//
//  BaseNavBar.swift
//  ScheduleApp
//
//  Created by nader said on 23/07/2022.
//

import UIKit

class BaseNavBar : UINavigationController
{
    var dataPersistant : DataPersistantProtocol!

    init(dataPersistant : DataPersistantProtocol)
    {
        self.dataPersistant = dataPersistant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        
        self.viewControllers = [CalenderVC(dataPersistant: dataPersistant)]
    }
}
