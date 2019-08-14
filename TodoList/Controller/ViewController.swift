//
//  ViewController.swift
//  TodoList
//
//  Created by Henry on 2019/8/7.
//  Copyright © 2019 Henry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var moveView: UIView!{
        didSet{
            self.moveView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
    @IBOutlet weak var moveViewBottomConstraint: NSLayoutConstraint!
    
    
    
    
    var lists :Array = [List]()
    var safeBottom:CGFloat = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        getList()
        settingKeyboard()
        keyboardDismissGesture()
        
    }

    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
//        self.tableView.isEditing = !self.tableView.isEditing
        tableView.setEditing(!self.tableView.isEditing, animated: true)
        sender.title = self.tableView.isEditing ? "Done" : "Edit"
//        switch sender.title == "Edit" {
//        case true:
//            item.title = "Done"
//        case false:
//            item.title = "Edit"
//        }
    }
    

    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        self.tableView.estimatedRowHeight = 60
//        self.tableView.rowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "listCell")
    }
    
    
    func addList () {
        lists.append(List(task: textField.text!, checkBox: true))
        tableView.reloadData()
        
    }
    
    
    
    @IBAction func doneInputButton(_ sender: Any) {
        //        guard let input = textField.text else { return }
        if textField.text != "" {
            addList()
            let indexPath = NSIndexPath(row: self.lists.count-1, section: 0)
            tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            saveList()
//            for i in lists {
//                print(i.checkBox)
//            }
        }
        textField.text = ""
    }
    
    //save custom object user defaults 不能儲存此type
    func saveList() {
        let saveData = try!NSKeyedArchiver.archivedData(withRootObject: lists, requiringSecureCoding: false)
        UserDefaults.standard.set(saveData, forKey: "list")
    }
    
    // user default的資料轉型 轉型使用try。unarchiver解除封存
    //Swift 的 Error Handling 機制 丟出錯誤的做法統一用 throw，呼叫有可能出錯的 function，一定要加上 try，，Swift 還強制要求我們錯誤一定要處理，不處理將產生 compile error 提醒我們。
    func getList() {
        if let getData = UserDefaults.standard.object(forKey: "list") as? NSData {
            lists = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(getData as Data) as! [List]
        }
        
    }

    //keyboard tap gesture
    func keyboardDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchTableView))
        tableView.addGestureRecognizer(tap)
    }
    
    //收起鍵盤語法
    @objc func touchTableView() {
        self.view.endEditing(true)
    }
    
    
    func settingKeyboard(){
        //偵測到key will show 執行keyboardWillShow function
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //偵測到key will retune 執行(的事情) keyboardWillHide function
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.keyboardControl(notification, isShowing: true)
    }
    
    private func keyboardControl(_ notification: Notification, isShowing: Bool) {
        
        //get keyboard height
        var userInfo = notification.userInfo!
        //鍵盤尺寸
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
    
    
    @objc func keyboardWillHide(notification: Notification) {
        //得到keyboard height 後view放回
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            moveViewBottomConstraint.constant -= keyboardHeight - safeBottom
            moveViewBottomConstraint.constant = 0
        
            //view 收起動畫
            var userInfo = notification.userInfo!
            let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
            let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
            
            UIView.animate(withDuration: duration!,delay: 0,options: options,animations: {
                self.view.layoutIfNeeded()
            }, completion: { bool in
            })
//        }
    }

    
}


extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        let model = lists[indexPath.row]
        cell.listTextView.text = model.task
        
        cell.cellDelegate = self as ListCellDelegate
        
        cell.checkBoxButton.addTarget(self, action: #selector(changeButtonImage), for: .touchUpInside)
        cell.checkBoxButton.setImage(model.checkBox.image , for: .normal)
        cell.checkBoxButton.tag = indexPath.row
        
        cell.listTextView.tag = indexPath.row
        return cell
    }
    
    @objc func changeButtonImage(sender:UIButton) {
        let model = lists[sender.tag]
        model.checkBox.toggle()
        sender.setImage(model.checkBox.image, for: .normal)
        saveList()
        /*
         let empty = UIImage(named: "checkBox")
         let check = UIImage(named: "checkBoxConform")
         switch model.checkBox {
         case true :
         btn.setImage(check, for: .normal)
         case false:
         btn.setImage(empty, for: .normal)
         }
         */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 1 {
//            return UITableView.automaticDimension
//        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if !tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let newSequenceArray = lists[sourceIndexPath.row]
        lists.remove(at: sourceIndexPath.row)
        lists.insert(newSequenceArray, at: destinationIndexPath.row)
        saveList()
    }
    
    
//    增加刪除動作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveList()
        }
    }
    
}

extension ViewController: ListCellDelegate {
    
    
    func save(index: Int, newString: String) {
        lists[index].task = newString
        saveList()
    }

    
    func updateHeightOfRow(_ cell: ListTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }

}


extension ViewController: UITextFieldDelegate {
    
    //按下return收起鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}


