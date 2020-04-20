//
//  AlbumDetailsVC.swift
//  TestiTunes
//
//  Created by Vani on 4/20/20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class AlbumDetailsVC: UIViewController {
    
    var selectedAlbum = [String : Any]()
    
    var albumImageView = UIImageView()
    var nameLbl = UILabel()
    var artistLbl = UILabel()
    var artistValueLbl = UILabel()
    var genreInfoLbl = UILabel()
    var releaseDateLbl = UILabel()
    var copyRightLbl = UILabel()
    
    var linkButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addControls()
        loadAlbumData()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func addControls() {
        self.view.backgroundColor = UIColor.white
        let x = CGFloat(5.0)
        var y = CGFloat(5.0)
        let space = CGFloat(5.0)
        let width = (self.view.frame.size.width)
        let itemWidth = width - (2 * x)
        let titleWidth  = CGFloat(50.0)
        
        // ICON
        albumImageView.frame = CGRect(x: x, y : y , width: itemWidth, height: itemWidth)
        self.view.addSubview(albumImageView)
        
        y = albumImageView.frame.maxY + space
        //Name
        nameLbl = UILabel.init(frame: CGRect(x: x, y: y, width: itemWidth  , height: 25))
        self.view.addSubview(nameLbl)
        nameLbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        y = nameLbl.frame.maxY + space
        
        //Artist
        artistLbl = UILabel.init(frame: CGRect(x: x, y: y, width: titleWidth  , height: 15))
        self.view.addSubview(artistLbl)
        artistLbl.text = "Artist : "
        artistLbl.font = UIFont.systemFont(ofSize: 9)
        
        artistValueLbl = UILabel.init(frame: CGRect(x: 60, y: y, width: (itemWidth - 70)  , height: 15))
        self.view.addSubview(artistValueLbl)
        artistValueLbl.font = UIFont.boldSystemFont(ofSize: 10)
        
        y = artistLbl.frame.maxY + space
        
        //Genres
        let geners = UILabel.init(frame: CGRect(x: x, y: y, width: titleWidth  , height: 15))
        self.view.addSubview(geners)
        geners.text = "Geners : "
        geners.font = UIFont.systemFont(ofSize: 9)
        
        genreInfoLbl = UILabel.init(frame: CGRect(x: 60, y: y, width: (itemWidth - 70)  , height: 15))
        self.view.addSubview(genreInfoLbl)
        genreInfoLbl.font = UIFont.boldSystemFont(ofSize: 9)
        
        y = genreInfoLbl.frame.maxY + space
        
        //Release Date
        let release = UILabel.init(frame: CGRect(x: x, y: y, width: titleWidth  , height: 15))
        self.view.addSubview(release)
        release.text = "Release Date : "
        release.font = UIFont.systemFont(ofSize: 9)
        
        releaseDateLbl = UILabel.init(frame: CGRect(x: 60, y: y, width: (itemWidth - 70)  , height: 15))
        self.view.addSubview(releaseDateLbl)
        releaseDateLbl.font = UIFont.boldSystemFont(ofSize: 9)
        
        y = releaseDateLbl.frame.maxY + space
        
        //Release Date
        let copyright = UILabel.init(frame: CGRect(x: x, y: y, width: titleWidth  , height: 15))
        self.view.addSubview(copyright)
        copyright.text = "Copyright : "
        copyright.font = UIFont.systemFont(ofSize: 9)
        
        copyRightLbl = UILabel.init(frame: CGRect(x: 60, y: y, width: (itemWidth - 70)  , height: 25))
        self.view.addSubview(copyRightLbl)
        copyRightLbl.font = UIFont.boldSystemFont(ofSize: 9)
        copyRightLbl.numberOfLines = 0
        copyRightLbl.lineBreakMode = .byWordWrapping
        
        //Link Button
        let height = self.view.frame.height
        let btnHeight = CGFloat(40.0)
        let btnYpos = (height - CGFloat(20.0)) - btnHeight
        let btnWidth = CGFloat(100.0)
        let btnX = (width - btnWidth) / 2.0
        linkButton.frame = CGRect(x: btnX, y: btnYpos, width:  btnWidth, height: btnHeight)
        linkButton.setTitle("Goto iTunes", for: .normal)
        linkButton.backgroundColor = UIColor.init(red: CGFloat(70.0/255.0), green: CGFloat(160.0/255.0), blue: CGFloat(240.0/255.0), alpha: 1.0)
        linkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        linkButton.layer.cornerRadius = 5.0
        linkButton.addTarget(self, action: #selector(linkBtnTapped(_:)), for: .touchUpInside)
        self.view.addSubview(linkButton)
    }
    
    func loadAlbumData(){
        let albumID = selectedAlbum["id"] as? String ?? "abc"
        if let imgURL = selectedAlbum["artworkUrl100"] as? String, let url = URL.init(string: imgURL) {
            albumImageView.downloadImage(from: url, UIImage.init(named: "audio"), albumID)
        }
        
        nameLbl.text = selectedAlbum ["name"] as? String ?? ""
        artistValueLbl.text = selectedAlbum ["artistName"] as? String ?? ""
        
        self.title = selectedAlbum ["name"] as? String ?? ""
        // Loading Geners
        if let geners = selectedAlbum["genres"] as? [[String : Any]]
        {
            if let genNames = geners.map({$0["name"]}) as? [String] {
                let info = genNames.joined(separator: ", ")
                self.genreInfoLbl.text = info
            }
        }
        
        //Release Date
        releaseDateLbl.text = selectedAlbum ["releaseDate"] as? String ?? ""
        //CopyRight
        copyRightLbl.text = selectedAlbum ["copyright"] as? String ?? ""
    }
    
    
    //MARK:- UIButton Actions
    @objc func linkBtnTapped(_ btn: UIButton){
        if let url = selectedAlbum["artistUrl"] as? String{
            UIApplication.shared.open(URL.init(string: url)!, options: [:]) { (done) in
                
            }
        }
    }
    
    
}
