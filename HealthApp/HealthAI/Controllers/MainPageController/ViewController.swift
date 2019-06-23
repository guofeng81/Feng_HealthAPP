import UIKit
import TKSubmitTransition
import GoogleSignIn
import FBSDKLoginKit
import Firebase
import SVProgressHUD
import UserNotifications

class ViewController: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate {
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    @IBAction func forgetPasswordBtn(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Forgot My Password", message: "To reset your password, please enter your email address.", preferredStyle: .alert);
        let sendAction = UIAlertAction(title: "Send", style: .default) { (action) in
            let emailField = alertController.textFields![0]
            if let email = emailField.text {
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if let error = error {
                        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        
                        self.createUserNotification()
                        
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter E-mail address"
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createUserNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Password reset"
        content.body = "Password email has been sent to your email."
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "passwordReset", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
    
    @IBAction func facebookLoginBtn(_ sender: UIButton) {
    
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Facebook Login fails:",error!)
            }
            
            if (result?.isCancelled)! {
                return
            }
            //exchanged with firebase credential
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    print(error)
                    return
                }
                self.fetchFacebookLoginResult()
                self.performSegue(withIdentifier: "goToHealthMain", sender: self)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("facebook log out")
    }
    
    func fetchFacebookLoginResult(){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"])?.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("failed to start the graph result.")
            }else{
                guard let result = result as? [String: Any] else {return}
                let name = result["name"] as? String
                
                AuthServices.createUserProfile(uName: name!)
                
            }
        })
    }
    
    @IBOutlet var facebookLoginBtn: UIButton!
    @IBOutlet var googleLoginBtn: GIDSignInButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (loginViewTapped))
        loginView.addGestureRecognizer(tapGesture)
        setupFacebookAndGoogleBtn()
    }
    
    func setupFacebookAndGoogleBtn(){
         facebookLoginBtn.layer.cornerRadius = facebookLoginBtn.frame.width/2
         facebookLoginBtn.clipsToBounds = true
         googleLoginBtn.layer.cornerRadius = googleLoginBtn.frame.width/2
         googleLoginBtn.clipsToBounds = true
    }
    
    
    @IBAction func googleLoginPressed(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func loginViewTapped() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 258
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupLoginView(){
        registerBtn.layer.cornerRadius  = 4
        emailTextField.setPadding()
        emailTextField.underlined()
        passwordTextField.setPadding()
        passwordTextField.underlined()
        loginBtn.layer.cornerRadius = 25.0
        loginBtn.clipsToBounds = true
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        if self.heightConstraint.constant > 200 {
            UIView.animate(withDuration: 0.5) {
                self.heightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
         self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    
    @IBAction func loginBtnPressed(_ sender: TKTransitionSubmitButton) {
       
        if let email = emailTextField.text, let password = passwordTextField.text, (email.count > 0 && password.count > 0) {
            AuthServices.instance.login(email: email, password: password) { (errMsg, data) in
                guard errMsg == nil else {
                    self.createAlert(controllertitle: "Error Authentication", message: errMsg!, actionTitle: "Ok")
                    sender.shake()
                    return
                }
                sender.animate(1, completion: {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: "goToHealthMain", sender: self)
                })
            }
        }else{
            createAlert(controllertitle: "Username and Password Required", message: "You must provide both username and password", actionTitle: "Ok")
            sender.shake()
        
        }
    }
    
    func createAlert(controllertitle: String,message: String,actionTitle: String){
        let alert = UIAlertController(title: controllertitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIButton {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}



