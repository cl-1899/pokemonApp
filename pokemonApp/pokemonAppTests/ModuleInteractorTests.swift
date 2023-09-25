//
//  ModuleInteractorTests.swift
//  pokemonAppTests
//
//  Created by Andrei Martynenka on 25.09.23.
//

import XCTest
@testable import pokemonApp

final class ModuleInteractorTests: XCTestCase {
    var interactor: ModuleInteractor!
    var mockPresenter: MockModulePresenter!
    
    override func setUpWithError() throws {
        mockPresenter = MockModulePresenter()
        interactor = ModuleInteractor()
        interactor.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockPresenter = nil
    }

    func testFetchPokemonList() {
        interactor.fetchPokemonList()
        XCTAssertTrue(mockPresenter.didFetchPokemonListCalled)
    }
    
    func testOnError() {
        mockPresenter.onError(.loadDataError)
        XCTAssert(mockPresenter.showErrorCalled)
    }

}

class MockModulePresenter: ModulePresenterInputProtocol, ModuleInteractorOutputProtocol {
    weak var view: ModulePresenterOutputProtocol?
    var interactor: ModuleInteractorInputProtocol!
    var router: ModuleRouterInputProtocol!
    var isLoadingNextPage: Bool = false
    var didFetchPokemonListCalled = false
    var showErrorCalled = false

    func viewDidLoad() {}

    func loadNextPage() {}

    func didSelectPokemon(withID id: Int16, from view: ModulePresenterOutputProtocol?) {}

    func didFetchPokemonList(_ pokemonList: [Pokemon]) {
        didFetchPokemonListCalled = true
    }

    func onError(_ alertType: AlertType) {
        showErrorCalled = true
    }
}
