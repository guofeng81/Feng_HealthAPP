import UIKit

class VideoCell: UITableViewCell {
    @IBOutlet var playButton: UIButton!
    @IBOutlet var videoCellImageView: UIImageView!
    @IBOutlet var videoCellView: UIView!
    @IBOutlet var videoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
