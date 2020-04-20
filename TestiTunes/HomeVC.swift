//
//  HomeVC.swift
//  TestiTunes
//
//  Created by Vani on 4/19/20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var tblView = UITableView()
    var tblData = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        addControls()
        getTopAlbums()
        self.title = "Top 100 Albums"
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
        tblView.frame = self.view.bounds;
        tblView.dataSource = self
        tblView.delegate = self
        tblView.rowHeight = 65
        self.view.addSubview(tblView)
        tblView.backgroundColor = UIColor.cyan
    }
    
    //MARK:- Tableview data methods
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
          return tblData.count
      }
      
      
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "MyTestCell")
          cell.selectionStyle = UITableViewCell.SelectionStyle.none
          let obj = tblData[indexPath.row]
          
          var iconImageView : UIImageView?
          var nameLbl : UILabel?
          var artist : UILabel?
          var artistLbl : UILabel?
          
          
          if let img = cell.contentView.viewWithTag(1001) as? UIImageView {
              iconImageView = img
          }
          else {
              iconImageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: 60 , height: 60))
              cell.contentView.addSubview(iconImageView!)
              iconImageView?.contentMode = .scaleAspectFit
              iconImageView?.tag = 1001
          }
          
          if let lbl = cell.contentView.viewWithTag(1002) as? UILabel {
              nameLbl = lbl
          }
          else {
              let x = (iconImageView?.frame.maxX)! + 5
              nameLbl = UILabel.init(frame: CGRect(x: x, y: 5, width: (tableView.frame.width - x - 10)  , height: 20))
              cell.contentView.addSubview(nameLbl!)
              nameLbl?.tag = 1002
              nameLbl?.font = UIFont.boldSystemFont(ofSize: 11)
          }
          
          if let lbl = cell.contentView.viewWithTag(1003) as? UILabel {
              artist = lbl
          }
          else {
              let x = (iconImageView?.frame.maxX)! + 5
              let y = (nameLbl?.frame.maxY)! + 5
              artist = UILabel.init(frame: CGRect(x: x, y: y, width: 35  , height: 15))
              cell.contentView.addSubview(artist!)
              artist?.text = "Artist : "
              artist?.font = UIFont.systemFont(ofSize: 9)
              artist?.tag = 1003
          }
          
          if let lbl = cell.contentView.viewWithTag(1004) as? UILabel {
              artistLbl = lbl
          }
          else {
              let x = (artist?.frame.maxX)! + 5
              let y = (nameLbl?.frame.maxY)! + 5
              artistLbl = UILabel.init(frame: CGRect(x: x, y: y, width: 130  , height: 15))
              cell.contentView.addSubview(artistLbl!)
              artistLbl?.font = UIFont.boldSystemFont(ofSize: 9)
              artistLbl?.tag = 1004
          }
          nameLbl?.text = obj ["name"] as? String ?? ""
          artistLbl?.text = obj ["artistName"] as? String ?? ""
        let albumID = obj["id"] as? String ?? "abc"
        if let imgURL = obj["artworkUrl100"] as? String, let url = URL.init(string: imgURL) {
            iconImageView?.downloadImage(from: url, UIImage.init(named: "audio"), albumID)
          }
          
          return cell
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //AlbumDetailsVC
        let vc = AlbumDetailsVC()
        vc.selectedAlbum = self.tblData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
     
    //MARK:- API CALL Related
    func getTopAlbums()
    {
        let apiObj = APICall.instance
        apiObj.performAPIcallWith(urlStr: "", methodName: .get, json: nil)
        apiObj.successAPI = {(result) -> () in
            if let res = result
            {
                DispatchQueue.main.async {
                    self.readResponse(res)
                }
                
            }
        }
        apiObj.failureAPI = {(result) -> () in
            DispatchQueue.main.async {
                
            }
        }
    }
    
    func readResponse(_ result: APIResult){
        if let data = result.data
        {
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let dict = json, dict is [String : Any], let feedObj = dict as?  [String : Any]
            {
                if let resObj = feedObj["feed"] , let obj = resObj as? [String : Any] , let array = obj ["results"], let resultsArray = array as? [[String : Any]]
                {
                    //self.prepareTableData(resultsArray)
                    print("resulst :",resultsArray.first)
                    self.tblData = resultsArray
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK:- Image Downloader Related
   
    
}
extension UIImageView {
    func downloadImage(from url: URL, _ placeHolder: UIImage?, _ albumId: String) {
        //Assigning place holder image
        if let placeHolderIcon = placeHolder {
            self.image = placeHolderIcon
        }
        else {
            self.image = UIImage.init(named: "audio")
        }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
           URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }
}

