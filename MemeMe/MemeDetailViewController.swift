//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ash Duckett on 08/03/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = meme.memedImage
    }
}
