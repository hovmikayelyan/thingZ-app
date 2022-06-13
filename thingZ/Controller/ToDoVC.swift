//
//  ViewController.swift
//  thingZ
//
//  Created by Hovhannes Mikayelyan on 6/13/22.
//  Copyright © 2022 Hovhannes Mikayelyan. All rights reserved.
//

import UIKit

class ToDoVC: UIViewController {


    @IBOutlet weak var newTaskView: UIView!
    @IBOutlet weak var taskTxtField: TaskTxtField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTxtField.inputAccessoryView = newTaskView
    }


}

