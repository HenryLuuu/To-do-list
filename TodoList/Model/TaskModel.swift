//
//  TaskModel.swift
//  TodoList
//
//  Created by Henry on 2019/8/7.
//  Copyright © 2019 Henry. All rights reserved.
//

import Foundation
import UIKit



class List:NSObject, NSCoding {
    
    var task :String
    var checkBox: Bool
    
    init(task :String, checkBox: Bool) {
        self.task = task
        self.checkBox = checkBox
    }
    
    //decoder 解壓縮
    required init?(coder aDecoder:NSCoder ){
        self.task = aDecoder.decodeObject(forKey: "task") as? String ?? ""
        self.checkBox = aDecoder.decodeBool(forKey: "check")
    }
    //encode 壓縮
    func encode (with aCoder: NSCoder) {
        aCoder.encode(task, forKey: "task")
        aCoder.encode(checkBox, forKey: "check")
    }
    
    
}


extension Bool {
    
    var image: UIImage{
        switch self {
        case true:
            return UIImage(named: "checkBox")!
        case false:
            return UIImage(named: "checkBoxConform")!
        }
    }
}

