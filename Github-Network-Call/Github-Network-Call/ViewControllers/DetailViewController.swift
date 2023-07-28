//
//  DetailViewController.swift
//  Github-Network-Call
//
//  Created by Alex on 28.07.2023.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var returnButton: UIButton!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    
    var avatarStringUrl: String?
    var nickname: String?
    var name: String?
    var bio: String?
    var location: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameLabel.text = nickname
        nameLabel.text = name
        bioLabel.text = bio
        locationLabel.text = location
        
        let avatarUrl = URL(string: avatarStringUrl!)
        
        getData(from: avatarUrl!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.logoImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @IBAction func returnButtonClicked(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
