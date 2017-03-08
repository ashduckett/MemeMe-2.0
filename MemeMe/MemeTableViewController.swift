//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ash Duckett on 06/03/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: MemeSelectorViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //memes = appDelegate.memes
    
        table.delegate = self
        table.dataSource = self
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableCell
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cell.cellImage.image = appDelegate.memes[indexPath.row].memedImage
        cell.cellLabel.text = appDelegate.memes[indexPath.row].topText + " " + appDelegate.memes[indexPath.row].bottomText
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = appDelegate.memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
        
        
        
    }
}
