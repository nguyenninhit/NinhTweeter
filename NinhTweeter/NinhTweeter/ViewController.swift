//
//  ViewController.swift
//  NinhTweeter
//
//  Created by Ninh Nguyen on 6/12/18.
//  Copyright © 2018 Ninh Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tbTweet: UITableView!
    @IBOutlet weak var tfTweet: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    var listTweets = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    
    @IBAction func btnSendAction(_ sender: Any) {
        
    }
    
    // MARK: - Keyboard
    
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
