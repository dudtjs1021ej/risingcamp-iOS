//
//  FirstTabViewController.swift
//  MovieAPI
//
//  Created by 임영선 on 2022/05/12.
//

import UIKit
import KakaoSDKUser

class FirstTabViewController: UIViewController {

  // MARK:- Properties
  @IBOutlet weak var adCollectionView: UICollectionView!
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet var views: [UIView]!
  let adImageViewNames: [String] = ["ad1", "ad2"]
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    adCollectionView.dataSource = self
    adCollectionView.delegate = self
    
    for view in views {
      view.layer.cornerRadius = 30
    }
    profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    profileImageView.layer.borderWidth = 1
    profileImageView.layer.borderColor = UIColor.systemGray4.cgColor
    setUserInfo()
  }
  
  // MARK: - Methods
  func setUserInfo() {
    UserApi.shared.me() { (user, error) in
      if let error = error {
        print(error)
      } else {
        print("me() success")
        _ = user
        self.nicknameLabel.text = user?.kakaoAccount?.profile?.nickname
        if let imageUrl = user?.kakaoAccount?.profile?.profileImageUrl,
        let data = try? Data(contentsOf: imageUrl) {
          self.profileImageView.image = UIImage(data: data)
        }
      }
    }
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FirstTabViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == adCollectionView {
      guard let cell = adCollectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath)
              as? ADCollectionViewCell else { return UICollectionViewCell() }
      cell.imgView.image = UIImage(named: adImageViewNames[indexPath.row])
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
  
}
