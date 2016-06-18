//
//  PollingViewController.swift
//  Poll
//
//  Created by Brian Lee on 5/26/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import JBChartView
import Foundation

class PollingViewController: UIViewController {
    
    var currentPoll: Poll?
    let colors = [UIColor(red:0.15, green:0.35, blue:0.34, alpha:1.0), UIColor(red:0.93, green:0.92, blue:0.83, alpha:1.0), UIColor(red:0.66, green:0.53, blue:0.26, alpha:1.0), UIColor(red:0.34, green:0.77, blue:0.28, alpha:1.0), UIColor(red:0.26, green:0.49, blue:0.56, alpha:1.0)]

    var barViews: [UIView] = [UIView(), UIView(), UIView(), UIView(), UIView()]
    var labelsHidden = true
    var updater: NSTimer?
    var startTime = NSTimeInterval()

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var barChartView: JBBarChartView!
    @IBOutlet weak var barChartContainerView: UIView!
    @IBOutlet weak var singleCounterLabel: UILabel!
    
    @IBOutlet weak var aCountLabel: UILabel!
    @IBOutlet weak var bCountLabel: UILabel!
    @IBOutlet weak var cCountLabel: UILabel!
    @IBOutlet weak var dCountLabel: UILabel!
    @IBOutlet weak var eCountLabel: UILabel!
    @IBOutlet weak var counterContainerView: UIView!
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    @IBOutlet weak var eLabel: UILabel!
    @IBOutlet weak var labelContainerView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var endButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = "\(currentPoll!.id!)"
        
        endButton.layer.cornerRadius = 8
        
        setupBarChart()
        setupBarViews()
        hideLabels()
        setupSingleCounter()
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
        updater = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(PollingViewController.updateStats), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
         setupLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimer() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        let minutes = UInt8(elapsedTime/60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timerLabel.text = "\(strMinutes):\(strSeconds)"
    }
    
    func setupSingleCounter() {
        singleCounterLabel.hidden = true
        
        if currentPoll!.optionsCount! == 1 {
            counterContainerView.hidden = true
            barChartContainerView.hidden = true
            singleCounterLabel.hidden = false
            singleCounterLabel.text = "0"
        }
    }
    
    func hideLabels() {
        counterContainerView.alpha = 0
        labelContainerView.alpha = 0
    }
    
    func showLabels() {
        UIView.animateWithDuration(1.0) {
            self.counterContainerView.alpha = 1
            self.labelContainerView.alpha = 1
        }
        
        labelsHidden = false
    }
    
    func setupBarViews() {
        
        for i in 0...4 {
            barViews[i].backgroundColor = colors[i]
        }

    }
    
    func updateStats() {
        
        updateTimer()
        
        APIClient.getPollStats(currentPoll!.id!) { (stats, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                self.currentPoll!.stats = stats!
            }
        }
        
        if currentPoll!.optionsCount! == 1 {
            singleCounterLabel.text = "\(self.currentPoll!.stats![0].count)"
        } else {
            barChartView.reloadDataAnimated(true)
            updateTotalLabels()
        }

    }
    
    func setupLabels() {
        aCountLabel.text = "0"
        bCountLabel.text = "0"
        cCountLabel.text = "0"
        dCountLabel.text = "0"
        eCountLabel.text = "0"
        
        if currentPoll!.optionsCount! > 1 {
            aCountLabel.center = CGPoint(x: (barViews[0].center.x), y: (counterContainerView.frame.height/2))
            bCountLabel.center = CGPoint(x: (barViews[1].center.x), y: (counterContainerView.frame.height/2))
            
            aLabel.center = CGPoint(x: (barViews[0].center.x), y: (labelContainerView.frame.height/2))
            bLabel.center = CGPoint(x: (barViews[1].center.x), y: (labelContainerView.frame.height/2))
        }
        if currentPoll!.optionsCount! > 2 {
            cCountLabel.center = CGPoint(x: (barViews[2].center.x), y: (counterContainerView.frame.height/2))
            
            cLabel.center = CGPoint(x: (barViews[2].center.x), y: (labelContainerView.frame.height/2))
        }
        if currentPoll!.optionsCount! > 3 {
            dCountLabel.center = CGPoint(x: (barViews[3].center.x), y: (counterContainerView.frame.height/2))
            
            dLabel.center = CGPoint(x: (barViews[3].center.x), y: (labelContainerView.frame.height/2))
        }
        if currentPoll!.optionsCount! > 4 {
            eCountLabel.center = CGPoint(x: (barViews[4].center.x), y: (counterContainerView.frame.height/2))
            
            eLabel.center = CGPoint(x: (barViews[4].center.x), y: (labelContainerView.frame.height/2))
        }
        
        if currentPoll!.optionsCount! < 2 {
            aCountLabel.hidden = true
            bCountLabel.hidden = true
            
            aLabel.hidden = true
            bLabel.hidden = true
        }
        if currentPoll!.optionsCount! < 3 {
            cCountLabel.hidden = true
            
            cLabel.hidden = true
        }
        if currentPoll!.optionsCount! < 4 {
            dCountLabel.hidden = true
            
            dLabel.hidden = true
        }
        if currentPoll!.optionsCount! < 5 {
            eCountLabel.hidden = true
            
            eLabel.hidden = true
        }
        
    }
    
    func updateTotalLabels() {
        if labelsHidden {
            var count = 0
            for i in 0...(currentPoll!.optionsCount!-1) {
                count += currentPoll!.stats![i].count
            }
            
            if count > 0 {
                showLabels()
            }
        }
        
        if currentPoll!.optionsCount! > 1 {
            aCountLabel.text = "\(currentPoll!.stats![0].count)"
            bCountLabel.text = "\(currentPoll!.stats![1].count)"
        }
        if currentPoll!.optionsCount! > 2 {
            cCountLabel.text = "\(currentPoll!.stats![2].count)"
        }
        if currentPoll!.optionsCount! > 3 {
            dCountLabel.text = "\(currentPoll!.stats![3].count)"
        }
        if currentPoll!.optionsCount! > 4 {
            eCountLabel.text = "\(currentPoll!.stats![4].count)"
        }
    }

    @IBAction func onEnd(sender: AnyObject) {
        self.updater!.invalidate()
        
        APIClient.endPoll(currentPoll!) { (error) in
            if(error != nil) {
                print(error?.localizedDescription)
            } else {
                self.dismissViewControllerAnimated(true, completion: {
                })
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PollingViewController: JBBarChartViewDelegate, JBBarChartViewDataSource {
    func setupBarChart() {
        barChartView.delegate = self
        barChartView.dataSource = self
        
        barChartView.backgroundColor = UIColor.clearColor()
        barChartView.minimumValue = CGFloat(0)
        barChartView.maximumValue = CGFloat(5)
        
        barChartView.reloadDataAnimated(true)
    }
    
//    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
//        return colors[Int(index)]
//    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        return barViews[Int(index)]
    }
    
    func barSelectionColorForBarChartView(barChartView: JBBarChartView!) -> UIColor! {
        return UIColor.clearColor()
    }
    
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        if currentPoll!.optionsCount == nil {
            return 0
        } else {
            return UInt(currentPoll!.optionsCount!)
        }
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        if currentPoll!.stats == nil {
            return 0
        } else {
            let height = currentPoll!.stats![Int(index)].count
            return CGFloat(height)
        }
    }
}
