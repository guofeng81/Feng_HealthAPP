import UIKit
import Charts

class GraphViewController: UIViewController {
    @IBOutlet weak var remainingCal: UILabel!
    @IBOutlet weak var currentCal: UILabel!
    @IBOutlet weak var goalCal: UILabel!
    @IBOutlet weak var piechart: PieChartView!
    var goalValue:Int = 0
    var currentValue:Int = 0
    var remainingValue:Int = 0
    var calorieScore  = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalCal.text = "\(goalValue)"
        currentCal.text = "\(currentValue)"
        remainingValue = goalValue - currentValue
        remainingCal.text = "\(remainingValue)"
        var currentDayCal = PieChartDataEntry(value: Double(exactly: currentValue)!, label: "Current")
        var remainingDayCal = PieChartDataEntry(value: Double(exactly: remainingValue)!, label: "Remaining")
        calorieScore = [currentDayCal, remainingDayCal]
        updateChart()
    }
    
    func updateChart(){
        piechart.chartDescription?.enabled = false
        piechart.drawHoleEnabled = false
        piechart.rotationAngle = 0
        piechart.rotationEnabled = false
        piechart.isUserInteractionEnabled = false
        let dataset = PieChartDataSet(values: calorieScore, label: "")
        dataset.colors = [UIColor.red, UIColor.blue]
        dataset.drawValuesEnabled = false
        piechart.data = PieChartData(dataSet: dataset)
    }
    
}

