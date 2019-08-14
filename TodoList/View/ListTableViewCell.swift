//
//  ListTableViewCell.swift
//  TodoList
//
//  Created by Henry on 2019/8/7.
//  Copyright © 2019 Henry. All rights reserved.
//

import UIKit

//protocol ChangeButton {
//    func changeButton(checked: Bool, index: Int)
//}

protocol ListCellDelegate {
    func updateHeightOfRow(_ cell: ListTableViewCell, _ textView: UITextView)
    func save(index:Int, newString:String )
}

class ListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var listTextView: UITextView!
    
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var listTextField: UITextField!
    
    var cellDelegate: ListCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listTextView.delegate = self as UITextViewDelegate
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
var c = 0
var time: Timer?
extension ListTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = cellDelegate {
            delegate.updateHeightOfRow(self, listTextView)
        }
        
        time?.invalidate()
        time = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            self.cellDelegate!.save(index: textView.tag, newString: textView.text)
            print(c)
            
        }
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if let delegate = cellDelegate {
//            delegate.save(index: textView.tag, newString: textView.text)
//        }
//    }
    
}
