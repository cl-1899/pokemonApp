//
//  ModuleViewController.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import UIKit

class ModuleViewController: UIViewController, ModulePresenterOutputProtocol {
    var presenter: ModulePresenterInputProtocol!
    
    private var tableView: UITableView!
    private var pokemonList: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PokemonCell")
        view.addSubview(tableView)
    }
    
    func displayPokemonList(_ pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showError() {
        AlertManager.showAlert(alertType: .loadDataError, on: self)
    }
}

extension ModuleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        let pokemon = pokemonList[indexPath.row]
        cell.textLabel?.text = pokemon.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = pokemonList[indexPath.row]
        let id = selectedPokemon.id
        presenter.didSelectPokemon(withID: id, from: self)
    }
}
