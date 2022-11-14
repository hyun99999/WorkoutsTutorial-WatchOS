# 🕰️ WorkoutsTutorial-WatchOS

- [WWDC22) Build a workout app for Apple Watch](https://developer.apple.com/videos/play/wwdc2021/10009/) 세션에서 알아보는 HealthKit 에 대해서 기록해보았습니다.
- HealthKit 의 heart rate 를 사용하기 위한 목표를 가지고 시청한 세션입니다.

## 👉 Build a workout app for Apple Watch

세션 중 심박수를 수집할 수 있는 `HKWorkoutSession` 클래스에 대해서 들을 수 있었다.

<img width="700" alt="스크린샷 2022-11-08 오후 1 51 06" src="https://user-images.githubusercontent.com/69136340/201652898-919387dd-bf7c-49d4-80b4-7b78fbc8e4c9.png">

- `HKWorkoutSession` 은 데이터 수집을 위해 장치의 센서를 준비하므로, 운동과 관련된 데이터를 정확하게 수집할 수 있습니다 **(칼로리와 심박수와 같은 정보 수집)** . 또한 운동이 활성화되어 있을 때 애플리케이션이 백그라운드에서 실행되도록 합니다.
- `HKLiveWorkoutBuilder` 는 HKWorkout 객체를 생성하고 저장합니다. 자동으로 샘플과 이벤트를 수집합니다.

`**New ways to work with workouts**` 세션에서 많은 내용을 확인할 수 있습니다.

### 👉 request authorization 단계

```swift
/// Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }

// ✅ 뷰가 나타날 때 권한을 요청하면 됩니다.

// .onAppear {
//            workoutManager.requestAuthorization()
//           }
```

### 👉 프로젝트 세팅

- watch app target 에 `HealthKit` 을 추가합니다.
- 백그라운드에서 workout session 이 실행되어야 하기 때문에 `background modes capability` 를 추가해야 합니다.

<img width="600" alt="스크린샷 2022-11-11 오후 6 02 29" src="https://user-images.githubusercontent.com/69136340/201652970-d44a3251-79e2-41f2-97f8-a3f8fec5e46b.png">

- 해당 target 이 HealthKit 을 지원하도록 설정합니다.
    - apple developer 에서 Identifiers 에서 App ID 로 추가합니다.
    - HealthKit 지원을 선택하고 번들 아이디를 입력해서 App ID 를 생성합니다.

<img width="700" alt="스크린샷 2022-11-11 오후 6 13 21" src="https://user-images.githubusercontent.com/69136340/201653061-ac0ed383-d7ea-4b08-9163-044181b87b23.png">

<img width="300" alt="스크린샷 2022-11-11 오후 6 13 02" src="https://user-images.githubusercontent.com/69136340/201653052-da5abae3-9b73-4f9e-bcd1-9605568fed11.png">

- info.plist 에서 권한을 얻을 때 문구를 설정해줍니다.
    - `NSHealthShareUsageDescription` 혹은 `Privacy - Health Share Usage Description` key 를 추가해줍니다.(앱이 왜 데이터를 읽어와야 하는지 설명합니다.)
    - `NSHealthUpdateUsageDescription` 혹은 `Privacy - Health Update Usage Description` key 를 추가해줍니다.(앱에서  작성하려는 데이터에 대해서 설명합니다.)
    
<img width="700" alt="스크린샷 2022-11-11 오후 6 35 28" src="https://user-images.githubusercontent.com/69136340/201654602-0864f974-60b3-4110-bcd0-651561981422.png">


### 👉 빌드하여 Authorization 확인

- 빌드 해보겠습니다. (`심장 - 심박수` 의 읽기 권한을 얻을 수 있습니다.)
    - 우리가 제공한 설명들을 볼 수 있습니다.
    - 우리가 추가한 권한에 대해서 볼 수 있습니다.

<img width="700" alt="스크린샷 2022-11-14 오후 8 47 41" src="https://user-images.githubusercontent.com/69136340/201653246-a231b572-73b9-4e14-ba24-8e1c540d2bbf.png">

**권한을 얻었으니 심박수의 정보를 얻어보겠습니다.**

### 👉 heart rate(심박수)

- builder 새로운 샘플을 수집할 때마다 호출되는 delegate method 를 다음과 같이 구현하였습니다.
- statistics 중 heartRate 에 해당하는 경우를 switch 문으로 대응해주었습니다.

```swift
// MARK: - HKLiveWorkoutBuilderDelegate

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    /// called whenever the builder collects an events.
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
         // ...
    }

    /// ✅ called whenever the builder collects new samples.
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // ✅ Update the published values.
            updateForStatistics(statistics)
        }
    }
}

// ...

// MARK: - Workout Metrics

    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            // ✅ We want beats per minute, so we use a count HKUnit divided by a minute HKUnit.
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0

// ...

            }
        }
    }
```

### ✅ Data flow

data flow 에 대해서 알아보자.

<img width="700" alt="스크린샷 2022-11-08 오후 3 45 36" src="https://user-images.githubusercontent.com/69136340/201654356-48768635-c08c-47e6-9c6e-d92871179a23.png">

WorkoutManager(우리가 만드는 HealthKit 을 매니징 할 수 있는 클래스)는 HealthKit 과의 인터페이스를 담당합니다. 
HKWorkoutSession 과 인터페이스하여 운동을 시작, 일시 중지 및 종료 할 수 있습니다.
HKLiveWorkoutBuilder 와 인터페이스하여 운동 샘플을 수신하고 해당 데이터를 뷰에 제공할 수 있습니다.

environmentObject 로 WorkoutManager 를 할당하여 NavigationView 의 뷰 계층 구조에 있는 뷰에 전파할 수 있습니다.
그리고 다음 뷰는 @EnvironmentObject 를 선언하여 WorkoutManager 에 대한 액세스 권한을 얻을 수 있습니다.

출처:

[Build a workout app for Apple Watch - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10009/)

---

### 👉 애플 워치 기기로 Xcode 에서 빌드 할 때

[Apple Developer Documentation - Testing custom notification interfaces](https://developer.apple.com/documentation/watchos-apps/testing-custom-notification-interfaces)

위는 Notification interfaces 를 기기에서 빌드하는 방법을 소개해준 글입니다. 이를 통해 우리는 손목에 착용하지 않아도 어떤 조건으로 기기에서 빌드할 수 있는지 알 수 있습니다.

_**기기를 손목에 착용하지 않은 상태에서 notification interfaces 를 테스트하려면 다음의 단계를 따르면 됩니다.**_

- 애플 워치에서 손목 감지를 비활성화 합니다. companion iPhone 의 watch 앱 또는 watch 의 Setting 에서 설정할 수 있습니다. 옵션은 **Passcode > Wrist Detection** 에 있습니다.
- 애플 워치가 충전기에 연결되어 있지 않은지 확인합니다.
- iPhone 을 잠급니다.

watch-only app 을 만들더라도 내 iPhone 기기를 통해서 애플워치에 접근할 수 있었습니다.

이때 provisioning profile 에 애플 워치 기기를 추가하여 빌드할 수 있다는 창이 등장합니다. 이를 통해 신뢰하고 빌드할 수 있는 기기로 추가할 수 있었습니다.

<img width="300" alt="스크린샷 2022-11-12 오전 8 24 37" src="https://user-images.githubusercontent.com/69136340/201653306-fdf1035c-1c14-4615-af3b-f5578aac52f6.png">
