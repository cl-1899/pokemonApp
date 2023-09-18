//
//  PokemonModuleViewController.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 18.09.23.
//

import UIKit

class PokemonModuleViewController: UIViewController, PokemonModulePresenterOutputProtocol {
    var presenter: PokemonModulePresenterInputProtocol!
    
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let typesLabel = UILabel()
    private let weightLabel = UILabel()
    private let heightLabel = UILabel()
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
        view.addSubview(nameLabel)
        view.addSubview(typesLabel)
        view.addSubview(weightLabel)
        view.addSubview(heightLabel)
            
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
            
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
        typesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        typesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
        weightLabel.topAnchor.constraint(equalTo: typesLabel.bottomAnchor, constant: 10).isActive = true
        weightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        heightLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 10).isActive = true
        heightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func displayPokemonDetails(_ pokemonDetails: PokemonDetails) {
        self.nameLabel.text = pokemonDetails.name
        
        DispatchQueue.global().async { [weak self] in
            if let imageURL = URL(string: pokemonDetails.imageURL.absoluteString),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
        
        let typesText = pokemonDetails.types.joined(separator: ", ")
        self.typesLabel.text = "Types: \(typesText)"
        
        let weightText = String(format: "Weight: %.1f kg", pokemonDetails.weight)
        weightLabel.text = weightText
        
        let heightText = String(format: "Height: %.1f cm", pokemonDetails.height)
        heightLabel.text = heightText
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Error", message: "An Error occured while loading data.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    //    TODO:
}
