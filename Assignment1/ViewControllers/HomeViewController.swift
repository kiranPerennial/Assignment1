//
//  HomeViewController.swift
//  Assignment1
//
//  Created by APPLE on 08/11/21.
//

import UIKit
import ReSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        store.subscribe(self)
        store.dispatch(TaskListAction())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        store.unsubscribe(self)
    }

    func setupUI() {
        self.title = "My Tasks"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(actionLogoutUser))
        self.navigationItem.leftBarButtonItem  = logoutBarButtonItem
    }

    //MARK: - Button Action
    @objc func actionLogoutUser() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCreateNewTask(_ sender: Any) {
        performSegue(withIdentifier: "newTask", sender: sender)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.taskList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        if let taskList = user?.taskList {
            cell.textLabel?.text = taskList[indexPath.row].title
            cell.detailTextLabel?.text = taskList[indexPath.row].dateTime
        }
        return cell
    }
}

extension HomeViewController: StoreSubscriber {
  func newState(state: AppState) {
    self.user = state.user
    tableView.reloadData()
  }
}
