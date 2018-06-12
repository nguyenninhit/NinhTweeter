//
//  ViewController.swift
//  NinhTweeter
//
//  Created by Ninh Nguyen on 6/12/18.
//  Copyright © 2018 Ninh Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tbTweet: UITableView!
    @IBOutlet weak var tfTweet: UITextField!
    
    @IBOutlet weak var lcVTextBottom: NSLayoutConstraint!
    
    var listTweets = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpForKeyBoard()
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
        return false
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
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        //
        cell.textLabel?.text = listTweets[indexPath.row]
        //
        return cell
    }
}
