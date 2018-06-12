//
//  ViewController.swift
//  NinhTweeter
//
//  Created by Ninh Nguyen on 6/12/18.
//  Copyright © 2018 Ninh Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let maxTweetSize = 50

    @IBOutlet weak var tbTweet: UITableView!
    @IBOutlet weak var tfTweet: UITextField!
    
    @IBOutlet weak var lcVTextBottom: NSLayoutConstraint!
    
    var listTweets = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpForKeyBoard()
        
        tbTweet.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.releaseForKeyBoard()
    }
    
    // MARK: - Keyboard return
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField return")
        if self.postTweetWithText(textField.text!) {
            textField.text = ""
        }
        return false
    }
    
    func postTweetWithText(_ text: String) -> Bool {
        if text.count == 0 {
            self.showAlert("Please enter your text!")
            return false
        }
        else if text.count <= maxTweetSize {
            listTweets.append(text)
            let indexPath = IndexPath(row: listTweets.count - 1, section: 0)
            self.tbTweet.insertRows(at: [indexPath], with: .none)
        }
        else {
            //var listTweetsTemp = [String]()
            //var numberOfText
            
            var textArray:[[String]]? = [[String]]()
            textArray!.append([String]())
            
            var currentCharInLine = 0
            
            let arrayText = text.split(separator: " ")
            
            for str in arrayText {
                if str.count > maxTweetSize {
                    self.showAlert("A string span of nonwhite space character > \(maxTweetSize)")
                    return false
                }
                else {
                    if currentCharInLine == 0 {
                        textArray![textArray!.count - 1].append(String(str))
                        currentCharInLine += str.count
                    }
                    else {
                        if ((currentCharInLine + str.count + 1) > maxTweetSize) {
                            textArray!.append([String]())
                            // Create new line
                            textArray![textArray!.count - 1].append(String(str))
                            currentCharInLine = str.count
                        }
                        else {
                            textArray![textArray!.count - 1].append(String(str))
                            currentCharInLine += str.count + 1
                        }
                    }
                }
            }
            
            textArray = self.getTextArray(textArray!)
            // add to listTweets
        }
        
        return true
    }
    
    func getTextArray(_ textArray:[[String]]) -> [[String]]? {
        return textArray
    }
    
    
    // MARK: - Keyboard
    
    func setUpForKeyBoard() {
        // register key board
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func releaseForKeyBoard() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        //print("keyboard displaing!!")
        //
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        var kbRect:CGRect = keyboardFrame.cgRectValue
        
        kbRect = self.view.convert(kbRect, to: nil)
        let kbSize = kbRect.size
        
        let duration:NSNumber = info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        
        self.lcVTextBottom.constant = kbSize.height
        UIView.animate(withDuration: duration.doubleValue) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        //print("keyboard hidding!!")
        //
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let duration:NSNumber = info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        
        self.lcVTextBottom.constant = 0.0
        UIView.animate(withDuration: duration.doubleValue) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        //
        let str = listTweets[indexPath.row]
        cell.textLabel?.text = str
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(str.count)"
        //
        return cell
    }
}

extension ViewController {
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
