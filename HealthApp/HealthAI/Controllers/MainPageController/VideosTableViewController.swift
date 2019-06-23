import UIKit
import AVKit

class VideosTableViewController: UITableViewController {
    let videos = ["BBC","BRC","DIC","CPC","ATD","CRP","CCGSR","CWGR","CWGLP","PO","BS","SM","BD","BMC","BBP","DFBF","DIBCP","DIBF","PU"]
    let videoTitles = ["Barbell Biceps Curl","Barbell Reverse Curl","Dumbbell Incline Curls","Cable Preacher Curls","Assisted Triceps Dip","Cable Rope Pushdowns","Cable Close Grip Seated Row","Cable Wide Grip Row","Cable Wide Grip Lat Pulldown","Pullover","Bodyweight Squat","Superman","Bench Dip","Bodyweigth Mountain Climbers","Barbell Bench Press","Dumbbell Flat Bench Fly","Dumbbell Incline Bench Chest Press","Dumbbell Incline Bench Fly","Push Up"]
    let imagesArray = ["workout11","workout21","workout3","workout4","workout5","workout6","workout7","workout8","workout9","workout10","workout11","workout21","workout3","workout4","workout5","workout6","workout7","workout8","workout9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoTitles.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.videoTitleLabel.text = videoTitles[indexPath.row]
        cell.videoTitleLabel.text = videoTitles[indexPath.row]
        cell.videoCellImageView.image = UIImage(named: imagesArray[indexPath.row])
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(videoplayPressed(sender:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Video Tutorials"
    }

    @objc func videoplayPressed(sender: UIButton) {
        for index in 0..<videos.count {
            if sender.tag == index {
                playVideo(videoName: videos[index])
            }
        }
    }
    
    func playVideo(videoName: String){
        if let path = Bundle.main.path(forResource: videoName, ofType: "MOV"){
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            present(videoPlayer,animated: true,completion: {
                video.play()
            })
        }
    }
}

