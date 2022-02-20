//
//  ExchangeViewController.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/19.
//

import UIKit

import RxSwift

final class ExchangeViewController: UIViewController {
  
  // MARK: Properties
  
  let coinListView: CoinListView
  let favoriteGridView: FavoriteGridView
  let exchangeSegmentedCategoryView: ExchangeSegmentedCategoryView
  let exchangeSearchBar: ExchangeSearchBar
  var exchangeViewModel: ExchangeViewModelLogic
  let exchangeUseCase: ExchangeUseCaseLogic
  let networkManager: NetworkManagerLogic

  private let disposeBag = DisposeBag()

  // MARK: Initializers
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    let categoryItems = ["원화", "BTC", "관심"]
    self.exchangeSegmentedCategoryView = ExchangeSegmentedCategoryView(items: categoryItems, fontSize: 14)
    self.networkManager = NetworkManager()
    self.exchangeUseCase = ExchangeUseCase(network: self.networkManager)
    self.exchangeViewModel = ExchangeViewModel(useCase: self.exchangeUseCase)
    self.exchangeSearchBar = ExchangeSearchBar()
    self.coinListView = CoinListView()
    self.favoriteGridView = FavoriteGridView()
    
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    BehaviorSubject<Void>(value: ())
      .bind(to: self.exchangeViewModel.viewWillAppear)
      .disposed(by: self.disposeBag)
  }
  
  private func configure() {
    self.bind()
  }
  
  private func bind() {
    self.exchangeSearchBar.bind(viewModel: self.exchangeViewModel.exchangeSearchBarViewModel)
    self.coinListView.bind(viewModel: self.exchangeViewModel.coinListViewModel)
    self.favoriteGridView.bind(viewModel: self.exchangeViewModel.favoriteGridViewModel)
    self.coinListView.coinListSortView.bind(coinListSortViewModel: self.exchangeViewModel.coinListSortViewModel)
    self.exchangeSegmentedCategoryView.bind(viewModel: self.exchangeViewModel.exchangeSegmentedCategoryViewModel)

    self.exchangeViewModel.exchangeSegmentedCategoryViewModel.category
      .bind(onNext: self.changeContentView)
      .disposed(by: self.disposeBag)
  }

  private func changeContentView(by category: ExchangeSegmentedCategoryView.SegmentedViewIndex) {
    switch category {
    case .krw:
      self.exchangeSearchBar.isHidden = false
      self.exchangeSegmentedCategoryView.isHidden = false
      self.coinListView.isHidden = false
      self.favoriteGridView.isHidden = true
    case .btc:
      self.exchangeSearchBar.isHidden = false
      self.exchangeSegmentedCategoryView.isHidden = false
      self.coinListView.isHidden = false
      self.favoriteGridView.isHidden = true
    case .favorite:
      self.exchangeSearchBar.isHidden = false
      self.exchangeSegmentedCategoryView.isHidden = false
      self.coinListView.isHidden = true
      self.favoriteGridView.isHidden = false
    }
  }
  
  private func layout() {
    self.setUpNavigationBar()
    
    [self.exchangeSegmentedCategoryView, self.coinListView, self.favoriteGridView].forEach { self.view.addSubview($0) }
    
    self.exchangeSegmentedCategoryView.snp.makeConstraints {
      $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
    
    self.coinListView.snp.makeConstraints {
      $0.top.equalTo(self.exchangeSegmentedCategoryView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.favoriteGridView.snp.makeConstraints {
      $0.top.equalTo(self.exchangeSegmentedCategoryView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  private func setUpNavigationBar() {
    self.navigationItem.titleView = exchangeSearchBar
  }
}
