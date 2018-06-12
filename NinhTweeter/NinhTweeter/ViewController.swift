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
            
            if let finalTextArray = self.getTextArray(&textArray!) {
                // add to listTweets
                let numberOfLine = finalTextArray.count
                for i in 0..<numberOfLine {
                    let prefixStr = "\(i + 1)/\(numberOfLine) "
                    var text = prefixStr
                    for str in finalTextArray[i] {
                        text += " " + str
                    }
                    
                    //
                    listTweets.append(text)
                }
                
                var indexs = [IndexPath]()
                for i in 0..<numberOfLine {
                    let indexPath = IndexPath(row: listTweets.count - i - 1, section: 0)
                    //
                    indexs.append(indexPath)
                }
                self.tbTweet.insertRows(at: indexs, with: .none)
            }
            else {
                self.showAlert("A string span of nonwhite space character and prefix > \(maxTweetSize)")
                return false
            }
        }
        
        return true
    }
    
    func getTextArray(_ textArray:inout [[String]]) -> [[String]]? {
        let numberOfLine = textArray.count
        for i in 0..<numberOfLine {
            let prefixStr = "\(i + 1)/\(numberOfLine)"
            let lenghtOfPrefix = prefixStr.count + 1 // 1 for space
            //
            var totalLenght = lenghtOfPrefix
            for j in 0..<textArray[i].count  {
                let str = textArray[i][j]
                totalLenght += str.count + 1
                if (totalLenght > 50) {
                    //
                    if (j == 0) { // line empty
                        return nil
                    }
                    //
                    // Create new line
                    var newLine = [String]()
                    for k in j..<textArray[i].count {
                        newLine.append(textArray[i][k])
                    }
                    if textArray.count != (i + 1) {
                        newLine += textArray[i + 1]
                    }
                    // Make old line
                    var oldLine = [String]()
                    for l in 0..<j {
                        oldLine.append(textArray[i][l])
                    }
                    if textArray.count != (i + 1) {
                        textArray[i + 1] = newLine
                    }
                    else {
                        textArray.append(newLine)
                    }
                    
                    textArray[i] = oldLine
                    
                    return self.getTextArray(&textArray)
                }
            }
        }
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
