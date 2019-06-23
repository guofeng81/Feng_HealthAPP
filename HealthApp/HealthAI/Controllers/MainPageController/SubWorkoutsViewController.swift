import UIKit
import RealmSwift

class SubWorkoutsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DataTransferDelegate{
    var selectedWorkoutItem = WorkoutItem()
    var selectedSubworkoutItem = SubworkoutItem()
    var workoutHistoryItem = WorkoutHistoryItem()
    @IBOutlet var myTableView: UITableView!
    func userDidFinishedSubworkout(subworkoutItem: SubworkoutItem) {
        selectedSubworkoutItem.done = subworkoutItem.done
        selectedSubworkoutItem.time = subworkoutItem.time
        myTableView.reloadData()
    }
    @IBAction func endWorkoutBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "End Workout", message: "Are you sure you want to end your workout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "End & Save Workout", style: .default, handler: { (action) in
            self.saveWorkout()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "End Without Saving", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Back to Workout", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveWorkout(){
        workoutHistoryItem.title = self.selectedWorkoutItem.title
        for index in 0..<self.selectedWorkoutItem.subworkouts.count {
            if selectedWorkoutItem.subworkouts[index].done == true {
                let subworkoutHistoryItem = SubworkoutHistoryItem()
                subworkoutHistoryItem.title = self.selectedWorkoutItem.subworkouts[index].title
                subworkoutHistoryItem.time = self.selectedWorkoutItem.subworkouts[index].time
                workoutHistoryItem.subworkoutItems.append(subworkoutHistoryItem)
            }
        }
        
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(workoutHistoryItem)
            }
        }catch{
            print("Error using Realm!!")
        }
        
        print("workout Data save")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedWorkoutItem.subworkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subworkoutCell", for: indexPath)
        
        cell.textLabel!.text = selectedWorkoutItem.subworkouts[indexPath.row].title
        
        if selectedWorkoutItem.subworkouts[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSubworkoutStopwatch", sender: self)
        selectedSubworkoutItem = selectedWorkoutItem.subworkouts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSubworkoutStopwatch"{
            let seg = segue.destination as! WorkoutClockViewController
            seg.selectedSubworkoutItem = selectedSubworkoutItem
            seg.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

