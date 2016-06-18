//
//  HistoryViewController.swift
//  Poll
//
//  Created by Brian Lee on 6/3/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var polls: [Poll]?
    var deletePollIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        getHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PollDetailView" {
            let vc = segue.destinationViewController as! PollDetailViewController
            let poll = sender as! Poll
            vc.poll = poll
        }
    }
    
    func getHistory() {
        APIClient.getHistory(User.currentUser!.id!) { (polls, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                self.polls = polls
                self.tableView.reloadData()
            }
        }
    }
    
    func confirmDelete(pollToDelete: Poll) {
        let alert = UIAlertController(title: "Delete Poll", message: "Are you sure you want to permanently delete \(pollToDelete.title!)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePoll)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePoll)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeletePoll(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePollIndex {
            tableView.beginUpdates()
            
            print(indexPath.row)
            print(polls![indexPath.row])
            
            APIClient.deletePoll(polls![indexPath.row].server_id!, completion: { (error) in
                if error != nil {
                    print("error deleting poll")
                } else {
                    self.polls!.removeAtIndex(indexPath.row)
                    
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    self.deletePollIndex = nil
                }
            })
        
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePoll(alertAction: UIAlertAction!) {
        deletePollIndex = nil
    }

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if polls != nil {
            return polls!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PollDetailCell", forIndexPath: indexPath) as! PollDetailCell
        cell.poll = polls![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("PollDetailView", sender: polls![indexPath.row])
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deletePollIndex = indexPath
            let pollToDelete = polls![indexPath.row]
            confirmDelete(pollToDelete)
        }
    }
}
