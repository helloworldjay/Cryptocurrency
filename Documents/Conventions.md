# Conventions
***
## 목차

- [Git 컨벤션](#git-컨벤션)
  * [Branch 전략](#branch-전략)
  * [PR 컨벤션](#pr-컨벤션)
  * [PR 템플릿](#pr-템플릿)
  * [Commit 컨벤션](#commit-컨벤션)
- [Code 컨벤션](#code-컨벤션)



## Git 컨벤션

### Branch 전략

1. main: 배포 브랜치
2. develop: 개발 최종 브랜치
3. work branches: 작업 단위 브랜치
   - 기능을 작업 단위로 구분해 이슈를 생성하고, 그 이슈를 기준으로 PR을 생성해요
   - PR을 기준으로 work branch를 생성해요
   - 네이밍은 **"작업의 성격/작업 번호-작업 내용"** 으로 구성해요
    (e.g. docs/02-conventions)
   - 브랜치 네이밍은 모두 소문자, 의미 구별은 하이픈(-)으로 처리해요

<br/>

### PR 컨벤션

1. main 브랜치에 Merge하기 전에 develop 브랜치에서 작업을 통합해요
2. merge는 팀원 전체의 approve가 있을 경우만 진행해요
3. PR이 너무 오랜시간 남아있지 않도록 주기적으로 코드를 꼼꼼히 리뷰해요

<br/>

### PR 템플릿
>## 배경
>- issue# -
>- 이 작업을 하게 된 배경에 대해 설명해요
>
>## 수정 내역
>- 기능 단위, 혹은 파일 단위의 변경을 작성해요
>
>## 테스트 방법
>- 테스트를 통해 정상 작동하는지 확인해요
>
>## 리뷰 노트
>- 없음

<br/>

### Commit 컨벤션
1. 커밋의 네이밍은 **"[이슈번호] 커밋 내용"** 으로 구성해요
    (e.g. [#2] Commit에 관한 컨벤션 정리)
2. 커밋은 기능 단위로 구분해요

<br/>
<br/>

## Code 컨벤션

1. indentation
![Image 80](https://user-images.githubusercontent.com/58765757/149725584-82be917d-225f-4d53-aa32-134f04d25d8c.png)

2. 라이브러리 import 순서
   ```swift
    // 기본 제공 라이브러리
    import UIKit

    // 외부 라이브러리
    import Alamofire
    import RxSwift
    ...
   ```
- 기본 제공 라이브러리와 외부 라이브러리를 구분해요
- Alphabet order를 따라요

3. MARK 정책
   - 객체 외부에서 역할을 정의할 때에는 하이픈(-)으로 구별해요
   (e.g. //MARK: - TableView Delegate)
   - 객체 내부에서 역할을 정의할 때에는 하이픈 없이 표시해요
   - 클래스 명 바로 아래 첫 MARK는 한 줄의 공백, 이후로는 2줄의 공백을 따라요

   ```Swift
   class ViewController: UIViewController {

     // MARK: Properties

     let searchBar: UISearchBar?
     ...
     
     
     // MARK: initializers
     ...
   }
   ```

4. 줄바꿈
   
   - parameter의 개수가 3개 이상인 경우, 혹은 코드가 길어지는 경우 반드시 new line으로 구별해줘요
   
5. Naming

   - 프로퍼티의 이름이 고유명사로 시작할 경우에도 소문자로 시작해요

     ```swift
     enum OrderCurrency {
       ...
       var koreanName: String {
         ...
       }
     }
     ```

6. 타입 명시

   - 타입 추론이 가능한 프로퍼티의 경우 타입을 생략해줘요

     ```swift
     let openPrice = 12000 // Int 타입 생략
     ```

7. 멤버 변수 / 함수

   - 객체에 속한 멤버 변수와 멤버 함수의 경우 `self` 키워드를 항상 명시해요

     ```swift
     final class ExchangeViewController: UIViewController {
     	let coinListView: CoinListView
       
       init() {
         self.coinListView = CoinListView() // self 명시
       }
       ...
     }
     ```

8. 접근 제한자

   - 외부에서 관찰 가능한 범위가 넓은 순서대로 작성해요

     ```swift
     final class CoinDetailViewController: UIViewController {
       // Public -> Internal -> private
     	public let coinDetailViewModel: CoinDetailViewModel
       let coinChartView: CoinChartView
       private let currentPriceLabel: CurrentPriceLabel
     }
     ```

9. 메서드 선언 위치

   - 특정 메서드 내에서만 사용되는 private 메서드의 경우 찾기 쉽도록 호출부 바로 아래에 호출 순서대로 선언해요

     ```swift
     init() {
       self.layout()
       self.attribute()
     }
     
     private func layout() {
       ...
     }
     
     private func attribute() {
       ...
     }
     ```

