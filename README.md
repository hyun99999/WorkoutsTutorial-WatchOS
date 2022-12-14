# π°οΈ WorkoutsTutorial-WatchOS

- [WWDC22) Build a workout app for Apple Watch](https://developer.apple.com/videos/play/wwdc2021/10009/) μΈμμμ μμλ³΄λ HealthKit μ λν΄μ κΈ°λ‘ν΄λ³΄μμ΅λλ€.
- HealthKit μ heart rate λ₯Ό μ¬μ©νκΈ° μν λͺ©νλ₯Ό κ°μ§κ³  μμ²­ν μΈμμλλ€.

*λ€μμ μΈμμ κ²°κ³Όμλλ€.* 
<img src="https://user-images.githubusercontent.com/69136340/202677965-6f775d33-8c29-498c-816f-3d07e02852e9.mp4" width ="200">

## πΒ Build a workout app for Apple Watch

μΈμ μ€ μ¬λ°μλ₯Ό μμ§ν  μ μλ `HKWorkoutSession` ν΄λμ€μ λν΄μ λ€μ μ μμλ€.

<img width="700" alt="μ€ν¬λ¦°μ· 2022-11-08 μ€ν 1 51 06" src="https://user-images.githubusercontent.com/69136340/201652898-919387dd-bf7c-49d4-80b4-7b78fbc8e4c9.png">

- `HKWorkoutSession` μ λ°μ΄ν° μμ§μ μν΄ μ₯μΉμ μΌμλ₯Ό μ€λΉνλ―λ‘, μ΄λκ³Ό κ΄λ ¨λ λ°μ΄ν°λ₯Ό μ ννκ² μμ§ν  μ μμ΅λλ€ **(μΉΌλ‘λ¦¬μ μ¬λ°μμ κ°μ μ λ³΄ μμ§)** . λν μ΄λμ΄ νμ±νλμ΄ μμ λ μ νλ¦¬μΌμ΄μμ΄ λ°±κ·ΈλΌμ΄λμμ μ€νλλλ‘ ν©λλ€.
- `HKLiveWorkoutBuilder` λ HKWorkout κ°μ²΄λ₯Ό μμ±νκ³  μ μ₯ν©λλ€. μλμΌλ‘ μνκ³Ό μ΄λ²€νΈλ₯Ό μμ§ν©λλ€.

`**New ways to work with workouts**` μΈμμμ λ§μ λ΄μ©μ νμΈν  μ μμ΅λλ€.

### πΒ request authorization λ¨κ³

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

// β λ·°κ° λνλ  λ κΆνμ μμ²­νλ©΄ λ©λλ€.

// .onAppear {
//            workoutManager.requestAuthorization()
//           }
```

### πΒ νλ‘μ νΈ μΈν

- watch app target μ `HealthKit` μ μΆκ°ν©λλ€.
- λ°±κ·ΈλΌμ΄λμμ workout session μ΄ μ€νλμ΄μΌ νκΈ° λλ¬Έμ `background modes capability` λ₯Ό μΆκ°ν΄μΌ ν©λλ€.

<img width="700" alt="αα³αα³αα΅α«αα£αΊ 2022-11-14 αα©αα? 10 58 09" src="https://user-images.githubusercontent.com/69136340/201678623-7dd9d02d-45c0-4ddb-95df-f2a79e6d369e.png">

- ν΄λΉ target μ΄ HealthKit μ μ§μνλλ‘ μ€μ ν©λλ€.
    - apple developer μμ Identifiers μμ App ID λ‘ μΆκ°ν©λλ€.
    - HealthKit μ§μμ μ ννκ³  λ²λ€ μμ΄λλ₯Ό μλ ₯ν΄μ App ID λ₯Ό μμ±ν©λλ€.

<img width="700" alt="αα³αα³αα΅α«αα£αΊ 2022-11-11 αα©αα? 6 13 21" src="https://user-images.githubusercontent.com/69136340/201653061-ac0ed383-d7ea-4b08-9163-044181b87b23.png">

<img width="300" alt="μ€ν¬λ¦°μ· 2022-11-11 μ€ν 6 13 02" src="https://user-images.githubusercontent.com/69136340/201653052-da5abae3-9b73-4f9e-bcd1-9605568fed11.png">

- info.plist μμ κΆνμ μ»μ λ λ¬Έκ΅¬λ₯Ό μ€μ ν΄μ€λλ€.
    - `NSHealthShareUsageDescription` νΉμ `Privacy - Health Share Usage Description` key λ₯Ό μΆκ°ν΄μ€λλ€.(μ±μ΄ μ λ°μ΄ν°λ₯Ό μ½μ΄μμΌ νλμ§ μ€λͺν©λλ€.)
    - `NSHealthUpdateUsageDescription` νΉμ `Privacy - Health Update Usage Description` key λ₯Ό μΆκ°ν΄μ€λλ€.(μ±μμ  μμ±νλ €λ λ°μ΄ν°μ λν΄μ μ€λͺν©λλ€.)
    
<img width="700" alt="αα³αα³αα΅α«αα£αΊ 2022-11-11 αα©αα? 6 35 28" src="https://user-images.githubusercontent.com/69136340/201654602-0864f974-60b3-4110-bcd0-651561981422.png">


### πΒ λΉλνμ¬ Authorization νμΈ

- λΉλ ν΄λ³΄κ² μ΅λλ€. (`μ¬μ₯ - μ¬λ°μ` μ μ½κΈ° κΆνμ μ»μ μ μμ΅λλ€.)
    - μ°λ¦¬κ° μ κ³΅ν μ€λͺλ€μ λ³Ό μ μμ΅λλ€.
    - μ°λ¦¬κ° μΆκ°ν κΆνμ λν΄μ λ³Ό μ μμ΅λλ€.

<img width="700" alt="αα³αα³αα΅α«αα£αΊ 2022-11-14 αα©αα? 8 47 41" src="https://user-images.githubusercontent.com/69136340/201653246-a231b572-73b9-4e14-ba24-8e1c540d2bbf.png">

**κΆνμ μ»μμΌλ μ¬λ°μμ μ λ³΄λ₯Ό μ»μ΄λ³΄κ² μ΅λλ€.**

### πΒ heart rate(μ¬λ°μ)

- builder μλ‘μ΄ μνμ μμ§ν  λλ§λ€ νΈμΆλλ delegate method λ₯Ό λ€μκ³Ό κ°μ΄ κ΅¬ννμμ΅λλ€.
- statistics μ€ heartRate μ ν΄λΉνλ κ²½μ°λ₯Ό switch λ¬ΈμΌλ‘ λμν΄μ£Όμμ΅λλ€.

```swift
// MARK: - HKLiveWorkoutBuilderDelegate

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    /// called whenever the builder collects an events.
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
         // ...
    }

    /// β called whenever the builder collects new samples.
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // β Update the published values.
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
            // β We want beats per minute, so we use a count HKUnit divided by a minute HKUnit.
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0

