import UIKit

class CardioSummaryCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var summaryView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var averageSpeedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        summaryView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
