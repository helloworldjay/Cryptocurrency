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
  let exchangeSearchBar: ExchangeSearchBar
  let exchangeViewModel: ExchangeViewModelLogic
  let exchangeUseCase: ExchangeUseCaseLogic
  let networkManager: NetworkManagerLogic
  
  
  // MARK: Initializers
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
  }
  
  //TBD: UI 재조정 필요
  private func layout() {
    [self.exchangeSearchBar, self.coinListView].forEach { self.view.addSubview($0) }
    
    self.exchangeSearchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    self.coinListView.snp.makeConstraints {
      $0.top.equalTo(exchangeSearchBar.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(100)
    }
  }
}
