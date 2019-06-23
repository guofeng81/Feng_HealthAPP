import UIKit

class WorkoutTableViewCell: UITableViewCell {
    @IBOutlet var bodyView: UIView!
    @IBOutlet var strengthView: UIView!
    @IBOutlet var workoutCellView: UIView!
    
    @IBOutlet var strengthLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var middleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        workoutCellView.layer.cornerRadius = 10
        bodyView.layer.cornerRadius = 5
        strengthView.layer.cornerRadius = 5
        bodyView.backgroundColor = UIColor.flatGray
        strengthView.backgroundColor = UIColor.flatBlue
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