// ...

            }
        }
    }
```

### βΒ Data flow

data flow μ λν΄μ μμλ³΄μ.

<img width="700" alt="αα³αα³αα΅α«αα£αΊ 2022-11-08 αα©αα? 3 45 36" src="https://user-images.githubusercontent.com/69136340/201654356-48768635-c08c-47e6-9c6e-d92871179a23.png">

WorkoutManager(μ°λ¦¬κ° λ§λλ HealthKit μ λ§€λμ§ ν  μ μλ ν΄λμ€)λ HealthKit κ³Όμ μΈν°νμ΄μ€λ₯Ό λ΄λΉν©λλ€. 
HKWorkoutSession κ³Ό μΈν°νμ΄μ€νμ¬ μ΄λμ μμ, μΌμ μ€μ§ λ° μ’λ£ ν  μ μμ΅λλ€.
HKLiveWorkoutBuilder μ μΈν°νμ΄μ€νμ¬ μ΄λ μνμ μμ νκ³  ν΄λΉ λ°μ΄ν°λ₯Ό λ·°μ μ κ³΅ν  μ μμ΅λλ€.

environmentObject λ‘ WorkoutManager λ₯Ό ν λΉνμ¬ NavigationView μ λ·° κ³μΈ΅ κ΅¬μ‘°μ μλ λ·°μ μ νν  μ μμ΅λλ€.
κ·Έλ¦¬κ³  λ€μ λ·°λ @EnvironmentObject λ₯Ό μ μΈνμ¬ WorkoutManager μ λν μ‘μΈμ€ κΆνμ μ»μ μ μμ΅λλ€.

μΆμ²:

[Build a workout app for Apple Watch - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10009/)

---

### πΒ μ ν μμΉ κΈ°κΈ°λ‘ Xcode μμ λΉλ ν  λ

[Apple Developer Documentation - Testing custom notification interfaces](https://developer.apple.com/documentation/watchos-apps/testing-custom-notification-interfaces)

μλ Notification interfaces λ₯Ό κΈ°κΈ°μμ λΉλνλ λ°©λ²μ μκ°ν΄μ€ κΈμλλ€. μ΄λ₯Ό ν΅ν΄ μ°λ¦¬λ μλͺ©μ μ°©μ©νμ§ μμλ μ΄λ€ μ‘°κ±΄μΌλ‘ κΈ°κΈ°μμ λΉλν  μ μλμ§ μ μ μμ΅λλ€.

_**κΈ°κΈ°λ₯Ό μλͺ©μ μ°©μ©νμ§ μμ μνμμ notification interfaces λ₯Ό νμ€νΈνλ €λ©΄ λ€μμ λ¨κ³λ₯Ό λ°λ₯΄λ©΄ λ©λλ€.**_

- μ ν μμΉμμ μλͺ© κ°μ§λ₯Ό λΉνμ±ν ν©λλ€. companion iPhone μ watch μ± λλ watch μ Setting μμ μ€μ ν  μ μμ΅λλ€. μ΅μμΒ **Passcode > Wrist Detection**Β μ μμ΅λλ€.
- μ ν μμΉκ° μΆ©μ κΈ°μ μ°κ²°λμ΄ μμ§ μμμ§ νμΈν©λλ€.
- iPhone μ μ κΈλλ€.

watch-only app μ λ§λ€λλΌλ λ΄ iPhone κΈ°κΈ°λ₯Ό ν΅ν΄μ μ νμμΉμ μ κ·Όν  μ μμμ΅λλ€.

μ΄λ provisioning profile μ μ ν μμΉ κΈ°κΈ°λ₯Ό μΆκ°νμ¬ λΉλν  μ μλ€λ μ°½μ΄ λ±μ₯ν©λλ€. μ΄λ₯Ό ν΅ν΄ μ λ’°νκ³  λΉλν  μ μλ κΈ°κΈ°λ‘ μΆκ°ν  μ μμμ΅λλ€.

<img width="300" alt="αα³αα³αα΅α«αα£αΊ 2022-11-12 αα©αα₯α« 8 24 37" src="https://user-images.githubusercontent.com/69136340/201653306-fdf1035c-1c14-4615-af3b-f5578aac52f6.png">
