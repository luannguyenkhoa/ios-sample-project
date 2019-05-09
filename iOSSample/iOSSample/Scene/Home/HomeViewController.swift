//
// HomeViewController.swift
// iOSSample
//
// Copyright © 2019 Agility. All rights reserved.
//

import RxSwift
import RxCocoa
import ServiceKit

// MARK: - Naming extensions
private typealias PrivateHandlers = HomeViewController

final class HomeViewController: BaseViewController {
  
  // MARK: - IBOutlets
  @IBOutlet private(set) weak var tableView: UITableView!
  @IBOutlet private(set) weak var refreshButton: UIButton!
  
  // MARK: - Properties
  var viewModel: HomeViewModel!
  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl
    return refreshControl
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setup()
    binding()
  }
  
  // MARK: - Setup and Binding
  private func setup() {
    
  }
  
  private func binding() {
    /// Make sure viewmode property would not always being nil
    precondition(viewModel.notNil)
    
    let refresh = refreshButton.rx.controlEvent(.valueChanged).asDriver()
    let paginize = PublishSubject<Enum.FetchType>()
    let fetch = Driver.merge(refresh.map({ _ in Enum.FetchType.refresh }).startWith(.refresh), paginize.asDriver(.refresh))
    let input = HomeViewModel.Input(fetch: fetch,
                                    willAppear: rx.methodInvoked(#selector(viewWillAppear(_:))).asDriver([]).void(),
                                    selectIndex: tableView.rx.itemSelected.asDriver().map({ $0.row }))
    let output = viewModel.transform(input: input)
    
    output.posts.do(onNext: { [weak self] _ in
      self?.refreshButton.endEditing(true)
    }).drive(tableView.rx.items(cellIdentifier: "", cellType: UITableViewCell.self)) { _, element, cell in
      d_print(element)
      d_print(cell)
    }.disposed(by: disposeBag)
    
    /// Bypass 3 very first steps: initial value, 2 steps start/end of first loading data
    output.fetching.skip(3).drive(onNext: { [unowned self] (status) in
      // TODO: Show/hide pagination indicator depends on the status
      d_print(status)
      if status {
        self.tableView.spinningFooter()
      } else {
        self.tableView.tableFooterView = nil
      }
    }).disposed(by: disposeBag)
    
    output.error.ignoreNil().drive(onNext: { [unowned self] (content) in self.errorPopup |> content })
      .disposed(by: disposeBag)
    
    tableView.rx.willDisplayCell.asDriver().withLatestFrom(output.posts) { ($0.cell, $0.indexPath, $1) }
      .filter({ $0.2.count == $0.1.row }).map({ _ in Enum.FetchType.paginize })
      .drive(paginize)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Public handlers
  
  // MARK: - IBActions
  
}

extension PrivateHandlers {
  
  // MARK: - Private handlers wrapper
}
