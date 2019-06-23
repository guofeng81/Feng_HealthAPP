import UIKit

class WorkoutCell: UITableViewCell {

    @IBOutlet var workoutTitle: UILabel!
    @IBOutlet var workoutImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
