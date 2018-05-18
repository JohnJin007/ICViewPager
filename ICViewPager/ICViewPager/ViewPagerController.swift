//
//  ViewPagerController.swift
//  ICViewPager
//
//  Created by Ilter Cengiz on 18/5/18.
//  Copyright © 2018 Ilter Cengiz. All rights reserved.
//

import UIKit

final public class ViewPagerController: UIViewController {
    
    @IBOutlet private weak var contentCollectionView: UICollectionView!
    @IBOutlet private weak var tabContainerStackView: UIStackView!
    @IBOutlet private weak var tabCollectionView: UICollectionView!
    @IBOutlet private weak var tabCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tabCollectionViewLayout: TabCollectionViewLayout!
    @IBOutlet private weak var contentCollectionViewLayout: ContentCollectionViewLayout!
    
    private var contentCollectionViewDataSource: ContentCollectionViewDataSource!
    private var contentCollectionViewDelegate: ContentCollectionViewDelegate!
    
    public weak var dataSource: ViewPagerControllerDataSource?
    public var configuration: ViewPagerConfiguration
    
    // MARK: Init
    
    public init(configuration: ViewPagerConfiguration = ViewPagerConfiguration()) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        configuration = ViewPagerConfiguration()
        super.init(coder: aDecoder)
    }
    
    // MARK: View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

private extension ViewPagerController {
    
    func setUpUI() {
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = UIEdgeInsetsMake(configuration.tabHeight, 0.0, 0.0, 0.0)
            contentCollectionView.contentInsetAdjustmentBehavior = .never
        } else {
            if let constraint = view.constraints.first(where: { $0.identifier == "tabAlignmentConstraint" }) {
                view.removeConstraint(constraint)
            }
            topLayoutGuide.bottomAnchor.constraint(equalTo: tabContainerStackView.topAnchor).isActive = true
            automaticallyAdjustsScrollViewInsets = false
        }
        setUpContentCollectionView(contentCollectionView)
        applyConfiguration(configuration)
    }
    
    func setUpContentCollectionView(_ collectionView: UICollectionView) {
        contentCollectionViewDataSource = ContentCollectionViewDataSource(viewPagerController: self,
                                                                          collectionView: collectionView)
        contentCollectionViewDataSource.dataSource = dataSource
        contentCollectionViewDelegate = ContentCollectionViewDelegate(viewPagerController: self)
        collectionView.dataSource = contentCollectionViewDataSource
        collectionView.delegate = contentCollectionViewDelegate
    }
    
    func applyConfiguration(_ configuration: ViewPagerConfiguration) {
        tabCollectionViewHeightConstraint.constant = configuration.tabHeight
    }
}
