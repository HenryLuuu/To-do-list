//
//  ViewController.swift
//  TodoList
//
//  Created by Henry on 2019/8/7.
//  Copyright © 2019 Henry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldView: UIView!{
        didSet {
            self.textFieldView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
    
    
    
    var lists :Array = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.clipsToBounds = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "listCell")
    }
    
    func addList () {
        lists.append(List(task: textField.text!))
        tableView.reloadData()
    }
    
    @IBAction func doneEditButton(_ sender: Any) {
        //        guard let input = textField.text else { return }
        if textField.text != "" {
            addList()
            
        }
        textField.text = ""
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        cell.listLabel.text = lists[indexPath.row].task
        return cell
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    //view隨鍵盤彈起
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.view.frame.origin.y = -150
        }
    }
    
    
    //編輯結束收起鍵盤
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.view.frame.origin.y = 0
        }
    }
    
    
}

