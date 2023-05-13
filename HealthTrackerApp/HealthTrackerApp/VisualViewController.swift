//Health Tracker
//Deecon Precht
    //dgprecht@iu.edu
//Nicholas Van Burk
    //ndvanbur@iu.edu
//28 APR 2023

import UIKit

class VisualViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var graphview: UIView!
    
    @IBAction func toggleSwitched(_ sender: Any) {
        //for when the toggle switches modes
        graphview.subviews.first?.removeFromSuperview()
        var x = [ 0, 0 , 0 ,0 , 0]
        if(tracker == 0){
            if let tmp = currHRs {
                for i in 0..<5 {
                    if(i < tmp.count){
                        x[i] = Int(tmp[i].value) * 2;
                    }
                }
            }
            graphview.addSubview(drawGraph(values: x, frame: graphview.frame))
            tracker = 1;
        }else{
            
            if let tmp = currWeights {
                for i in 0..<5 {
                    if(i < tmp.count){
                        x[i] = Int(tmp[i].value);
                    }
                }
            }
            graphview.addSubview(drawGraph(values: x, frame: graphview.frame));
            tracker = 0
            
        }
    }
    var tracker = 1;
    var appDelegate: AppDelegate?
    var model: User?
    var isWeight = false;// <-- tracker for mode we're currently in
    var currWeights: [WtMeasurment]?
    var currHRs : [HrMeasurment]?
    
    @IBOutlet weak var toggle: UISwitch!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        // Do any additional setup after loading the view.
        if let mdl = model {
            mdl.reloadWtAndHr()
            currWeights = mdl.getWeightMeasurments()
            currHRs = mdl.getHRMeasurments()
        }
        //let x = [299, 44, 33, 289 , 139] //dummy values for testing
        var x = [ 0, 0 , 0 ,0 , 0]
        if let tmp = currHRs {
            for i in 0..<5 {
                if(i < tmp.count){
                    x[i] = Int(tmp[i].value) * 2;
                }
            }
        }
        graphview.addSubview(drawGraph(values: x, frame: graphview.frame))
    }
    //https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer
    
    func drawGraph(values: [Int], frame: CGRect) -> UIView {
        let graphView = UIView(frame: frame)
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        let image = renderer.image { context in
            //draws the axis
            context.cgContext.move(to: CGPoint(x: 0, y: frame.height - 100))
            context.cgContext.addLine(to: CGPoint(x: frame.width, y: frame.height - 100))
            context.cgContext.move(to: CGPoint(x: 0, y: 0))
            context.cgContext.addLine(to: CGPoint(x: 0, y: frame.height - 100))
            context.cgContext.strokePath()

    
            let xValues = [30, 90, 150, 210, 270]// <-- spacing values for entries
            for i in 0..<5 {
                let x = xValues[i]
                let y = frame.height - (CGFloat(values[i]) * frame.height / 300) //scale and plot
                let point = CGPoint(x: (Double(x)) , y: Double(y))
                let circle = UIBezierPath(arcCenter: point, radius: 5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                UIColor.red.setFill()
                circle.fill()
            }
        }
        // Set the image as the content of the graph view
        let imageView = UIImageView(image: image)
        graphView.addSubview(imageView)
        
        return graphView
    }
}

