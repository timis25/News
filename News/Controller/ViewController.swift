//
//  ViewController.swift
//  News
//
//  Created by Timur Israilov on 16/01/21.
//
import SwiftSoup
import UIKit

class ViewController: UIViewController  {

    // MARK: Variable
    @IBOutlet weak var MyCollectionView: UICollectionView!
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var newsArray:[NewsModels] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       parse(url: "https://www.gazeta.uz/ru/", getTextByClass: "title")
        MyCollectionView.refreshControl = myRefreshControl
        MyCollectionView.delegate = self
        MyCollectionView.dataSource = self
    }

//    MARK: Function
    @objc func refresh(sender: UIRefreshControl){
        MyCollectionView.reloadData()
        sender.endRefreshing()
    }
    
    
    func parse(url: String, getTextByClass: String){
        let myUrlString = url
        guard let myURL = URL(string: myUrlString) else {return}
        do{
            let myHTMLstring = try String(contentsOf: myURL, encoding: .utf8)
            let htmlContent = myHTMLstring
            do{
                let doc = try SwiftSoup.parse(htmlContent)
                do{
                    let newsBlock = try doc.getElementsByClass("nblock ")
                    let getNews = try newsBlock.select("h3")
                try getNews.forEach { (getNews) in
                    var newModel = NewsModels()
                    newModel.name = try getNews.text()
                    newsArray.append(newModel)
                    
                    }
                }
            }
        }catch  let error{
           print(error)
        }
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as? MyViewCell{
            newsCell.layer.cornerRadius = 20
            newsCell.news = newsArray[indexPath.row]
            return newsCell
        }
        return UICollectionViewCell()
    }
}

