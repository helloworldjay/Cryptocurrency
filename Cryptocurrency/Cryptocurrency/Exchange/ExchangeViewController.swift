//
//  ExchangeViewController.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/19.
//

import UIKit

final class ExchangeViewController: UIViewController {

  // MARK: Properties

  var exchangeViewModel: ExchangeViewModelLogic
  private let networkManager: NetworkManagerLogic
  private let exchangeUseCase: ExchangeUseCaseLogic
  private let exchangeSearchBar: ExchangeSearchBar
  private let exchangeSegmentedCategoryView: ExchangeSegmentedCategoryView
  private let coinListView: CoinListView


  // MARK: Initializers

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.networkManager = NetworkManager()
    self.exchangeUseCase = ExchangeUseCase(network: self.networkManager)
    self.exchangeViewModel = ExchangeViewModel(useCase: self.exchangeUseCase)
    self.exchangeSearchBar = ExchangeSearchBar()
    self.exchangeSegmentedCategoryView = ExchangeSegmentedCategoryView()
    self.coinListView = CoinListView()

    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
    self.layout()
  }

  private func configure() {
    self.bind()
  }

  private func bind() {
    self.exchangeSearchBar.bind(viewModel: self.exchangeViewModel.exchangeSearchBarViewModel)
    self.exchangeSegmentedCategoryView.bind(viewModel: self.exchangeViewModel.exchangeSegmentedCategoryViewModel)
    self.coinListView.coinListSortView.bind(coinListSortViewModel: self.exchangeViewModel.coinListSortViewModel)
    self.coinListView.bind(viewModel: self.exchangeViewModel.coinListViewModel)
  }

  private func layout() {
    self.setUpNavigationBar()

    [self.exchangeSegmentedCategoryView, self.coinListView].forEach { self.view.addSubview($0) }

    self.exchangeSegmentedCategoryView.snp.makeConstraints {
      $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }

    self.coinListView.snp.makeConstraints {
      $0.top.equalTo(self.exchangeSegmentedCategoryView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }

  private func setUpNavigationBar() {
    self.navigationItem.titleView = exchangeSearchBar
  }
}
