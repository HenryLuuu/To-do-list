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
    @IBOutlet weak var moveView: UIView!{
        didSet{
            self.moveView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
    @IBOutlet weak var moveViewBottomConstraint: NSLayoutConstraint!
    
    
    
    var lists :Array = [List]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "listCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
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
    
    
    @objc func keyboardWillShow(notification: Notification) {
        self.keyboardControl(notification, isShowing: true)
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            moveViewBottomConstraint.constant -= keyboardHeight - safeBottom
            
            //view 收起動畫
            var userInfo = notification.userInfo!
            let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
            let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
            
            UIView.animate(withDuration: duration!,delay: 0,options: options,animations: {
                self.view.layoutIfNeeded()
            },
                           completion: { bool in
            })
            
        }
    }
    
    var safeBottom:CGFloat = 0
    
    private func keyboardControl(_ notification: Notification, isShowing: Bool) {
        
        //get keyboard height
        var userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y


        var  pureheightOffset : CGFloat = -heightOffset
        
        if isShowing { /// Wite space of save area in iphonex ios 11
            if #available(iOS 11.0, *) {
                safeBottom = view.safeAreaInsets.bottom
                pureheightOffset = pureheightOffset + safeBottom
                moveViewBottomConstraint.constant = -pureheightOffset
            }
        }
        
        
        //view 收起動畫
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        UIView.animate(withDuration: duration!,delay: 0,options: options,animations: {
                self.view.layoutIfNeeded()
        },
            completion: { bool in
        })
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        keyboardWillHide(notification: Notification)
        return true
    }

}

