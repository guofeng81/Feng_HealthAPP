import Foundation
import FirebaseAuth
import FirebaseDatabase

typealias Completion = (_ errMsg: String?,_ data: AnyObject?) -> Void

class AuthServices{
     var databaseRef : DatabaseReference! = Database.database().reference()
    private static let _instance = AuthServices()
    static var instance: AuthServices {
        return _instance
    }
    
    func login(email:String, password:String, onComplete: Completion?){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }else{
                onComplete?(nil,result?.user)
                print("Successfully Log In!!")
            }
        }
    }
    
    func signup(email:String, password:String, onComplete:Completion?){
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }else{
                AuthServices.createUserProfile()
                onComplete?(nil,result?.user)
            }
        }
    }
    
    
    static func createUserProfile(uName: String = (Auth.auth().currentUser?.email)!.components(separatedBy: "@")[0]){
        
        let user = Auth.auth().currentUser
        let email = user?.email
        
        let databaseRef = Database.database().reference().child("profile").queryOrdered(byChild: "email").queryEqual(toValue: email!)
        
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                print("User exist")
            }else{
                //create user profile
                let newUser = ["email":email,"username": uName,"photo":"https://firebasestorage.googleapis.com/v0/b/healthai-f2f6f.appspot.com/o/empty_profile.png?alt=media&token=d25ab88e-e758-407d-bed9-cb6def5385a6","backgroundPhoto":"https://firebasestorage.googleapis.com/v0/b/healthai-f2f6f.appspot.com/o/defaultBackgroundImage.jpg?alt=media&token=c02ab78a-a448-4449-ab56-b622846d472b", "gender":"","height": "","weight":"","glucose": "","bloodpressure":""]
                
                Database.database().reference().child("profile").child(user!.uid).setValue(newUser) { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }else{
                        print("Profile successfully created!")
                    }
                }
            }
        }
    }

    func handleFirebaseError(error: NSError, onComplete: Completion?){
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .invalidEmail:
                onComplete?("The email address is invalid, please try the valid email address", nil)
                break
            case .weakPassword:
                onComplete?("The password is weak, please try some strong password.", nil)
                break
            case .emailAlreadyInUse:
                onComplete?("The email address has already been used, please try other email address.", nil)
                break
            case .credentialAlreadyInUse:
                onComplete?("The email address has already exist in the system, please use other email address to sign up.",nil)
                break
            case .sessionExpired:
                onComplete?("The seesion has been expired, please try again.",nil)
                break
            case .wrongPassword:
                onComplete?("The password is invalid or the user does not have a password.",nil)
                break
            default:
                onComplete?("There is a problem authenticating, please try again.", nil)
            }
        }
    }
}




