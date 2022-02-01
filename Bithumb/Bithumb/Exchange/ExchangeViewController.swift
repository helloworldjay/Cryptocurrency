//
//  ExchangeViewController.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/19.
//

import UIKit

final class ExchangeViewController: UIViewController {
  
  // MARK: Properties
  
  let coinListView: CoinListView
  let segmentedCategoryView: SegmentedCategoryView
  let exchangeSearchBar: ExchangeSearchBar
  var exchangeViewModel: ExchangeViewModelLogic
  let exchangeUseCase: ExchangeUseCaseLogic
  let networkManager: NetworkManagerLogic


  // MARK: Initializers
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    let categoryItems = ["원화", "BTC", "관심"]
    self.segmentedCategoryView = SegmentedCategoryView(items: categoryItems, fontSize: 14)
    self.networkManager = NetworkManager()
    self.exchangeUseCase = ExchangeUseCase(network: self.networkManager)
    self.exchangeViewModel = ExchangeViewModel(useCase: self.exchangeUseCase)
    self.exchangeSearchBar = ExchangeSearchBar()
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
    self.coinListView.bind(viewModel: self.exchangeViewModel.coinListViewModel)
    self.segmentedCategoryView.bind(viewModel: self.exchangeViewModel.segmentedCategoryViewModel)
  }
  
  private func layout() {
    self.setUpNavigationBar()
    
    [self.segmentedCategoryView, self.coinListView].forEach { self.view.addSubview($0) }
    
    self.segmentedCategoryView.snp.makeConstraints {
      $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
    
    self.coinListView.snp.makeConstraints {
      $0.top.equalTo(self.segmentedCategoryView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  private func setUpNavigationBar() {
    self.navigationItem.titleView = exchangeSearchBar
  }
}
