//
//  WeekVC.swift
//  ScheduleApp
//
//  Created by nader said on 23/07/2022.
//

import UIKit
import Combine

class WeekVC: UIViewController
{
    //MARK: - IBOutlet(s)
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var tasksTabelView: UITableView!
    @IBOutlet weak var weekLabel: UILabel!
    
    init(weekIndex: Int,firstDayOfWeek: Date,dataPersistant : DataPersistantProtocol)
    {
        VM = WeekVM(weekIndex,firstDayOfWeek,dataPersistant: dataPersistant)
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let index = daysCollectionView.indexPathsForVisibleItems.first?.row
        {
            self.VM.getTasks(index: index)
        }
    }
    
    //MARK: - IBAction(s)
    @IBAction func addTaskBtnPressed(_ sender: Any)
    {
        goToAddEditTaskVC(task: nil)
    }
    
    @objc func editTaskBtnPressed(_ sender: UIButton)
    {
        goToAddEditTaskVC(task: VM.tasks[sender.tag])
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Var(s)
    private var VM : WeekVM
    private var disposeBag = [AnyCancellable]()
    
    //MARK: - Helper Funcs

    func setUI()
    {
        //register cells
        daysCollectionView.register(UINib(nibName: LabelCollectionViewCell.reuseIdentfier, bundle: nil), forCellWithReuseIdentifier: LabelCollectionViewCell.reuseIdentfier)
        tasksTabelView.register(UINib(nibName: TasksTVCell.reuseIdentfier, bundle: nil), forCellReuseIdentifier: TasksTVCell.reuseIdentfier)
        
        //set title label
        weekLabel.text = VM.createWeekLabelStr()
        
        //make cell height dynamic
        tasksTabelView.estimatedRowHeight = 300
        tasksTabelView.rowHeight = UITableView.automaticDimension
        
        //bind VM
        VM.$tasks.receive(on: DispatchQueue.main).sink
        {
            [weak self] _ in
            guard let self = self else {return}
            self.tasksTabelView.reloadData()
        }.store(in: &disposeBag)
    }
    
    @objc func deleteTask(_ sender:UIButton)
    {
        VM.deleteTask(index: sender.tag)
    }
    
    func goToAddEditTaskVC(task:Task?)
    {
        if let index = daysCollectionView.indexPathsForVisibleItems.first?.row
        {
            let vc = AddEditTaskVC(task: task, VM.weekIndex,date: VM.days[index],dataPersistant : VM.dataPersistant)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: - days collection view delegate funcs
extension WeekVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return VM.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionViewCell.reuseIdentfier, for: indexPath) as? LabelCollectionViewCell else {return UICollectionViewCell()}
        cell.label.text = VM.days[indexPath.row].dateToString()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: daysCollectionView.frame.width , height: daysCollectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.VM.getTasks(index: daysCollectionView.indexPathsForVisibleItems[0].row)
    }
}

//MARK: - table view delegate funcs
extension WeekVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        VM.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tasksTabelView.dequeueReusableCell(withIdentifier: TasksTVCell.reuseIdentfier) as? TasksTVCell else{return UITableViewCell()}
        let task = VM.tasks[indexPath.row]
        
        cell.backgroundColor = UIColor.color(data: task.color)

        let textColor = cell.backgroundColor?.getTextColorForBackground()
        cell.titleLabel.text = task.title
        cell.titleLabel.textColor = textColor
        
        cell.mainViewFromLabel.text = task.from?.getTimeStr()
        cell.mainViewFromLabel.textColor = textColor

        cell.detailsLabel.text = task.details
        cell.detailsLabel.textColor = textColor
        
        cell.fromToLabel.text = "\(task.from?.getTimeStr() ?? "") - \(task.to?.getTimeStr() ?? "")"
        cell.fromToLabel.textColor = textColor
        
        cell.detailsLabel.text = task.details
        cell.detailsLabel.textColor = textColor
        
        cell.deleteBTN.tag = indexPath.row
        cell.deleteBTN.addTarget(nil, action: #selector(self.deleteTask(_:)), for: .touchUpInside)
        
        cell.editBTN.tag = indexPath.row
        cell.editBTN.addTarget(nil, action: #selector(self.editTaskBtnPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        UIView.animate(withDuration: 0.3)
        {
            self.tasksTabelView.performBatchUpdates(nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        if let cell = self.tasksTabelView.cellForRow(at: indexPath) as? TasksTVCell
        {
            cell.expandedView.isHidden = true
        }
    }
}


