import Foundation
class Helper{
    static func setupDateFormatter(format:String,date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "CST")! as TimeZone
        return dateFormatter.string(from: date)
    }
}
