//
//  DetailViewController.swift
//  Flicks
//
//  Created by Portia Sharma on 9/17/17.
//  Copyright © 2017 Portia Sharma. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movieSelected : NSDictionary!

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailScrollView.contentSize = CGSize(width: detailScrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        // Do any additional setup after loading the view.
        if let title = movieSelected?["title"] {
            titleLabel.text = title as? String
        }
        else{
            print("no title")
        }
        if let overview = movieSelected?["overview"] {
            overviewLabel.text = (overview as! String)
            overviewLabel.sizeToFit()
        }
        else{
            print("no overview")
        }
        if let posterPath = movieSelected?["poster_path"] as? String {
            let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
            //cell.posterImageView.image = UIImage(named: "photo")
            posterImageView.setImageWith(posterUrl!)
        }
        else{
            print("no poster")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
