import UIKit
import RealmSwift
import AVKit

protocol DataTransferDelegate:class {
    func userDidFinishedSubworkout(subworkoutItem:SubworkoutItem)
}

class WorkoutClockViewController: UIViewController {
    @IBOutlet var startBtn: UIButton!
    var time:Int = 0
    var timer:Timer? = nil
    var delegate : DataTransferDelegate?
    var selectedSubworkoutItem = SubworkoutItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endWorkoutPressed(sender:)))
        setupButtons()
        
    }

    @objc func endWorkoutPressed(sender:AnyObject){
        self.saveWorkout()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupButtons(){
        let normalGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        startBtn.addGestureRecognizer(normalGesture)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector((longTap(_:))))
        startBtn.addGestureRecognizer(longGesture)
        startBtn.layer.cornerRadius = startBtn.frame.width / 2
        startBtn.clipsToBounds = true
        setupButtonImage(imageName: "play")
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func saveWorkout(){
        selectedSubworkoutItem.time = time
        selectedSubworkoutItem.done = true
        delegate!.userDidFinishedSubworkout(subworkoutItem: selectedSubworkoutItem)
    }
    
    @objc func action(){
        time += 1
        let minutesPortion = String(format: "%02d", self.time / 60)
        let secondsPortion = String(format: "%02d", self.time % 60)
        timeLabel.text = "\(minutesPortion):\(secondsPortion)"
    }
    
    @objc func longTap(_ sender:UIGestureRecognizer){
        if time != 0 {
            time = 0
            let minutesPortion = String(format: "%02d", self.time / 60)
            let secondsPortion = String(format: "%02d", self.time % 60)
            timeLabel.text = "\(minutesPortion):\(secondsPortion)"
        }
    }
    
    @objc func normalTap(_ sender:UIGestureRecognizer) {
        if timer != nil {
            setupButtonImage(imageName: "play")
            timer!.invalidate()
            timer = nil
        }else{
            setupButtonImage(imageName: "pause")
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WorkoutClockViewController.action),userInfo: nil, repeats: true)
        }
    }
    
    func setupButtonImage(imageName:String){
        let startBtnimage = UIImageView()
        startBtnimage.frame = startBtn.frame
        startBtnimage.contentMode = .scaleAspectFit
        startBtnimage.clipsToBounds = true
        startBtnimage.image = UIImage(named: imageName)
        startBtn.addSubview(startBtnimage)
    }
    
    @IBAction func videoPlayBtn(_ sender: UIButton) {
        if let path = Bundle.main.path(forResource: selectedSubworkoutItem.videoName, ofType: "MOV"){
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            present(videoPlayer,animated: true,completion: {
                video.play()
                
            })
        }
    }
}
