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
    
    func showError(_ alertType: AlertType) {
        AlertManager.showAlert(alertType, on: self)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let nextURL = presenter.interactor.nextURL else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewheight = scrollView.frame.height
        
        if offsetY > contentHeight - scrollViewheight, !presenter.isLoadingNextPage {
            presenter.isLoadingNextPage = true
            presenter.loadNextPage()
        }
    }
}
