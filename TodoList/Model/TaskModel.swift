//
//  TaskModel.swift
//  TodoList
//
//  Created by Henry on 2019/8/7.
//  Copyright © 2019 Henry. All rights reserved.
//

import Foundation



class List:NSObject, NSCoding {
    
    var task :String
    
    init(task:String) {
        self.task = task
    }
    
    
    required init?(coder aDecoder:NSCoder ){
        self.task = aDecoder.decodeObject(forKey: "task") as? String ?? ""
    }
    
    func encode (with aCoder: NSCoder) {
        aCoder.encode(task, forKey: "task")
    }
    
    
    
    
    
}



