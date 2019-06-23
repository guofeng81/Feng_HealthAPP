import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import SVProgressHUD
import RealmSwift
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        SVProgressHUD.show()
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signInAndRetrieveData(with: credential) { (auth, error) in
            if error != nil {
                print(error!)
            }else{
                //user signed in with google
                AuthServices.createUserProfile()
                SVProgressHUD.dismiss()
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let myNewVC = mainStoryboard.instantiateViewController(withIdentifier: "HealthMain") as! HealthMainViewController
                let navController = UINavigationController(rootViewController: myNewVC)
                navController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController?.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        SVProgressHUD.dismiss()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                          annotation:options[UIApplication.OpenURLOptionsKey.annotation])
        
        return handled!
    }

    func applicationWillTerminate(_ application: UIApplication) {
        FBSDKLoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
    }


}

