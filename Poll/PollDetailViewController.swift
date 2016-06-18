//
//  PollDetailViewController.swift
//  Poll
//
//  Created by Brian Lee on 6/3/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import JBChartView

class PollDetailViewController: UIViewController {

    var poll: Poll?
    
    let colors = [UIColor(red:1.00, green:0.83, blue:0.57, alpha:1.0), UIColor(red:0.57, green:0.93, blue:1.00, alpha:1.0), UIColor(red:1.00, green:0.56, blue:0.62, alpha:1.0), UIColor(red:1.00, green:0.96, blue:0.57, alpha:1.0), UIColor(red:0.78, green:1.00, blue:0.57, alpha:1.0)]
    
    var barViews: [UIView] = [UIView(), UIView(), UIView(), UIView(), UIView()]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    @IBOutlet weak var eLabel: UILabel!
    
    @IBOutlet weak var counterContainerView: UIView!
    @IBOutlet weak var aCounterLabel: UILabel!
    @IBOutlet weak var bCounterLabel: UILabel!
    @IBOutlet weak var cCounterLabel: UILabel!
    @IBOutlet weak var dCounterLabel: UILabel!
    @IBOutlet weak var eCounterLabel: UILabel!

    
    @IBOutlet weak var barChartView: JBBarChartView!
    @IBOutlet weak var singleCounterLabel: UILabel!
    @IBOutlet weak var barChartContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        titleLabel.text = poll!.title!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        dateLabel.text = dateFormatter.stringFromDate(poll!.date!)
        
        setupBarChart()
        setupBarViews()
        hideLabels()
        setupSingleCounter()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        setupLabels()
        updateStats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSingleCounter() {
        singleCounterLabel.hidden = true
        
        if poll!.optionsCount! == 1 {
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
    }
    
    func setupBarViews() {
        
        for i in 0...4 {
            barViews[i].backgroundColor = colors[i]
        }
        
    }
    
    func updateStats() {
        if poll!.optionsCount! == 1 {
            singleCounterLabel.text = "\(self.poll!.stats![0].count)"
        } else {
            updateTotalLabels()
        }
    }
    
    func setupLabels() {
        aCounterLabel.text = "0"
        bCounterLabel.text = "0"
        cCounterLabel.text = "0"
        dCounterLabel.text = "0"
        eCounterLabel.text = "0"
        
        if poll!.optionsCount! > 1 {
            aCounterLabel.center = CGPoint(x: (barViews[0].center.x), y: (counterContainerView.frame.height/2))
            bCounterLabel.center = CGPoint(x: (barViews[1].center.x), y: (counterContainerView.frame.height/2))
            
            aLabel.center = CGPoint(x: (barViews[0].center.x), y: (labelContainerView.frame.height/2))
            bLabel.center = CGPoint(x: (barViews[1].center.x), y: (labelContainerView.frame.height/2))
        }
        if poll!.optionsCount! > 2 {
            cCounterLabel.center = CGPoint(x: (barViews[2].center.x), y: (counterContainerView.frame.height/2))
            
            cLabel.center = CGPoint(x: (barViews[2].center.x), y: (labelContainerView.frame.height/2))
        }
        if poll!.optionsCount! > 3 {
            dCounterLabel.center = CGPoint(x: (barViews[3].center.x), y: (counterContainerView.frame.height/2))
            
            dLabel.center = CGPoint(x: (barViews[3].center.x), y: (labelContainerView.frame.height/2))
        }
        if poll!.optionsCount! > 4 {
            eCounterLabel.center = CGPoint(x: (barViews[4].center.x), y: (counterContainerView.frame.height/2))
            
            eLabel.center = CGPoint(x: (barViews[4].center.x), y: (labelContainerView.frame.height/2))
        }
        
        if poll!.optionsCount! < 2 {
            aCounterLabel.hidden = true
            bCounterLabel.hidden = true
            
            aLabel.hidden = true
            bLabel.hidden = true
        }
        if poll!.optionsCount! < 3 {
            cCounterLabel.hidden = true
            
            cLabel.hidden = true
        }
        if poll!.optionsCount! < 4 {
            dCounterLabel.hidden = true
            
            dLabel.hidden = true
        }
        if poll!.optionsCount! < 5 {
            eCounterLabel.hidden = true
            
            eLabel.hidden = true
        }
        
    }
    
    func updateTotalLabels() {
        showLabels()
        
        if poll!.optionsCount! > 1 {
            aCounterLabel.text = "\(poll!.stats![0].count)"
            bCounterLabel.text = "\(poll!.stats![1].count)"
        }
        if poll!.optionsCount! > 2 {
            cCounterLabel.text = "\(poll!.stats![2].count)"
        }
        if poll!.optionsCount! > 3 {
            dCounterLabel.text = "\(poll!.stats![3].count)"
        }
        if poll!.optionsCount! > 4 {
            eCounterLabel.text = "\(poll!.stats![4].count)"
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowResponders" {
            let vc = segue.destinationViewController as! ResponderListViewController
            let data = sender as! [String]
            vc.responders = data
        }
    }

}

extension PollDetailViewController: JBBarChartViewDelegate, JBBarChartViewDataSource {
    func setupBarChart() {
        barChartView.delegate = self
        barChartView.dataSource = self
        
        barChartView.backgroundColor = UIColor.clearColor()
        barChartView.minimumValue = CGFloat(0)
        barChartView.maximumValue = CGFloat(5)
        
        barChartView.reloadDataAnimated(true)
    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        return barViews[Int(index)]
    }
    
    func barSelectionColorForBarChartView(barChartView: JBBarChartView!) -> UIColor! {
        return UIColor.clearColor()
    }
    
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        if poll!.optionsCount == nil {
            return 0
        } else {
            return UInt(poll!.optionsCount!)
        }
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        if poll!.stats == nil {
            return 0
        } else {
            let height = poll!.stats![Int(index)].count
            return CGFloat(height)
        }
    }

}

extension PollDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll!.optionsCount!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionCell", forIndexPath: indexPath) as! OptionCell
        
        switch indexPath.row {
        case 0:
            cell.optionLabel.text = "Users who responded A"
        case 1:
            cell.optionLabel.text = "Users who responded B"
        case 2:
            cell.optionLabel.text = "Users who responded C"
        case 3:
            cell.optionLabel.text = "Users who responded D"
        case 4:
            cell.optionLabel.text = "Users who responded E"
        default:
            cell.optionLabel.text = "Option"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowResponders", sender: poll!.stats![indexPath.row])
    }
}
