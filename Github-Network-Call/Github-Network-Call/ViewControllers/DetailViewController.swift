//
//  DetailViewController.swift
//  Github-Network-Call
//
//  Created by Alex on 28.07.2023.
//

import UIKit

struct Followers: Codable {
    let login: String
    let avatar_url: String
    let url: String
}

class DetailViewController: UIViewController {
    @IBOutlet var friendsButton: UIButton!
    @IBOutlet var returnButton: UIButton!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    var avatarStringUrl: String?
    var nickname: String?
    var name: String?
    var bio: String?
    var location: String?
    
    private var followers: Followers?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyles()
        
        title = nickname
        navigationController?.navigationBar.tintColor = .systemGreen
        
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
    
    func setUpStyles(){
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.borderColor = UIColor.white.cgColor
        logoImageView.layer.cornerRadius = logoImageView.frame.height/2
        logoImageView.clipsToBounds = true
        
        friendsButton.layer.cornerRadius = friendsButton.frame.height/2
    }
    
    func getFollowers() async throws -> Followers {
        let endpoint = "https://api.github.com/users/" + nickname! + "/followers"
        
        guard let url = URL(string: "\(String(describing: endpoint))") else {
            throw GHError.invalidURL
        }
                
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Followers.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func showErrorAC(title: String, subtitile: String){
        let ac = UIAlertController(title: title, message: subtitile, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive))
    }
    
    @IBAction func followersButtonClicked(_ sender: UIButton) {
        Task { @MainActor in
            do {
                followers = try await getFollowers()
            } catch GHError.invalidURL {
                showErrorAC(title: "Invalid URL", subtitile: "We cannot find the correct url. Please try again later.")
            } catch GHError.invalidResponse {
                showErrorAC(title: "Invalid Response", subtitile: "We cannot receive response from current URL request. Please try again later.")
            } catch GHError.invalidData {
                showErrorAC(title: "Invalid Data", subtitile: "We cannot get correct data from current URL request. Please try again later.")
            }
        }
    }
}
