//
//  SymptomTableViewCell.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import RxSwift

public protocol TableIndexPathDelegate: class {
    func getIndexPath(forTableCell cell: UITableViewCell ) -> IndexPath?
    
}

public protocol TableRowDelegate: class {
    func inputFinished(indexPath:IndexPath ,input: String)
}



class SymptomTableViewCell: UITableViewCell,UITextFieldDelegate {

        weak var tableRowDelegate: TableRowDelegate?
        weak var tableIndexPathDelegate: TableIndexPathDelegate?
        var disposeBag = DisposeBag()
        
        var unitTextField: UITextField = {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            //        let text = Theme.Styles.Text.Regular.normal.defaultColor
            //        textField.applyStyle(Theme.Styles.Text.Regular.normal.defaultColor)
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.cornerRadius = 5
            textField.placeholder = "From 0 - 10, How much is it?"
            textField.keyboardType = UIKeyboardType.default
            return textField
        }()
        
        var unitLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
            self.isAccessibilityElement = true
            self.unitTextField.delegate = self
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        func setupTextFieldChangeObserver(){
            unitTextField.rx.text.orEmpty
                .distinctUntilChanged({ (first, second) -> Bool in
                    return  first == second
                })
                .skip(1) // skip first value
                .debounce(RxTimeInterval(0.5), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)) //Time in seconds
                .asDriver(onErrorJustReturn: .empty) // Operacija se radi na mainThread-u
                .do(onNext: {[unowned self] (text) in
                    guard  let tableIndexDelegate = self.tableIndexPathDelegate,
                        let tableDelegate = self.tableRowDelegate,
                        let rowIndex = tableIndexDelegate.getIndexPath(forTableCell: self)
                        else {
                            return
                    }
                    
                    tableDelegate.inputFinished(indexPath:rowIndex,input: text)
                })
                .drive()
                .disposed(by: disposeBag)
        }
        
        private func setupUI(){
            self.contentView.addSubviews(unitTextField, unitLabel)
            self.backgroundColor = .clear
            self.contentView.backgroundColor = .clear
            setupConstraints()
        }
        
        
        private func setupConstraints(){
            let constraints = [
                unitTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
                unitTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                unitTextField.heightAnchor.constraint(equalToConstant: 31),
                unitTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.63),
                unitTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
                
                unitLabel.leadingAnchor.constraint(equalTo: unitTextField.trailingAnchor, constant: 10),
                unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                unitLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
                unitLabel.centerYAnchor.constraint(equalTo: unitTextField.centerYAnchor),
                ]
            NSLayoutConstraint.activate(constraints)
        }
        
    }
    
    
    
    
//    class HomeTableViewCell: UITableViewCell, UITextFieldDelegate {
//        
//        
//        weak var tableRowDelegate: TableRowDelegate?
//        weak var tableIndexPathDelegate: TableIndexPathDelegate?
//        var disposeBag = DisposeBag()
//        
//        var unitTextField: UITextField = {
//            let textField = UITextField()
//            textField.translatesAutoresizingMaskIntoConstraints = false
//            //        let text = Theme.Styles.Text.Regular.normal.defaultColor
//            //        textField.applyStyle(Theme.Styles.Text.Regular.normal.defaultColor)
//            textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor.black.cgColor
//            textField.layer.cornerRadius = 5
//            textField.placeholder = "00"
//            textField.keyboardType = UIKeyboardType.decimalPad
//            return textField
//        }()
//        
//        var unitLabel: UILabel = {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            //        let text = Theme.Styles.Text.Semibold.normal.defaultColor
//            //        label.font = text.font
//            //        label.textColor = text.textColor
//            return label
//        }()
//        
//        override init(style: UITableViewCellStyle, reuseIdentifier: String?){
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
//            setupUI()
//            self.isAccessibilityElement = true
//            self.unitTextField.delegate = self
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
//        //            return true
//        //        }
//        //        let decimalPoint: CharacterSet = CharacterSet(charactersIn: NSLocale.current.decimalSeparator!)
//        //        let newText = oldText.replacingCharacters(in: r, with: string)
//        //        let textFormatter = NumberFormatter()
//        //        let isNumeric = newText.isEmpty || textFormatter.number(from: newText) != nil
//        //        let numberOfDots = newText.components(separatedBy: decimalPoint ).count - 1
//        //
//        //        let numberOfDecimalDigits: Int
//        //        if let dotIndex = newText.index(of: (NSLocale.current.decimalSeparator?.first)!) {
//        //            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
//        //        } else {
//        //            numberOfDecimalDigits = 0
//        //        }
//        //        let shouldChangeText = isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
//        //        return shouldChangeText
//        //    }
//        
//        
//        func setupTextFieldChangeObserver(){
//            unitTextField.rx.text.orEmpty
//                .distinctUntilChanged({ (first, second) -> Bool in
//                    return  first == second
//                })
//                .skip(1) // skip first value
//                .debounce(RxTimeInterval(0.5), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)) //Time in seconds
//                .asDriver(onErrorJustReturn: .empty) // Operacija se radi na mainThread-u
//                .do(onNext: {[unowned self] (text) in
//                    guard  let tableIndexDelegate = self.tableIndexPathDelegate,
//                        let tableDelegate = self.tableRowDelegate,
//                        let rowIndex = tableIndexDelegate.getIndexPath(forTableCell: self)
//                        else {
//                            return
//                    }
//                    
//                    tableDelegate.inputFinished(indexPath:rowIndex,input: text)
//                })
//                .drive()
//                .disposed(by: disposeBag)
//        }
//        
//        private func setupUI(){
//            self.contentView.addSubviews(unitTextField, unitLabel)
//            setupConstraints()
//        }
//        
//        
//        private func setupConstraints(){
//            let constraints = [
//                unitTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
//                unitTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//                unitTextField.heightAnchor.constraint(equalToConstant: 31),
//                unitTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.63),
//                unitTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
//                
//                unitLabel.leadingAnchor.constraint(equalTo: unitTextField.trailingAnchor, constant: 10),
//                unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//                unitLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
//                unitLabel.centerYAnchor.constraint(equalTo: unitTextField.centerYAnchor),
//                ]
//            NSLayoutConstraint.activate(constraints)
//        }
//        
//        
//        
//        
//}
//
//
