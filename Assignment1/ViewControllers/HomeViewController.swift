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
        super.viewWillAppear(animated)
        store.subscribe(self)
        store.dispatch(TaskListAction())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        store.dispatch(CreateTaskAction())
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            store.dispatch(UpdateTaskAction(selectedTask: Task(title: (cell.textLabel?.text)!, dateTime: (cell.detailTextLabel?.text)!)))
            performSegue(withIdentifier: "newTask", sender: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let cell = tableView.cellForRow(at: indexPath) {
                user?.taskList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                store.dispatch(DeleteTaskAction(deleteTask: Task(title: (cell.textLabel?.text)!, dateTime: (cell.detailTextLabel?.text)!)))
            }
        }
    }
}

extension HomeViewController: StoreSubscriber {
    func newState(state: AppState) {
        self.user = state.user
        tableView.reloadData()
    }
}
