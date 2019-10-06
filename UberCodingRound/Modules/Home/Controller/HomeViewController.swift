//
//  HomeViewController.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 28/09/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    enum ItemPerRow: CGFloat {
        case two = 2
        case three = 3
        case four = 4
    }
    
    let searchBar = UISearchBar()
    var isPageLoading = false
    var itemPerRow = ItemPerRow.two
    var selectedIndexPath: IndexPath!
    let dataSource = PhotosViewDataSource()
    lazy var viewModel = HomeViewModel(dataSource: dataSource)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialView()
        self.setupViewModel()
    }
    
    func setUpInitialView() {
        self.setUpSearchBar()
        self.activitySpinner?.isHidden = true
        self.collectionView?.delegate = self
        self.collectionView?.register(cell: PhotoCollectionViewCell.self)
    }
    
    func setupViewModel() {
        self.collectionView?.dataSource = self.dataSource
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.collectionView?.reloadData()
        }
    }
    
    
    @IBAction func moreOptionButtonAction(_ sender: UIBarButtonItem) {
        self.actionSheet()
    }
    
    func setUpSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.placeholder = kSearchBarPlaceholder
        searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: kFontAvenir, size: 14)
        navigationItem.titleView = searchBar
    }
    
    func searchImage() {
        if (!isPageLoading) {
            self.isPageLoading = true
            self.activitySpinner?.isHidden = false
            self.activitySpinner?.startAnimating()
            
            guard let text = searchBar.text, text != "" else { return }
            self.viewModel.fetchImageFromFlickr(searchText: text) { [weak self] (_ , error) in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async {
                    self.isPageLoading = false
                    self.activitySpinner?.isHidden = true
                    self.activitySpinner?.stopAnimating()
                    if let err = error {
                        self.showAlert(title: "Oops..!! Error", message: err.localizedDescription)
                        return
                    }
                    self.collectionView?.reloadData()
                    if (self.viewModel.photoViewModel.currentPage == 1) {
                        //When Do New Search, CollectionV Start from top.
                        self.collectionView.setContentOffset(CGPoint(x:0,y:-self.collectionView.contentInset.top), animated: true)
                    }
                }
                
            }
        }
    }

    
    func openPhotoDetailViewController(indexPath: IndexPath) {
        let pageVCDetail: ViewControllerDetail = .photoPageContainerVC
        let storyboard = UIStoryboard(name: pageVCDetail.storyBoard, bundle: nil)
        self.selectedIndexPath = indexPath
        if let viewController = storyboard.instantiateViewController(withIdentifier: pageVCDetail.identifier) as?  PhotoPageContainerViewController, self.viewModel.photoViewModel.photos.indices.contains(indexPath.row){
            let navigationController = self.navigationController
            navigationController?.delegate = viewController.transitionController
            viewController.transitionController.fromDelegate = self
            viewController.transitionController.toDelegate = viewController
            viewController.delegate = self
            viewController.currentIndex = self.selectedIndexPath.row
            viewController.viewModel = self.viewModel.photoViewModel
            viewController.title = ""
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func actionSheet(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: kTwoImage, style: .default) { (action) in
            self.itemPerRow = ItemPerRow.two
            self.collectionView.reloadData()
        }
        let secondAction = UIAlertAction(title: kThreeImage, style: .default) { (action) in
            self.itemPerRow = ItemPerRow.three
            self.collectionView.reloadData()
        }
        let thirdAction = UIAlertAction(title: kFourImage, style: .default) { (action) in
            self.itemPerRow = ItemPerRow.four
            self.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: CANCEL, style: .cancel, handler: nil)
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.photoViewModel.newRequest()
        self.searchImage()
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - kMinInteritemSpacingForSection*(itemPerRow.rawValue-1))/itemPerRow.rawValue
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kMinInteritemSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoCount = self.viewModel.photoViewModel.photos.count
        if (photoCount < indexPath.row + TUPLE_FOR_MORE_PHOTO) && !isPageLoading {
            self.viewModel.photoViewModel.incrementPage()
            self.searchImage()
            self.activitySpinner?.startAnimating()
            self.activitySpinner?.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openPhotoDetailViewController(indexPath: indexPath)
    }
}


 extension HomeViewController: PhotoPageContainerViewControllerDelegate {
    
    func containerViewController(_ containerViewController: PhotoPageContainerViewController, indexDidUpdate currentIndex: Int) {
        self.selectedIndexPath = IndexPath(row: currentIndex, section: 0)
        self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
    }
 }


 extension HomeViewController: ZoomAnimatorDelegate {
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        let cell = self.collectionView.cellForItem(at: self.selectedIndexPath) as! PhotoCollectionViewCell
        let cellFrame = self.collectionView.convert(cell.frame, to: self.view)
        if cellFrame.minY < self.collectionView.contentInset.top {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .top, animated: false)
        } else if cellFrame.maxY > self.view.frame.height - self.collectionView.contentInset.bottom {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .bottom, animated: false)
        }
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        let referenceImageView = getImageViewFromCollectionViewCell(for: self.selectedIndexPath)
        return referenceImageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()
        //Get a guarded reference to the cell's frame
        let unconvertedFrame = getFrameFromCollectionViewCell(for: self.selectedIndexPath)
        let cellFrame = self.collectionView.convert(unconvertedFrame, to: self.view)
        if cellFrame.minY < self.collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX, y: self.collectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (self.collectionView.contentInset.top - cellFrame.minY))
        }
        return cellFrame
    }
    
    //This function prevents the collectionView from accessing a deallocated cell. In the event
    //that the cell for the selectedIndexPath is nil, a default UIImageView is returned in its place
    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView {
        let visibleCells = self.collectionView.indexPathsForVisibleItems
        //If the current indexPath is not visible in the collectionView,
        //scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(self.selectedIndexPath) {
            //Scroll the collectionView to the current selectedIndexPath which is offscreen
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
            //Guard against nil values
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell) else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            return guardedCell.imageView
        } else {
            guard let guardedCell = self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            return guardedCell.imageView
        }
        
    }
    
    //This function prevents the collectionView from accessing a deallocated cell. In the
    //event that the cell for the selectedIndexPath is nil, a default CGRect is returned in its place
    func getFrameFromCollectionViewCell(for selectedIndexPath: IndexPath) -> CGRect {
        let visibleCells = self.collectionView.indexPathsForVisibleItems
        //If the current indexPath is not visible in the collectionView,
        //scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(self.selectedIndexPath) {
            //Scroll the collectionView to the cell that is currently offscreen
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
            //Reload the items at the newly visible indexPaths
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()
            //Prevent the collectionView from returning a nil value
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            return guardedCell.frame
        } else {
            //Prevent the collectionView from returning a nil value
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            //The cell was found successfully
            return guardedCell.frame
        }
    }
    
    
 }
