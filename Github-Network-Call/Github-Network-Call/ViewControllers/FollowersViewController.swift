//
//  FollowersViewController.swift
//  Github-Network-Call
//
//  Created by Alex on 31.07.2023.
//

import UIKit

class FollowersViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    struct  Followers {
        let nickname: String
        let imageURL: String
    }
    
    let data: [Followers] = [
    Followers(nickname: "skxnz", imageURL: "url"),
    Followers(nickname: "Beaxhem", imageURL: "url")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let follower = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowerTableViewCell
        cell.nicknameLabel.text = follower.nickname
        return cell
    }
}
