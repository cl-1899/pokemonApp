//
//  ModulePresenterTests.swift
//  pokemonAppTests
//
//  Created by Andrei Martynenka on 25.09.23.
//

import XCTest
@testable import pokemonApp

final class ModulePresenterTests: XCTestCase {
    var presenter: ModulePresenter!
    var mockInteractor: MockModuleInteractor!
    var mockRouter: MockModuleRouter!
    var mockView: MockModuleView!

    override func setUpWithError() throws {
        mockInteractor = MockModuleInteractor()
        mockRouter = MockModuleRouter()
        mockView = MockModuleView()
        presenter = ModulePresenter()
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        presenter.view = mockView
    }
    
    override func tearDownWithError() throws {
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        presenter = nil
    }

    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.fetchPokemonListCalled)
    }

    func testLoadNextPage() {
        presenter.loadNextPage()
        XCTAssertTrue(mockInteractor.fetchPokemonListCalled)
    }

    func testDidSelectPokemon() {
        presenter.didSelectPokemon(withID: 1, from: nil)
        XCTAssertTrue(mockRouter.navigateToPokemonDetailsCalled)
    }

    func testDidFetchPokemonList() {
        presenter.didFetchPokemonList([])
        XCTAssertTrue(mockView.displayPokemonListCalled)
    }
    
    func testOnError() {
        presenter.onError(.noNetwork)
        XCTAssertTrue(mockView.showErrorCalled)
    }
    
}

class MockModuleInteractor: ModuleInteractorInputProtocol {
    var presenter: ModuleInteractorOutputProtocol!
    var nextURL: URL?
    var fetchPokemonListCalled = false

    func fetchPokemonList() {
        fetchPokemonListCalled = true
    }
}

class MockModuleView: ModulePresenterOutputProtocol {
    var displayPokemonListCalled = false
    var showErrorCalled = false

    func displayPokemonList(_ pokemonList: [Pokemon]) {
        displayPokemonListCalled = true
    }

    func showError(_ alertType: AlertType) {
        showErrorCalled = true
    }

}

class MockModuleRouter: ModuleRouterInputProtocol {
    var viewController: UIViewController?
    var navigateToPokemonDetailsCalled = false

    func navigateToPokemonDetails(withID id: Int16, from view: ModulePresenterOutputProtocol?) {
        navigateToPokemonDetailsCalled = true
    }
}
