import UIKit

class BMIfoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var newstatus: Int = 0
    var fstatus: Int?
    let bio = ["gender","height","weight","age","activity"]
    let under = ["under_milk.jpg","under_redmeat.jpg","under_nuts.jpeg","under_cheese.jpg"]
    let under_names = ["Milk", "Red Meat", "Nuts", "Cheese"]
    let normal = ["normal_dryfruit.jpg", "normal_salmon.jpg", "normal_eggs.jpg","normal_avocado.jpg"]
    let normal_names = ["Dry Fruits", "Salmon", "Egggs", "Avocado"]
    let pre = ["pre_fish.jpg","pre_poultry.jpg","pre_quinoa.jpg","pre_beans.jpg"]
    let pre_names = ["Fish", "Poultry", "Quinoa", "Beans"]
    let obese = ["obese_chickenbreast.jpg","obese_grains.jpg","obese_vegs.jpeg","obese_fruits.jpg"]
    let obese_names = ["Chicken Breast", "Grains", "Vegs", "Fruits"]
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(under.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return(100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(2) as! UIImageView
        let name = cell.viewWithTag(1) as! UILabel
        if(newstatus == 0){
            img.image = UIImage(named: under[indexPath.row])
            name.text = under_names[indexPath.row]
        }else if(newstatus == 1){
            img.image = UIImage(named: normal[indexPath.row])
            name.text = normal_names[indexPath.row]
        }else if(newstatus == 2){
            img.image = UIImage(named: pre[indexPath.row])
            name.text = pre_names[indexPath.row]
        }else if(newstatus == 3){
            img.image = UIImage(named: obese[indexPath.row])
            name.text = obese_names[indexPath.row]
        }
        return(cell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
