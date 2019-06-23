import Foundation
import UIKit
import FirebaseStorage
import Firebase

class DatabaseHelper {
    
    
    static func loadDatabaseImage(databaseRef: DatabaseReference!, user: User, imageView: UIImageView,referenceName:String){
        
        databaseRef.child("profile").child(user.uid).observeSingleEvent(of: .value, with:{ (snapshop) in
            let dictionary = snapshop.value as? NSDictionary
            if let profileImageURL = dictionary?[referenceName] as? String {
                let url = URL(string: profileImageURL)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data!)
                    }
                    
                }).resume()
            }
        }){
            (error) in
            print(error.localizedDescription)
            return
        }
    }
    
    static func setDatabaseUsername(databaseRef: DatabaseReference!, user: User, label: UILabel){
        databaseRef.child("profile").child(user.uid).observeSingleEvent(of: .value, with:{ (snapshop) in
            
            let dictionary = snapshop.value as? NSDictionary
            
            label.text = dictionary?["username"] as? String
        })
    }
    
    
    static func savePictureToStorage(storageRef: StorageReference!, databaseRef: DatabaseReference!, user: User,imageView: UIImageView, imageName: String,referenceImageName: String){
        
        if let imageData: Data = imageView.image!.pngData() {
            let profilePicReference = storageRef.child("user_profile/\(user.uid)/\(imageName)")
            
            print("Profile Picture Reference:",profilePicReference)
            
            DispatchQueue.main.async {
                profilePicReference.putData(imageData, metadata: nil) { (metadata, error) in
                    if error == nil {
                        profilePicReference.downloadURL { (url, error) in
                            if let downloadUrl = url {
                                databaseRef.child("profile").child(user.uid).updateChildValues([referenceImageName:downloadUrl.absoluteString])
                            }else {
                                print("error downloading from the url!")
                            }
                        }
                    }else {
                        print("error putting the data into the storage.")
                    }
                }
            }
        }
    }
    
}
