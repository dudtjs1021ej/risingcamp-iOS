## π κ΅¬ν νλ©΄
<img width="800" src="/gif/week4.gif">

## π κ²μ μ€λͺ

- κ°λ‘λͺ¨λλ§ νλ μ΄ κ°λ₯

1. **λΉκ·Ό μ¨μ μΊ‘μμ λΏλ €μ μ¨μμ΄ λμ€κ² νλ€.**
2. **λ¬Όμ μ€μ μ¨μμ ν€μ΄λ€.** ( 2λ² μ€μΌνκ³  μ¨μ β ν β λ―Έλ λΉκ·Ό β ν° λΉκ·ΌμΌλ‘ μ±μ₯)
3. **λΉκ·Όμ μ¬λ°°νλ€.**

- **μ€κ° μ€κ°μ λλμ§κ° λμμ λ°©ν΄ β λ§μΉλ‘ μ‘λλ€.**
- 8**0μ΄κ° μ§λλ©΄ κ²μ μ’λ£ β λͺ¨μ λΉκ·Ό κ°μ, μ‘μ λλμ§ μλ‘ μ μ κ³μ°**

## π μ¬μ©ν μ€λ λ
<img width="800" src="img/1.jpg">
- νμ΄λ¨Έ

```swift
// νμ΄λ¨Έ μμ±
  private func createTimer() {
    timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(fireTimer),
                                     userInfo: nil,
                                     repeats: true)
    DispatchQueue.main.async {
      self.timer.fire()
    }
  }
  
  @objc private func fireTimer() {
    timeLabel.text = String(time)
    time -= 1
    if time < 0 {
      timer.invalidate() // νμ΄λ¨Έ μ μ§
      let vc = EndViewController()
      vc.modalPresentationStyle = .overCurrentContext
      vc.score = score
      present(vc, animated: false, completion: nil)
    }
  }
```


- μ μ

```swift
// λΉκ·Ό μν
  private func harvest(imageView: UIImageView, index: Int) {
    DispatchQueue.global().async {
      self.score += 1
      DispatchQueue.main.async {
        imageView.image = .none
        self.scoreLabel.text = String(self.score) // μ μ update
      }
    }
    levels[index] = .level0 // level0μΌλ‘ μ΄κΈ°ν
    waterings[index] = [false, false] // 1λ¨κ³, 2λ¨κ³ λͺ¨λ λ¬Ό μμ€κ±Έλ‘ μ΄κΈ°ν
  }
```


- λλμ§

```swift
// λλμ§ μμ±
  private func createMole() {
    DispatchQueue.global().async {
      for _ in 1...8 {
        usleep(10000000) // 10μ΄μ ν λ² λλμ§ λμ΄
        DispatchQueue.main.async {
          for _ in 0..<1 {
            let randomNum = Int.random(in: 0...11)
            self.moles[randomNum] = true // λλμ§ μλ€κ³  μ²΄ν¬
            self.playMoleSound()
            self.moleImageViews[randomNum].animate(withGIFNamed: "mole")
          }
        }
      }
    }
  }
```

- 12κ° λ°­ μ±μ₯ μ²λ¦¬

```swift
// level1 -> level2λ‘ μ±μ₯ μ²λ¦¬
  private func level1toLevel2(imageView: UIImageView, index: Int) {
    DispatchQueue.global().async {
      for i in 1...5 {
        DispatchQueue.main.async {
          imageView.image = UIImage(named: "level2_\\(i)") // imageview λ°κΏμ€
        }
        usleep(1000000)
      }
      self.levels[index] = .level2 // level up
    }
  }
```

- λ°°κ²½μμ & ν¨κ³Όμ (λλμ§ λνλ  λ, λλμ§ μ‘μ λ, λ¬Ό μ€λ, μ¨μ λΏλ¦΄ λ, μνν  λ)

```swift
// λ°°κ²½ μμ μ½μ
  private func playBGM() {
    DispatchQueue.global().async {
      guard let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3") else {
        print("error to get the mp3 file")
        return
      }
      self.backgorundPlayer = AVPlayer(url: url)
      self.backgorundPlayer.volume = 0.1
      self.backgorundPlayer.play()
    }
  }
```


## π μ€λ λ κ΄λ ¨ μ΄μ

1. **λμμ± μ΄μ**

```swift
// level1 -> level2λ‘ μ±μ₯ μ²λ¦¬
  private func level1toLevel2(imageView: UIImageView, index: Int) {
    DispatchQueue.global().async {
      for i in 1...5 {
        DispatchQueue.main.async {
          imageView.image = UIImage(named: "level2_\\(i)") // imageview λ°κΏμ€
        }
        usleep(1000000)
      }
      self.levels[index] = .level2 // level up
    }
  }
```

- 1μ΄μ μ‘°κΈμ© λΉκ·Όμ΄ μλΌλλ κ²μ DispatchQueueμμμ νννκ³  μΆμ
- μ²μμ μκΎΈ μ΅μ’ μ±μ₯ μ΄λ―Έμ§λ§ λ μ λ΄€λλ syncλ₯Ό μ°κ³  μμμ `DispatchQueue.global().sync` ->  `DispatchQueue.global().async` μ΄λ κ² μμ ν΄μ ν΄κ²° (`sync` - λμμ± o, `async` - λμμ±x)
  

2. **UIμ²λ¦¬λ λ°λμ `main thread`μμλ§ ν΄μΌν¨**

```swift
DispatchQueue.main.async {
          imageView.image = UIImage(named: "level3_\\(i)")
}
```

- UIμ κ΄λ ¨λ λͺ¨λ  eventκ° main threadμ λΆκΈ° λλ¬Έμ λ°λμ mainμμ ν΄μΌν¨
  

3. **`DispatchQueue.main.sync` λ μλ¬**

```swift
DispatchQueue.main.sync { // -> μλ¬!!
}
```

- deadlockμ΄ λκΈ°λλ¬Έ 
