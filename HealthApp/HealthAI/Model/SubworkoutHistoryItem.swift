import Foundation
import RealmSwift

class SubworkoutHistoryItem:Object{    
    @objc dynamic var title: String = ""
    @objc dynamic var videoName: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var time: Int = 0
    var parentCategory = LinkingObjects(fromType: WorkoutHistoryItem.self, property: "subworkoutItems")
}

