//
//  SearchViewController.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 30/10/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    @IBOutlet weak var searchResutlView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var albums = [Post]()
    var albumsIfNilOrEmpty = [Post]()
    var albumName: String!
    var idAlbum: String!
    var strAlbumName: String!
    var artistName: String!
    var downloadUrl: String!
    var artUrl: String?
    var releaseYear: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchResutlView.delegate = self
        searchResutlView.dataSource = self
        searchResutlView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: "albumCollCell")
        searchResutlView.contentInset.left = 10
        searchResutlView.contentInset.right = 10
        // Do any additional setup after loading the view.
    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }*/
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yeahyeah")
        return cell!
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! AlbumDetailViewController
        detailView.albumId = idAlbum
        detailView.strAlbum = strAlbumName
        detailView.strArtist = artistName
        detailView.downloadUrl = downloadUrl
        detailView.yearRelease = releaseYear
        detailView.getAlbumDetails(id: idAlbum) { success in
            detailView.albumDetails = success!
        }
        print(idAlbum, albumName, artistName)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        idAlbum = albums[indexPath.row].idAlbum
        strAlbumName = albums[indexPath.row].strAlbum
        artistName = albums[indexPath.row].strArtist
        downloadUrl = albums[indexPath.row].strAlbumThumb
        releaseYear = albums[indexPath.row].intYearReleased
        performSegue(withIdentifier: "showDetailView", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResutlView.dequeueReusableCell(withReuseIdentifier: "albumCollCell", for: indexPath) as! SearchResultCollCell
        cell.albumName.text = albums[indexPath.row].strAlbum
        cell.artistName.text = albums[indexPath.row].strArtist
        artUrl = albums[indexPath.row].strAlbumThumb
        cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        if (artUrl != nil && !(artUrl ?? "").isEmpty) {
            cell.albumThumb.downloadImage(from: URL(string:((artUrl)!))!)
        } else {
            cell.albumThumb.downloadImage(from: URL(string:("https://stationsite.co.uk/app/artist_catalog/default.jpg"))!)
        }
        
        print("hallopådu\(albums)")
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("okeyman")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        albumName = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        getPosts() { response in
            if(response != nil) {
                self.albums = response!
            }
            self.searchResutlView.reloadData()
        }
    }
    
    func getPosts(completion: @escaping ([Post]?) -> Void){
        
        Alamofire.request("https://theaudiodb.com/api/v1/json/195228/searchalbum.php?a=\(albumName!)").responseJSON{ response in
            do {
                print(response)
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode([String:[Post]].self, from:
                    response.data!) //Decode JSON Response Data
                //self.posts = model
                
                let albums = model["album"]
                completion(albums)
            } catch let parsingError {
                print("Error", parsingError, response.data)
                completion(nil)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
