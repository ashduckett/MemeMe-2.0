//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Ash Duckett on 06/03/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: MemeSelectorViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    var memes: [Meme]!
    @IBOutlet var grid: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        grid.delegate = self
        grid.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Reload data when the view appears in case any have been added
        grid.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        cell.cellImage.image = appDelegate.memes[indexPath.row].memedImage
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = appDelegate.memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}
