import UIKit
import CoreMotion
import SwiftCharts
import Charts

class StepsstatsViewController: UIViewController {
    var target1 : Int = 0
    var chartView: BarsChart!
    let pedometer = CMPedometer()
    var days:[String] = []
    var stepsTaken:[Int] = []
    var months: [String]!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    class details {
        let stepsOutput: [Int]
        let daysstring: [String]
        init(stepoup: [Int], dayoup: [String]) {
            stepsOutput = stepoup
            daysstring = dayoup
        }
    }
    
    @IBAction func saveChart(_ sender: Any) {
        let graphImage = barChartView.getChartImage(transparent: false)
        UIImageWriteToSavedPhotosAlbum(graphImage!, nil, nil, nil)
    }
    
    @IBOutlet weak var barChartView: BarChartView!
    
    func getDataForLast7Days() ->details {
        var ddd = [Int]()
        var sttteps = [String]()
        
        if(CMPedometer.isStepCountingAvailable()){
            let serialQueue : DispatchQueue  = DispatchQueue(label: "com.example.MyQueue", attributes: .concurrent)
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            serialQueue.sync(execute: { () -> Void in
                let today = NSDate()
                for day in 3...10{
                    let from = NSDate(timeIntervalSinceNow: Double(-7+day) )
                    let hour = Calendar.current.component(.hour, from: from as Date)
                    let min = Calendar.current.component(.minute, from: from as Date)
                    let sec = Calendar.current.component(.second, from: from as Date)
                    let timeToSub = (hour * 60 + min) * 60 + sec
                    let fromDate = NSDate(timeIntervalSinceNow: (Double(-10+day) * (86400 ) ) - Double(timeToSub))
                    let toDate = NSDate(timeIntervalSinceNow: (Double(-10+day+1) * (86400) ) - Double(timeToSub))
                    let dtStr = formatter.string(from: (toDate as Date))
                    
                    self.pedometer.queryPedometerData(from: fromDate as Date , to: toDate as Date) { (data : CMPedometerData!, error) -> Void in
                        if(error == nil){
                            ddd.append(Int(data.numberOfSteps))
                            sttteps.append(dtStr)
                            self.days.append(dtStr)
                            self.stepsTaken.append(Int(data.numberOfSteps))
                        }
                    }
                }
            })
        }
        return details(stepoup: ddd, dayoup: sttteps)
    }
    
    func setChart(dataEntryX forX: [String], dataEntryY forY:[Double]) {
        var dataEntries: [BarChartDataEntry] = []
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Steps walked")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        for i in 0..<forX.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]), data: months as AnyObject?)
            dataEntries.append(dataEntry)
        }
        
        barChartView.data = chartData
        let xAxisValue = barChartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        barChartView.xAxis.labelPosition = .bottom
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        let ll = ChartLimitLine(limit: Double(target1), label: "Target")
        barChartView.rightAxis.addLimitLine(ll)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let record = getDataForLast7Days()
        axisFormatDelegate = self as! IAxisValueFormatter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(days[0],days[1],days[2],days[3],days[4],days[6],days[7])
        months = [days[0],days[1],days[2],days[3],days[4],days[6],days[7]]
        
        let unitsSold = [Double(stepsTaken[0]),Double(stepsTaken[1]),Double(stepsTaken[2]),Double(stepsTaken[3]),Double(stepsTaken[4]),Double(stepsTaken[6]),Double(stepsTaken[7])]
    
        setChart(dataEntryX: months, dataEntryY: unitsSold)
    }
}

extension StepsstatsViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}

