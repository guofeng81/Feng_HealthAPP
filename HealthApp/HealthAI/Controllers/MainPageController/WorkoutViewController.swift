import UIKit

class WorkoutViewController: UIViewController {
    var workoutItems = [WorkoutItem]()
    var cardioWorkoutItems = [CardioWorkoutItem]()
    @IBOutlet var strengthWorkoutView: UIView!
    @IBOutlet var cardioWorkoutView: UIView!
    @IBOutlet var videoTutorialView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWorkouts()
        setupGesture()
    }
    
    func setupWorkouts(){
        
        let workout = WorkoutItem()
        workout.type = "Strength"
        workout.title = "Arms"
        workout.content = "Tone and develop your arm muscles.You will go through eight exercises, alternating between three sets of 10 reps and two sets of 20 reps"
        workout.body = "upper body"
        workout.strength = "strength"
        workout.duration = "40 mins"
        workout.hardness = "Intermediate"
        
        let subworkout1 = SubworkoutItem()
        subworkout1.title = "Barbell Biceps Curl"
        subworkout1.videoName = "BBC"
        
        let subworkout2 = SubworkoutItem()
        subworkout2.title = "Barbell Reverse Curl"
        subworkout2.videoName = "BRC"
        
        let subworkout3 = SubworkoutItem()
        subworkout3.title = "Dumbbell Incline Curls"
        subworkout3.videoName = "DIC"
        
        let subworkout4 = SubworkoutItem()
        subworkout4.title = "Cable Preacher Curls"
        subworkout4.videoName = "CPC"
        
        let subworkout5 = SubworkoutItem()
        subworkout5.title = "Assisted Triceps Dip"
        subworkout5.videoName = "ATD"
        
        let subworkout6 = SubworkoutItem()
        subworkout6.title = "Cable Rope Pushdowns"
        subworkout6.videoName = "CRP"
        
        workout.subworkouts.append(subworkout1)
        workout.subworkouts.append(subworkout2)
        workout.subworkouts.append(subworkout3)
        workout.subworkouts.append(subworkout4)
        workout.subworkouts.append(subworkout5)
        workout.subworkouts.append(subworkout6)
        
        let workout2 = WorkoutItem()
        workout2.type = "Strength"
        workout2.title = "Back"
        workout2.content = "Tone and develop your back muscles.You will go through five exercises, alternating between three sets of 10 reps and two sets of 10 reps"
        workout2.body = "lower body"
        workout2.strength = "strength"
        workout2.duration = "30 mins"
        workout2.hardness = "Intermediate"
        
        let subworkout21 = SubworkoutItem()
        subworkout21.title = "Cable Close Grip Seated Row"
        subworkout21.videoName = "CCGSR"
        
        let subworkout22 = SubworkoutItem()
        subworkout22.title = "Cable Wide Grip Row"
        subworkout22.videoName = "CWGR"
        
        let subworkout23 = SubworkoutItem()
        subworkout23.title = "Cable Wide Grip Lat Pulldown"
        subworkout23.videoName = "CWGLP"
        
        let subworkout24 = SubworkoutItem()
        subworkout24.title = "Pullover"
        subworkout24.videoName = "PO"
        
        workout2.subworkouts.append(subworkout21)
        workout2.subworkouts.append(subworkout22)
        workout2.subworkouts.append(subworkout23)
        workout2.subworkouts.append(subworkout24)
        
        let workout3 = WorkoutItem()
        workout3.type = "Strength"
        workout3.title = "Bodyweight Basics 1"
        workout3.content = "Strengthen your total body using nothing but your body weight. You will do three sets of 15 reps for three exercises and three sets of 20 reps for a fourth exercise"
        workout3.body = "total body"
        workout3.strength = "strength"
        workout3.duration = "30 mins"
        workout3.hardness = "Beginner"
        
        
        let subworkout31 = SubworkoutItem()
        subworkout31.title = "Bodyweight Squat"
        subworkout31.videoName = "BS"
        
        let subworkout32 = SubworkoutItem()
        subworkout32.title = "Superman"
         subworkout32.videoName = "SM"
        
        let subworkout33 = SubworkoutItem()
        subworkout33.title = "Bench Dip"
         subworkout33.videoName = "BD"
        
        let subworkout34 = SubworkoutItem()
        subworkout34.title = "Bodyweight Mountain Climbers"
         subworkout34.videoName = "BMC"
        
        workout3.subworkouts.append(subworkout31)
        workout3.subworkouts.append(subworkout32)
        workout3.subworkouts.append(subworkout33)
        workout3.subworkouts.append(subworkout34)
        
        let workout4 = WorkoutItem()
        workout4.type = "Strength"
        workout4.title = "Chest"
        workout4.content = "Tone and develop your chest muscles. You'll go through five exercises with varying sets and reps"
        workout4.body = "upper body"
        workout4.strength = "strength"
        workout4.duration = "25 mins"
        workout4.hardness = "Intermediate"
        
        let subworkout41 = SubworkoutItem()
        subworkout41.title = "Barbell Bench Press"
        subworkout41.videoName = "BBP"
        
        
        let subworkout42 = SubworkoutItem()
        subworkout42.title = "Dumbbell Flat Bench Fly"
        subworkout42.videoName = "DFBF"
        
        let subworkout43 = SubworkoutItem()
        subworkout43.title = "Dumbbell Incline Bench Chest Press"
        subworkout43.videoName = "DIBCP"
        
        let subworkout44 = SubworkoutItem()
        subworkout44.title = "Push Up"
        subworkout44.videoName = "PU"
        
        let subworkout45 = SubworkoutItem()
        subworkout45.title = "Dumbbell Incline Bench Fly"
        subworkout45.videoName = "DIBF"
        
        workout4.subworkouts.append(subworkout41)
        workout4.subworkouts.append(subworkout42)
        workout4.subworkouts.append(subworkout43)
        workout4.subworkouts.append(subworkout44)
        workout4.subworkouts.append(subworkout45)
        
        workoutItems.append(workout)
        workoutItems.append(workout2)
        workoutItems.append(workout3)
        workoutItems.append(workout4)
    }
    
    func setupGesture(){
        let workoutGesture = UITapGestureRecognizer(target: self, action: #selector(workouthandleTap(sender:)))
        self.strengthWorkoutView.addGestureRecognizer(workoutGesture)
        
        let videoGesture = UITapGestureRecognizer(target: self, action: #selector(videoHandleTap(sender:)))
        self.videoTutorialView.addGestureRecognizer(videoGesture)
        
        let cardioGesture = UITapGestureRecognizer(target: self, action: #selector(cardiohandleTap(sender:)))
        self.cardioWorkoutView.addGestureRecognizer(cardioGesture)
        
    }
    
    @objc func cardiohandleTap(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "goToCardio", sender: self)
    }
    
    @objc func workouthandleTap(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "goToWorkout", sender: self)
    }
    
    @objc func videoHandleTap(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "goToVideo", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWorkout" {
            let seg = segue.destination as! TodoLIstViewController
            seg.workoutItems = self.workoutItems
        } else if segue.identifier == "goToCardio" {
            let seg = segue.destination as! CardioWorkoutTableViewController
            seg.arrayOfCardioWorkout = self.cardioWorkoutItems
        }
    }

}
