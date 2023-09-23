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
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
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
        if let imageData = pokemonDetails.imageData,
           let image = UIImage(data: imageData) {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
                self?.nameLabel.text = "Name: \(pokemonDetails.name)"
                self?.typesLabel.text = "Types: \(pokemonDetails.types)"
                self?.weightLabel.text = "Weight: \(pokemonDetails.weight)"
                self?.heightLabel.text = "Height: \(pokemonDetails.height)"
            }
        } else {
            showError(.loadDataError)
        }
    }
    
    func showError(_ alertType: AlertType) {
        AlertManager.showAlert(alertType, on: self)
    }
}
