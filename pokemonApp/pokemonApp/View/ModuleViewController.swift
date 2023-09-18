//
//  ModuleViewController.swift
//  pokemonApp
//
//  Created by Andrei Martynenka on 17.09.23.
//

import UIKit

class ModuleViewController: UIViewController, ModulePresenterOutputProtocol {
    var presenter: ModulePresenterInputProtocol!
    
    private var isLoading = false
    private var tableView: UITableView!
    private var pokemonList: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableView.self, forCellReuseIdentifier: "PokemonCell")
        view.addSubview(tableView)
    }
    
    func displayPokemonList(_ pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
        tableView.reloadData()
        isLoading = false
    }
    
    func showError() {
        <#code#>
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
        <#code#>
    }
}
