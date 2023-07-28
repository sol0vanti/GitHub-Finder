//
//  ViewController.swift
//  Github-Network-Call
//
//  Created by Alex on 15.07.2023.
//

import UIKit

struct User: Codable {
    let avatarUrl: String
    let login: String
    let name: String
    let location: String
    let bio: String
}

class ViewController: UIViewController {
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var userTextField: UITextField!
    
    private var user: User?
    
    var avatarUrl: String?
    var nickname: String?
    var name: String?
    var bio: String?
    var location: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getUser() async throws -> User {
        var userNickname: String = userTextField.text!
        // replace url with https://api.github.com/users/\(user)
        let endpoint = "https://api.github.com/users/" + userNickname
        
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
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        Task { @MainActor in
            do {
                user = try await getUser()
                avatarUrl = user?.avatarUrl
                nickname = user?.login
                name = user?.name
                bio = user?.bio
                location = user?.location
                
                transitionToDetailScreen()
            } catch GHError.invalidURL {
                errorLabel.text = "invalid url"
                showError()
            } catch GHError.invalidResponse {
                errorLabel.text = "invalid response"
                showError()
            } catch GHError.invalidData {
                errorLabel.text = "invalid data"
                showError()
            }
            
        }
    }
    
    func transitionToDetailScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.avatarStringUrl = avatarUrl
        vc?.nickname = nickname
        vc?.name = name
        vc?.bio = bio
        vc?.location = location
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func showError() {
        errorLabel.isHidden = false
        userTextField.layer.borderWidth = 1.0
        userTextField.layer.borderColor = UIColor.systemPink.cgColor
    }
}

enum GHError: Error {
    case invalidURL, invalidResponse, invalidData
}

