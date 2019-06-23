import UIKit
import RealmSwift

class CalendarDetailCardioTableViewController: UITableViewController {
    let realm = try! Realm()
    func convertMeterToMile(distance:Double)->Double {
        return distance / 1000 * 0.62
    }
    
    var cardioSelectedDate = ""
    var cardiohWorkoutHistories : Results<WorkoutHistoryItem>?

    func loadCardioWorkoutHistoryData(){
        let cardioPredicate = NSPredicate(format: "currentDate==%@ AND type==%@", cardioSelectedDate,"Cardio")
        cardiohWorkoutHistories = realm.objects(WorkoutHistoryItem.self).filter(cardioPredicate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCardioWorkoutHistoryData()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardiohWorkoutHistories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cardio Workout Summary"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardioCell", for: indexPath) as! CardioSummaryCell
        
        if let cardioWorkouts = cardiohWorkoutHistories {
            cell.titleLabel.text = cardioWorkouts[indexPath.row].title
            let distance = convertMeterToMile(distance: cardioWorkouts[indexPath.row].totalDistance)
            cell.distanceLabel.text = String(format: "%.2f",distance) + " mi"
            cell.averageSpeedLabel.text = "Average Speed: "+String(format: "%.2f",cardioWorkouts[indexPath.row].averageSpeed) + " M/S"
            cell.timeLabel.text = "Total Time: " + convertSecondToMin(time: cardioWorkouts[indexPath.row].time) + " min"
            cell.dateLabel.text = cardioWorkouts[indexPath.row].currentDateTime
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
        }
        return cell
    }
    
    func convertSecondToMin(time:String)->String{
        print((time as NSString).integerValue)
        return String(format: "%.1f", (time as NSString).doubleValue / 60)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let workoutHistroyForDeletion = self.cardiohWorkoutHistories?[indexPath.row]{
                do{
                    try self.realm.write{
                        self.realm.delete(workoutHistroyForDeletion)
                    }
                }catch{
                    print("Error delelting the the item using realm")
                }
            }
            
            self.tableView.reloadData()
        }
    }
}
