import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var updateBtn: UIButton!
    @IBOutlet var editProfileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
