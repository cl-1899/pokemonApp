//
//  PokemonModuleInteractorTests.swift
//  pokemonAppTests
//
//  Created by Andrei Martynenka on 25.09.23.
//

import XCTest
@testable import pokemonApp

final class PokemonModuleInteractorTests: XCTestCase {
    var interactor: PokemonModuleInteractor!
    var mockPresenter: MockPokemonModulePresenter!

    override func setUpWithError() throws {
        mockPresenter = MockPokemonModulePresenter()
        interactor = PokemonModuleInteractor()
        interactor.presenter = mockPresenter
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockPresenter = nil
    }

    func testFetchPokemonDetails(id: Int16) {
        interactor.fetchPokemonDetails(with: id)
        XCTAssertTrue(mockPresenter.didFetchPokemonDetailsCalled)
    }
    
    func testOnError() {
        mockPresenter.onError(.loadDataError)
        XCTAssertTrue(mockPresenter.showErrorCalled)
    }
}

class MockPokemonModulePresenter: PokemonModulePresenterInputProtocol, PokemonModuleInteractorOutputProtocol {
    weak var view: PokemonModulePresenterOutputProtocol?
    var interactor: PokemonModuleInteractorInputProtocol!
    var didFetchPokemonDetailsCalled = false
    var showErrorCalled = false

    func viewDidLoad() {}

    func didFetchPokemonDetails(_ pokemonDetails: PokemonDetails) {
        didFetchPokemonDetailsCalled = true
    }

    func onError(_ alertType: AlertType) {
        showErrorCalled = true
    }
}
