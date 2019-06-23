import Foundation

struct Section {
    var workoutTitle: String!
    var subworkouts: [String]!
    var times: [String]!
    var expanded: Bool!
    
    init(workoutTitle: String, subworkouts: [String],times:[String], expanded: Bool) {
        self.workoutTitle = workoutTitle
        self.subworkouts = subworkouts
        self.times = times
        self.expanded = expanded
    }
}
