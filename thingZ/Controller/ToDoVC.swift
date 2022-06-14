//
//  ViewController.swift
//  thingZ
//
//  Created by Hovhannes Mikayelyan on 6/13/22.
//  Copyright © 2022 Hovhannes Mikayelyan. All rights reserved.
//

import UIKit

class ToDoVC: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tasksTable: UITableView!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var newTaskView: UIView!
    @IBOutlet weak var taskTxtField: TaskTxtField!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    var todos = Array<Todo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTable.delegate = self
        tasksTable.dataSource = self
        getTodos()
        
        self.bindToKeyboard()
    }
    
    func getTodos() {
        NetworkService.shared.getTodos({ (todos) in
            self.todos = todos.items
            self.tasksTable.reloadData()
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    @IBAction func addTaskBtnWasPressed(_ sender: Any) {
        
        guard let taskItem = taskTxtField.text, !taskItem.isEmpty else {
            debugPrint("Todo item must have a title, focusing on textfield.")
            taskTxtField.becomeFirstResponder()
            return
        }
        
        let todo = Todo(item: taskItem, priority: prioritySegment.selectedSegmentIndex)
        NetworkService.shared.addTodo(todo: todo, onSuccess: { (todos) in
            self.taskTxtField.text = ""
            self.todos = todos.items
            self.tasksTable.reloadData()
        }) {(errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
}

extension ToDoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as? TodoCell {
            cell.updateCell(todo: todos[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ToDoVC {

    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                
                tasksTable.contentInset = UIEdgeInsets(top: keyboardSize.height, left: 0, bottom: 0, right: 0)
            }
           
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            
            tasksTable.contentInset = .zero
        }
        
    }
}
