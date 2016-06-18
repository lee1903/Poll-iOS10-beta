//
//  AnswerPollViewController.swift
//  Poll
//
//  Created by Brian Lee on 5/27/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class AnswerPollViewController: UIViewController {
    
    var pollOptions: Int?
    var pollid: String?
    
    var selectedAnswer: UIButton?

    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    @IBOutlet weak var optionE: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var selectionIndicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        
        if pollOptions! < 5 {
            optionE.alpha = 0.1
            optionE.enabled = false
        }
        if pollOptions! < 4 {
            optionD.alpha = 0.1
            optionD.enabled = false
        }
        if pollOptions! < 3 {
            optionC.alpha = 0.1
            optionC.enabled = false
        }
        if pollOptions! < 2 {
            optionB.alpha = 0.1
            optionB.enabled = false
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupButtons() {
        optionA.layer.cornerRadius = 8
        optionB.layer.cornerRadius = 8
        optionC.layer.cornerRadius = 8
        optionD.layer.cornerRadius = 8
        optionE.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 8
        
        selectionIndicator.layer.cornerRadius = 8
        selectionIndicator.alpha = 0
    }
    
    func changeSelectedOption(option: UIButton) {
        selectedAnswer = option
        UIView.animateWithDuration(0.5) {
            self.selectionIndicator.alpha = 1
            self.selectionIndicator.center = CGPoint(x: self.selectionIndicator.center.x, y: self.selectedAnswer!.center.y)
        }
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        if(selectedAnswer == nil) {
            let alert = UIAlertController(title: "Uh oh!", message: "Looks like you haven't selected an answer yet. Please select an answer before submitting.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var response: String?
            
            switch selectedAnswer!.titleLabel!.text! {
            case "A":
                response = "0"
            case "B":
                response = "1"
            case "C":
                response = "2"
            case "D":
                response = "3"
            case "E":
                response = "4"
            default:
                print("error with switch statement")
            }
            
            if response != nil {
                APIClient.answerPoll(pollid!, response: response!) { (error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        print("succesfully answered poll")
                        
                        self.dismissViewControllerAnimated(true) {
                        }
                    }
                }
            } else {
                print("error with switch statement")
            }
            
        }
    }

    @IBAction func onClickA(sender: AnyObject) {
        changeSelectedOption(optionA)
    }
    
    @IBAction func onClickB(sender: AnyObject) {
        changeSelectedOption(optionB)
    }
    
    @IBAction func onClickC(sender: AnyObject) {
        changeSelectedOption(optionC)
    }
    
    @IBAction func onClickD(sender: AnyObject) {
        changeSelectedOption(optionD)
    }
    
    @IBAction func onClickE(sender: AnyObject) {
        changeSelectedOption(optionE)
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
