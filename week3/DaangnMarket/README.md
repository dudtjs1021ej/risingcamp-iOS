## ๐ ๊ตฌํ ํ๋ฉด

<img width="400" src="/gif/week3.gif">



## ๐ ์ฌ์ฉํ tableView์ collectionView

<img width="500" src="img/2.jpg">

<img width="500" src="img/3.jpg">

<img width="500" src="img/4.jpg">



## ๐ CRUD

<img width="1000" src="img/1.jpg" align = left>

- ๊ฑฐ๋๊ธ  CRUD ๊ตฌํ
- ๋ด๊ฐ ์ฌ๋ฆฐ ๊ธ๋ง ์ญ์ , ์์  ๊ฐ๋ฅ



## ๐ ์ ์ฌ์ฌ์ฉ ๋ฌธ์ 

- ์๋ก์ด ์์ ์ถ๊ฐํ๋ฉด ํํธ๋ ์ฑํ์ด nil์ด์ด๋ ๋จ๋ ๋ฌธ์  ๋ฐ์ โ ์์ ์ฌ์ฌ์ฉ ๋ฌธ์ 
- ์ด๊ธฐํํด์ฃผ๋ ์ฝ๋๋ฅผ ์์ฑํด์ ํด๊ฒฐ

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell")
            as? HomeTableViewCell else { return UITableViewCell() }
    
    // ์์ ์ฌ์ฌ์ฉ -> ์ด๊ธฐํ
    cell.heartCountLabel.text = nil
    cell.heartImageView.isHidden = true
    cell.chatCountLabel.text = nil
    cell.chatImageView.isHidden = true
}
```

- ๋ฉํ ๋ ํผ๋๋ฐฑ์ผ๋ก `prepareForReuse()` ์ ์์  ์๋ฃ!

```swift
override func prepareForReuse() {
    // ์์ ์ฌ์ฌ์ฉ -> ์ด๊ธฐํ
    heartCountLabel.text = nil
    heartImageView.isHidden = true
    chatCountLabel.text = nil
    chatImageView.isHidden = true
  }
```

## ๐ ํธ๋ฌ๋ธ ์ํ

๐ก **tableView ์ผ์ชฝ ๊ณต๋ฐฑ ์์ ๊ธฐ**

```swift
postTableView.separatorInset.left = 0
```


๐ก **tableview cell๋ง๋ค space ์ฃผ๊ณ  ์ถ์**

section์ array์ ๊ฐ์๋ก ์ฃผ๊ณ  footer์ UIView๋ฅผ ๋ฌ์์ค

```swift
extension CommunityViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return posts.count
  }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = postTableView.dequeueReusableCell(withIdentifier: "postCell")
            as? CommunityPostTableViewCell else { return UITableViewCell() }
    
    if indexPath.section != 0 {
      let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 5))
      footer.backgroundColor = UIColor(named:"lightGrayColor")
      cell.contentView.addSubview(footer)
    }
	}

}
```



๐ก **๊ฑฐ๋๊ธ createํ ๋๋ ์๋ก์ด ๋ชจ๋ธ ์์ฑ, update๋ ๊ทธ ๋ชจ๋ธ์ data๋ฅผ ๋ฐ๊พธ๋ ๋ฐฉ์์ผ๋ก ๊ตฌํํ๊ณ  ์ถ์**

- transcaction ํ๋กํผํฐ ์ ์ธํ๊ณ 

  updateํ ๋๋ง ๋ชจ๋ธ์ ๋๊ฒจ์ค์ nil์ด๋ฉด create, ์๋๋ฉด update๋ก ๊ตฌ๋ถ
