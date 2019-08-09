//
//  ListTableViewCell.swift
//  TodoList
//
//  Created by Henry on 2019/8/7.
//  Copyright © 2019 Henry. All rights reserved.
//

import UIKit

protocol ChangeButton {
    func changeButton(checked: Bool, index: Int)
}


class ListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var listLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    
    
    
}
