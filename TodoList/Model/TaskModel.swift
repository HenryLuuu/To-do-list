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
    var checkBox: Box
//    var checkBox: Bool
    
    init(task :String, checkBox: Box) {
        self.task = task
        self.checkBox = checkBox
    }
    //decoder 解壓縮
    required init?(coder aDecoder:NSCoder ){
        self.task = aDecoder.decodeObject(forKey: "task") as? String ?? ""
        let bool = aDecoder.decodeBool(forKey: "check")
        self.checkBox = Box(box: bool)
//        self.checkBox = aDecoder.decodeBool(forKey: "check")
    }
    //encode 壓縮
    func encode (with aCoder: NSCoder) {
        aCoder.encode(task, forKey: "task")
        aCoder.encode(checkBox.bool, forKey: "check")
//        aCoder.encode(checkBox, forKey: "check")
    }
    
    enum Box {
        case check , empty
        init(box:Bool ) {
            self = box ? .empty : .check
        }
        var bool :Bool {
            switch self{
            case .empty:
                return true
            case .check:
                return false
            }
        }
        var image: UIImage{
            switch self {
            case .empty:
                return UIImage(named: "checkBox")!
            case .check:
                return UIImage(named: "checkBoxConform")!
            }
        }
        mutating func toggle() {
            self = (self == .check) ? .empty : .check
        }
    }
}

//extension Bool {
//
//    var image: UIImage{
//        switch self {
//        case true:
//            return UIImage(named: "checkBox")!
//        case false:
//            return UIImage(named: "checkBoxConform")!
//        }
//    }
//}

