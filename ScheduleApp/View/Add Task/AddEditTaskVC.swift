//
//  AddTaskVC.swift
//  ScheduleApp
//
//  Created by nader said on 03/08/2022.
//

import UIKit

class AddEditTaskVC: UIViewController
{
    //MARK: - IBOutlet(s)
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var dayDateBackView: UIView!
    {
        didSet
        {
            dayDateBackView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var dateFromPicker: UIDatePicker!
    
    @IBOutlet weak var dateToPicker: UIDatePicker!
    
    @IBOutlet weak var colorBtn: UIButton!
    {
        didSet
        {
            colorBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var colorBtnArrowLabel: UILabel!
    
    @IBOutlet weak var detailsBackView: UIView!
    {
        didSet
        {
            detailsBackView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var cancelBtn: UIButton!
    {
        didSet
        {
            cancelBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    {
        didSet
        {
            saveBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    init(task: Task?,_ weekIndex : Int,date: Date,dataPersistant : DataPersistantProtocol)
    {
        VM = AddEditTaskVM(task: task, weekIndex,date,dataPersistant : dataPersistant)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUI()
    }

    
    //MARK: - IBAction(s)
    
    @IBAction func colorBtnPressed(_ sender: Any)
    {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor! // Setting the Initial Color of the Picker
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any)
    {
        if titleTF.text == "" || detailsTextView.textColor == .lightGray
        {
            self.showAlert(title: "Error", msg: "Title and Details must not be empty!")
        }
        else
        {
            let from = VM.date.setTime(from: dateFromPicker.date)
            let to = VM.date.setTime(from: dateToPicker.date)
            VM.saveTask(title: titleTF.text!, details: detailsTextView.text, colorData: colorBtn.backgroundColor!.encode(),from: from, to: to)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Var(s)
    var VM : AddEditTaskVM
    
    
    //MARK: - Helper Funcs
    func setUI()
    {
        dayLabel.text = "Day:   \(VM.date.dateToString())"
        
        //check edit or add
        if let taskToEdit = VM.task
        {
            titleTF.text = taskToEdit.title
            dateFromPicker.date = taskToEdit.from ?? VM.date
            dateToPicker.date = taskToEdit.to ?? VM.date
            detailsTextView.text = taskToEdit.details
            detailsTextView.textColor = self.isLightMode() ? .black : .white
            
            changeTaskBGColorAndForeground(color: UIColor.color(data: taskToEdit.color) ?? .link)
        }
        
        detailsTextView.delegate = self
        
        //hide keyboard
        hideKeyboardWhenTappedAround()
    }
    
    func changeTaskBGColorAndForeground(color:UIColor)
    {
        colorBtn.backgroundColor = color
        cancelBtn.backgroundColor = color
        saveBtn.backgroundColor = color

        let textColor = color.getTextColorForBackground()
        colorBtn.setTitleColor(textColor, for: .normal)
        saveBtn.setTitleColor(textColor, for: .normal)
        cancelBtn.setTitleColor(textColor, for: .normal)
        colorBtnArrowLabel.textColor = textColor
    }
    
}

extension AddEditTaskVC : UIColorPickerViewControllerDelegate
{
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController)
    {
        changeTaskBGColorAndForeground(color: viewController.selectedColor)
    }
}


extension AddEditTaskVC : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if detailsTextView.textColor == UIColor.lightGray
        {
            detailsTextView.text = ""
            detailsTextView.textColor = self.isLightMode() ? .black : .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {

        if detailsTextView.text.isEmpty
        {
            detailsTextView.text = "Details ..."
            detailsTextView.textColor = UIColor.lightGray
        }
    }
}
