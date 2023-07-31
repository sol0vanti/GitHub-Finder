//
//  FollowersViewController.swift
//  Github-Network-Call
//
//  Created by Alex on 31.07.2023.
//

import UIKit

class FollowersViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var followers: [Followers]!
    var avatarStringUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let follower = followers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowerTableViewCell
        cell.nicknameLabel.text = follower.login
        
        let avatarURL = URL(string: follower.avatarUrl)
        
        DetailViewController.getData(from: avatarURL!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { 
                cell.iconImageView.image = UIImage(data: data)
            }
        }
        return cell
    }
}
