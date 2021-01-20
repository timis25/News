//
//  MyViewCell.swift
//  News
//
//  Created by Timur Israilov on 16/01/21.
//

import UIKit

class MyViewCell: UICollectionViewCell {

    @IBOutlet weak var MyTitle: UILabel!
    var news: NewsModels?{
        didSet{
            MyTitle.text = news?.name
        }
        
    }
}
