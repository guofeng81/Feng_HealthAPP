import UIKit

class StrengthWorkoutVC: UIViewController {
    var workoutName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = workoutName
    }
    
    func customInit(workoutName: String) {
        self.workoutName = workoutName
    }

}
