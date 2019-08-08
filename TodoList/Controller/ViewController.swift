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
    
    var lists :Array = [List]()
    
    @IBOutlet weak var moveViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "listCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
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
    
    private func keyboardControl(_ notification: Notification, isShowing: Bool) {
        
        
        /* Handle the Keyboard property of Default*/
        
        //keyboard height
        var userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
        

        var  pureheightOffset : CGFloat = -heightOffset
        
        if isShowing { /// Wite space of save area in iphonex ios 11
            if #available(iOS 11.0, *) {
                pureheightOffset = pureheightOffset + view.safeAreaInsets.bottom
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

//extension ViewController: UITextFieldDelegate {
//
//
//
//    //view隨鍵盤彈起
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.1) {
//            self.view.frame.origin.y = -150
//        }
//    }
//
//
//    //編輯結束收起鍵盤
////    func textFieldDidEndEditing(_ textField: UITextField) {
////        UIView.animate(withDuration: 0.1) {
////            self.view.frame.origin.y = 0
////        }
////    }
//
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//
//        textField.resignFirstResponder()
//        //or
//        //self.view.endEditing(true)
//        return true
//    }
//
//
//}

