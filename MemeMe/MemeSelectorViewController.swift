//
//  File.swift
//  MemeMe
//
//  Created by Ash Duckett on 05/03/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import UIKit

class MemeSelectorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewMeme))
        self.navigationItem.title = "Sent Memes"
    }
    
    func addNewMeme() {
        var controller: MemeEditorViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
        self.present(controller, animated: true, completion: nil)
    }
}
