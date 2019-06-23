import UIKit

class CardioWorkoutTableViewController: UITableViewController {
    let workoutImages = ["runningImage","cyclingImage","walkingImage"]
    let workoutTitles = ["Running","Cycling","Walking"]
    var arrayOfCardioWorkout = [CardioWorkoutItem]()
    var selectedCardioWorkoutItem = CardioWorkoutItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardioWorkout = CardioWorkoutItem()
        cardioWorkout.type = "Cardio"
        cardioWorkout.title = "Running"
        let cardioWorkout1 = CardioWorkoutItem()
        cardioWorkout1.type = "Cardio"
        cardioWorkout1.title = "Cycling"
        let cardioWorkout2 = CardioWorkoutItem()
        cardioWorkout2.type = "Cardio"
        cardioWorkout2.title = "Walking"
        arrayOfCardioWorkout.append(cardioWorkout)
        arrayOfCardioWorkout.append(cardioWorkout1)
        arrayOfCardioWorkout.append(cardioWorkout2)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutImages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardioCell", for: indexPath) as! WorkoutCell
        
        cell.workoutTitle.text = workoutTitles[indexPath.row]
        cell.workoutImage.image = UIImage(named: workoutImages[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCardioWorkoutItem = arrayOfCardioWorkout[indexPath.row]
        performSegue(withIdentifier: "goToCardioWorkout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCardioWorkout" {
            let seg = segue.destination as! CardioWorkoutDetailViewController
            seg.selectedCardioWorkoutItem = self.selectedCardioWorkoutItem
        }
    }
    
}
