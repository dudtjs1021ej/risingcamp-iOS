## ๐ ๊ตฌํํ๋ฉด
<img width="300" src="/gif/week2.gif">

## ๐ย ์ฌ์ฉํ LifeCycle

- `viewDidAppear` - ํ์์ฐฝ ๋์ธ๋ ์ฌ์ฉ

```swift
// ํ์ ์ฐฝ ์ฒดํฌ
  override func viewDidAppear(_ animated: Bool) {
    print(UserDefaults.standard.bool(forKey: "popUp"))
    if UserDefaults.standard.bool(forKey: "popUp") == true {
      let popUpVC = PopUpViewController()
      popUpVC.modalPresentationStyle = .overCurrentContext
      self.present(popUpVC, animated: false)
    }
  }
```

- `viewWillAppear` - ๋ค๋น๊ฒ์ด์๋ฐ ์จ๊ธธ ๋ ์ฌ์ฉ

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
  }
```

- `sceneDidBecomeActive`, `sceneWillResignActive` - ์ค์์ฒ ๋ชจ๋์์ ์ด๋ฏธ์ง๋ทฐ ์ฒ๋ฆฌ

```swift
// ์กํฐ๋ธ ์ํ๊ฐ ๋์ ๊ฒฝ์ฐ - ์ด๋ฏธ์ง๋ทฐ ์ญ์ 
  func sceneDidBecomeActive(_ scene: UIScene) {
    if let imageView = imageView {
      imageView.removeFromSuperview()
    }
  }

  // Switcher๋ชจ๋ - window์ ์ด๋ฏธ์ง ์ถ๊ฐ
  func sceneWillResignActive(_ scene: UIScene) {
    guard let window = window else {
      return
    }
    imageView = UIImageView(frame: window.frame)
    imageView?.image = UIImage(named: "switcher")
    window.addSubview(imageView!)
  }
```

## ๐ย ํธ๋ฌ๋ธ์ํ

๐ก **๋ ๋ฒ์งธ VC์์ ์ฒซ ๋ฒ์งธ VC๋ก dismiss ํ๋ฉด์ ๋ฐ์ดํฐ๋ฅผ ์ ๋ฌํ๊ณ  ์ถ์**

1. **`viewWillAppear` ๋ก ํ์**

```swift
// ์ฒซ๋ฒ์งธ VC
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("optionCount\(optionCount)")
    if optionCount != 0 {
      optionLabel.text = "์ท์ถ๊ฐ(\(String(optionCount))"
    }
  }
```

```swift
// ๋๋ฒ์งธ VC
@IBAction func ClickedSelect(_ sender: Any) {
    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailCoffeeMenu") as? DetailCoffeeMenuViewController else { return }
    vc.optionCount = count
    dismiss(animated: false)
  }
```
์์ฒ๋ผ ๊ตฌํํ์ผ๋ `fullScreen`์ผ๋ก presentStyle์ ์ค์ ํ์ง ์์ dismiss๋ฅผ ํด๋ `viewWillAppear`๊ฐ ํธ์ถ๋์ง ์์ โ **์คํจ**

1. **`Protocol` ์ฌ์ฉํ์ฌ `delegate` ๋ก ๋ฐ์ดํฐ ์ ๋ฌ**

```swift
// ๋๋ฒ์งธ VC

//1. ํ๋กํ ์ฝ ์ ์
protocol OptionCountProtocol {
  func dataSend(optionCount: Int)
}

// 2.delegate ํ๋กํผํฐ ์ ์ธ
var delegate: OptionCountProtocol?

// 3. ์ ํ ๋ฒํผ์ ํด๋ฆญํ๋ฉด dataSend ํธ์ถ
@IBAction func ClickedSelect(_ sender: Any) {
    delegate?.dataSend(optionCount: count) // delegate๋ก ์ ํ ์ต์ ์๋ ๋ณด๋
}
```

```swift
// ์ฒซ๋ฒ์งธ VC

// 1. ํ๋กํ ์ฝ ์ฑํ ํ ๊ตฌํ
extension DetailCoffeeMenuViewController: OptionCountProtocol {
  func dataSend(optionCount: Int) {
    print("dataSend")
    self.optionCount = optionCount
    if optionCount != 0 {
      optionLabel.text = "์ท์ถ๊ฐ(\(String(optionCount)))"
    }
  }
}

// 2. delegate ๋๋ฆฌ์ ์์
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "optionSegue" {
      guard let vc: OptionMenuViewController = segue.destination as? OptionMenuViewController else { return }
      vc.delegate = self
    }
}
```
๋ ๋ฒ์งธ VC์์ ์ ํํ ์ต์ ์ฒซ๋ฒ์งธ VC์ ํ์ํจ โ **ํด๊ฒฐ**
