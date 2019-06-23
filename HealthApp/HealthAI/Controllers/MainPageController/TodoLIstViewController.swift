import UIKit
import os.log

class TodoLIstViewController: UITableViewController{
    
    var workoutItems = [WorkoutItem]()
    var selectedworkoutItem = WorkoutItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "workoutCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedworkoutItem = workoutItems[indexPath.row]
        performSegue(withIdentifier: "goToWorkoutDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWorkoutDetails" {
            let seg = segue.destination as! WorkoutDetailViewController
            seg.selectedWorkoutItem = self.selectedworkoutItem
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WorkoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutTableViewCell else{
            os_log("Dequeue cell isn't an instance of Workout Table View Cell")
            fatalError()
        }
        
        selectedworkoutItem = workoutItems[indexPath.row]
        cell.titleLabel.text = selectedworkoutItem.title
        cell.middleLabel.text = "\(selectedworkoutItem.duration) - \(selectedworkoutItem.hardness)"
        cell.bodyLabel.text = selectedworkoutItem.body
        cell.strengthLabel.text = selectedworkoutItem.strength
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
