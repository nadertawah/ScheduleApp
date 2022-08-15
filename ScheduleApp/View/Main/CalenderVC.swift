//
//  MainVC.swift
//  ScheduleApp
//
//  Created by nader said on 22/07/2022.
//

import UIKit
import Combine

class CalenderVC: UIViewController
{
    //MARK: - IBOutlet(s)
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    init(dataPersistant : DataPersistantProtocol)
    {
        self.VM = CalenderVM(dataPersistant: dataPersistant)
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
        VM.getYearTasks()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        let layout = calenderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: (calenderCollectionView.frame.height - 12)  / 12 , height:  (calenderCollectionView.frame.width - 4)  / 4)
        layout?.invalidateLayout()
    }
    
    //MARK: - IBAction(s)
    
    @IBAction func previousMonthBtnPressed(_ sender: UIButton)
    {
        VM.previousYear()
    }
    
    @IBAction func nextMonthBtnPressed(_ sender: UIButton)
    {
        VM.nextYear()
    }
    
    //MARK: - Var(s)
    private var VM : CalenderVM!
    private var subscribers: [AnyCancellable] = []
    
    //MARK: - Helper Funcs
    func setUI()
    {
        //register cells
        self.calenderCollectionView.register(UINib(nibName: LabelCollectionViewCell.reuseIdentfier, bundle: nil), forCellWithReuseIdentifier: LabelCollectionViewCell.reuseIdentfier)
        
        //bind VM
        VM.$date.receive(on: DispatchQueue.main).sink
        {
            [weak self] _ in
            guard let self = self else {return}
            self.yearLabel.text = "\(self.VM.date.getYear())"
            self.VM.getYearTasks()
        }.store(in: &subscribers)
        
        VM.$yearTasks.receive(on: DispatchQueue.main).sink
        {
            [weak self] _ in
            self?.calenderCollectionView.reloadData()
        }.store(in: &subscribers)
    }
    
    
}

//MARK: - collection view delegate funcs
extension CalenderVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        48
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionViewCell.reuseIdentfier, for: indexPath) as? LabelCollectionViewCell else {return UICollectionViewCell()}
        //set cell's background to hite if the week doesn't contain tasks and the blue to the opposite
        cell.label.backgroundColor = VM.weeksWithTasks.contains(indexPath.row) ? .link : .white
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 4)  / 4, height: (collectionView.frame.height - 12)  / 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let weekIndex = indexPath.row
        let monthIndex = indexPath.row / 4
        let firstDayOfWeek = VM.date.setMonth(monthIndex).firstDayOfTheWeek(weekIndex % 4)
        
        let vc = WeekVC(weekIndex: weekIndex , firstDayOfWeek: firstDayOfWeek, dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
