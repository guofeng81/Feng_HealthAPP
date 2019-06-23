import Foundation
import RealmSwift

class WorkoutHistoryItem:Object{
    @objc dynamic var type: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var totalDistance: Double = 0.0
    @objc dynamic var averageSpeed: Double = 0.0
    @objc dynamic var currentDate: String = ""
    @objc dynamic var currentDateTime: String = ""
    let subworkoutItems = List<SubworkoutHistoryItem>()
}
