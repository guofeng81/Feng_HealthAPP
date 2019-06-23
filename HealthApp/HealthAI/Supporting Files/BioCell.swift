import UIKit

class BioCell: UITableViewCell {
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var bioTitle: UILabel!
    @IBOutlet var bioImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
