//
//  TasksTVCell.swift
//  ScheduleApp
//
//  Created by nader said on 07/08/2022.
//

import UIKit

class TasksTVCell: UITableViewCell
{

    //MARK: - IBOutlet(s)
    @IBOutlet weak var mainViewFromLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fromToLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var editBTN: UIButton!
    
    @IBOutlet weak var deleteBTN: UIButton!
    
    @IBOutlet weak var expandedView: UIView!
    
    @IBOutlet weak var mainViewBottom: NSLayoutConstraint!
    @IBOutlet weak var expandedViewTop: NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        expandedView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        if expandedView.isHidden , selected
        {
            expandedView.isHidden = false
        }
        else
        {
            expandedView.isHidden = true
        }
    }
}
