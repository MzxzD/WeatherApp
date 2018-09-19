//
//  SymptomViewController.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import RxSwift


class SymptomViewController: UIViewController, TableRefreshView {
    
    
    var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var disposeBag = DisposeBag()
    var VM: SymptomViewModelProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffectToBackground()
        setupView()
         self.hideKeyboardWhenTappedAround()
    }

    func setupView() {
        view.backgroundColor = .clear
//        let tableContentView = UIView()
//        tableContentView.frame = view.bounds
//        tableContentView.backgroundColor = .clear
        view.addSubviews(tableView, doneButton)
//        tableView.frame = view.bounds
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(SymptomTableViewCell.self, forCellReuseIdentifier: SymptomTableViewCell.identifier)
        tableView.register(CellHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CellHeaderFooterView.identifier)
//        tableView.register(NameTableViewCell.self, forCellReuseIdentifier: NameTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
        }else {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 44
            
        }
    }
    
    
    func setupConstraints(){
        let constraints = [
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 15),

            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalToConstant: 100),
            ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func addBlurEffectToBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }

    
    @objc func doneButtonPressed() {
        self.VM.saveAndDissmissView()
    }
    
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
extension SymptomViewController: UITableViewDelegate, UITableViewDataSource,TableIndexPathDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return VM.itemsToPresent.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.itemsToPresent[section].items.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: CellHeaderFooterView = tableView.dequeueHeaderFooterView()
        let sectionTitle = VM.itemsToPresent[section].items[0].data
        header.backgroundColor = .clear
        header.sectionTitleLabel.text = sectionTitle.name
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SymptomTableViewCell = tableView.dequeue(for: indexPath)
        cell.setupTextFieldChangeObserver()
        cell.tableRowDelegate = VM
        cell.tableIndexPathDelegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let selectedValue = VM.itemsToPresent[indexPath.section].items[indexPath.row].data
        //        self.menuViewModel.rowSelected(type: selectedValue.type)
    }

    
    func getIndexPath(forTableCell cell: UITableViewCell) -> IndexPath? {
       return tableView.indexPath(for: cell)
    }
    
    
}
