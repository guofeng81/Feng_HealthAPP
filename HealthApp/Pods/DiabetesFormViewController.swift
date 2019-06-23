import UIKit
import Firebase

class DiabetesFormViewController: UIViewController {
    
    @IBOutlet weak var glucoseValue: UITextField!
    @IBOutlet weak var heightValue: UITextField!
    @IBOutlet weak var weightValue: UITextField!
    @IBOutlet weak var bloodPressureValue: UITextField!
    @IBOutlet weak var ageValue: UITextField!
    @IBOutlet weak var predictRiskButton: UIButton!
    @IBOutlet weak var diabetesPedigreeValue: UITextField!
    @IBOutlet weak var ageSubView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var bloodPressureSubView: UIView!
    @IBOutlet weak var bloodPressureView: UIView!
    @IBOutlet weak var weightSubView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var heightSubView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var glucoseView: UIView!
    @IBOutlet weak var glucoseSubView: UIView!
    let bio = ["gender","height","weight","glucose","bloodpressure"]
    var newValues = [String]()
    var score:Int = 0
    var scoreValue:Int = 0
    let url  = URL(string: "https://f58cbluk1h.execute-api.us-east-1.amazonaws.com/ver1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserDetails()
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        predictRiskButton.layer.cornerRadius = 20
        glucoseView.layer.cornerRadius = 20
        glucoseView.layer.masksToBounds = true;
        glucoseSubView.layer.cornerRadius = 20
        glucoseSubView.layer.masksToBounds = true;
        glucoseSubView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        heightView.layer.cornerRadius = 20
        heightView.layer.masksToBounds = true;
        heightSubView.layer.cornerRadius = 20
        heightSubView.layer.masksToBounds = true;
        heightSubView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        weightView.layer.cornerRadius = 20
        weightView.layer.masksToBounds = true;
        weightSubView.layer.cornerRadius = 20
        weightSubView.layer.masksToBounds = true;
        weightSubView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bloodPressureView.layer.cornerRadius = 20
        bloodPressureView.layer.masksToBounds = true;
        bloodPressureSubView.layer.cornerRadius = 20
        bloodPressureSubView.layer.masksToBounds = true;
        bloodPressureSubView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        ageView.layer.cornerRadius = 20
        ageView.layer.masksToBounds = true;
        ageSubView.layer.cornerRadius = 20
        ageSubView.layer.masksToBounds = true;
        ageSubView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    typealias CompletionHandler = (_ value: Int) -> Void
    
    func checkUserDetails(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with : nil, afterDelay:0)
        }
        else{
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("profile").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as? NSDictionary
                for index in 0..<self.bio.count{
                    let value = dictionary![self.bio[index]] as! String
                    self.newValues.append(value)
                }
                self.heightValue.text = self.newValues[1]
                self.weightValue.text = self.newValues[2]
                self.glucoseValue.text = self.newValues[3]
                self.bloodPressureValue.text = self.newValues[4]
            
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }
        catch let logoutError{
            print(logoutError)
        }
    }
    
    @IBAction func viewPrediction(_ sender: Any) {
        performSegue(withIdentifier: "scoreToFuturePrediction", sender: self)
    }
    
    func postAndGetData(url: URL, completion:@escaping CompletionHandler){
        let yourBMIValue = Float(weightValue.text!)!/(powf(Float(heightValue.text!)!/100, 2))
        let json: [String: Any] = ["Glucose":Float(glucoseValue.text!)!, "BloodPressure":Float(bloodPressureValue.text!)!, "BMI":yourBMIValue, "DiabetesPedigreeFunction" : 0.5, "Age" : Float(ageValue.text!)! ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do{
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Int] {
                        print("printSomething")
                        print(responseJSON)
                        self.score = responseJSON["Score"]!
                    }
                }
            }
            else {
                print(error!.localizedDescription)
            }
        }
        completion(self.score)
        task.resume()

    }
    
    @IBAction func trackButton(_ sender: Any) {
        if self.heightValue.text == "" || self.weightValue.text == "" || self.glucoseValue.text == "" || self.bloodPressureValue.text == "" || self.ageValue.text == "" {
            
            let alert = UIAlertController(title: "Field is empty", message: "Please fill in all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in alert.dismiss(animated: true, completion: nil)}
            ))
            self.present(alert,animated: true,completion: nil)
            
        }
        else{
                if let url = url {
                    postAndGetData(url: url) { (value) in
                        self.score = value
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            self.performSegue(withIdentifier: "formToScorePage", sender: self)
                        }
                    }
                }
          }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formToScorePage"{
            let scorePageValue = segue.destination as! DiabetesScoreViewController
            scorePageValue.scoreValue = score
            scorePageValue.ageValue = Int(ageValue.text!)!
            scorePageValue.glucoseValue = Int(glucoseValue.text!)!
        }
    }
    
}
