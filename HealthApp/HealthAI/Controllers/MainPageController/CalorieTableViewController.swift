import UIKit
import RealmSwift

class CalorieTableViewController: UITableViewController {
    let realm = try! Realm()
    var resultModel : Results<CalorieDataModel>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCalorieHistory()
    }
    
    func loadCalorieHistory(){
        resultModel = realm.objects(CalorieDataModel.self)
        tableView.reloadData()
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultModel?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let food = cell.viewWithTag(1) as! UILabel
        let cal = cell.viewWithTag(2) as! UILabel
        let meal = cell.viewWithTag(3) as! UILabel
        
        if let calorie = resultModel?[indexPath.row]{
            food.text = calorie.foodName
            cal.text = calorie.calorieCount
            meal.text = calorie.mealTypeData
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  .delete{
            do{
                try self.realm.write{
                    self.realm.delete(self.resultModel![indexPath.row])
                }
            }catch{
                print("Error delelting the the item using realm")
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
}
