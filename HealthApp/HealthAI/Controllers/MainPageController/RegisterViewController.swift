import UIKit
import Firebase
import SVProgressHUD
import TKSubmitTransition

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegisterView()
        
    }
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func registeredPressed(_ sender: TKTransitionSubmitButton) {
        SVProgressHUD.show()
        if let email = emailTextField.text, let password = passwordTextField.text,let confirmPassword = confirmPasswordTextField.text, (email.count > 0 && password.count > 0 && confirmPassword.count > 0) {
            
            if confirmPassword != password {
                createAlert(controllertitle: "Error Message", message: "Password does not match the confirm password.", actionTitle: "Ok")
                sender.shake()
                SVProgressHUD.dismiss()
            }else{
                AuthServices.instance.signup(email: email, password: password) { (errMsg, data) in
                    guard errMsg == nil else {
                        
                        self.createAlert(controllertitle: "Error Authentication", message: errMsg!, actionTitle: "Ok")
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    self.performSegue(withIdentifier: "goToHealthMain", sender: self)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                    SVProgressHUD.dismiss()
                }
            }
        }else{
            createAlert(controllertitle: "Username and Password Required", message: "You must provide both username and password", actionTitle: "Ok")
            SVProgressHUD.dismiss()
            sender.shake()
            
        }
    }
    
    func createAlert(controllertitle: String,message: String,actionTitle: String){
        let alert = UIAlertController(title: controllertitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupRegisterView(){
        emailTextField.setPadding()
        emailTextField.underlined()
        passwordTextField.setPadding()
        passwordTextField.underlined()
        confirmPasswordTextField.setPadding()
        confirmPasswordTextField.underlined()
        registerBtn.layer.cornerRadius = 25.0
        registerBtn.clipsToBounds = true
    }
    
}

