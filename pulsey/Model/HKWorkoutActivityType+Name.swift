//
//  EmojiGender.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//


import HealthKit

public extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .archery:                      return "Archery"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .cricket:                      return "Cricket"
        case .crossTraining:                return "Cross Training"
        case .curling:                      return "Curling"
        case .cycling:                      return "Cycling"
        case .dance:                        return "Dance"
        case .danceInspiredTraining:        return "Dance Inspired Training"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Functional Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mindAndBody:                  return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Preparation and Recovery"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Running"
        case .sailing:                      return "Sailing"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing Sports"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Traditional Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"
        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Cross Country Skiing"
        case .downhillSkiing:               return "Downhill Skiing"
        case .flexibility:                  return "Flexibility"
        case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
        case .jumpRope:                     return "Jump Rope"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
        case .wheelchairRunPace:            return "Wheelchair Run Pace"
        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Mixed Cardio"
        case .handCycling:                  return "Hand Cycling"
        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"
        case .cardioDance:                  return "Cardio Dance"
        case .socialDance:                  return "Social Dance"
        case .pickleball:                   return "Pickle Ball"
        case .cooldown:                     return "Cool Down"
        case .swimBikeRun:                  return "Swim Bike Run"
        case .transition:                   return "Transition"
        case .underwaterDiving:             return "Underwater Diving"
        case .other:                        return "Other"
        @unknown default:                   return "Unknown"
        }
    }

    var koreanName: String {
        switch self {
        case .americanFootball:             return "미식 축구"
        case .archery:                      return "양궁"
        case .australianFootball:           return "호주식 축구"
        case .badminton:                    return "배드민턴"
        case .baseball:                     return "야구"
        case .basketball:                   return "농구"
        case .bowling:                      return "볼링"
        case .boxing:                       return "권투"
        case .climbing:                     return "클라이밍"
        case .cricket:                      return "크리켓"
        case .crossTraining:                return "크로스 트레이닝"
        case .curling:                      return "컬링"
        case .cycling:                      return "사이클링"
        case .dance:                        return "댄스"
        case .danceInspiredTraining:        return "댄스 영감 트레이닝"
        case .elliptical:                   return "엘립티컬"
        case .equestrianSports:             return "승마 스포츠"
        case .fencing:                      return "펜싱"
        case .fishing:                      return "낚시"
        case .functionalStrengthTraining:   return "기능성 근력 강화 운동"
        case .golf:                         return "골프"
        case .gymnastics:                   return "체조"
        case .handball:                     return "핸드볼"
        case .hiking:                       return "하이킹"
        case .hockey:                       return "하키"
        case .hunting:                      return "사냥"
        case .lacrosse:                     return "라크로스"
        case .martialArts:                  return "무술"
        case .mindAndBody:                  return "마음과 몸"
        case .mixedMetabolicCardioTraining: return "혼합 대사성 카디오 트레이닝"
        case .paddleSports:                 return "패들 스포츠"
        case .play:                         return "각종 놀이"
        case .preparationAndRecovery:       return "준비 및 회복"
        case .racquetball:                  return "라켓볼"
        case .rowing:                       return "조정"
        case .rugby:                        return "럭비"
        case .running:                      return "달리기"
        case .sailing:                      return "요트"
        case .skatingSports:                return "스케이팅 스포츠"
        case .snowSports:                   return "스노우 스포츠"
        case .soccer:                       return "축구"
        case .softball:                     return "소프트볼"
        case .squash:                       return "스쿼시"
        case .stairClimbing:                return "계단 오르기"
        case .surfingSports:                return "서핑 스포츠"
        case .swimming:                     return "수영"
        case .tableTennis:                  return "탁구"
        case .tennis:                       return "테니스"
        case .trackAndField:                return "육상"
        case .traditionalStrengthTraining:  return "근력 강화 운동"
        case .volleyball:                   return "배구"
        case .walking:                      return "걷기"
        case .waterFitness:                 return "워터 피트니스"
        case .waterPolo:                    return "수구"
        case .waterSports:                  return "수상 스포츠"
        case .wrestling:                    return "레슬링"
        case .yoga:                         return "요가"
        case .barre:                        return "바레"
        case .coreTraining:                 return "코어 운동"
        case .crossCountrySkiing:           return "크로스컨트리 스키"
        case .downhillSkiing:               return "다운힐 스키"
        case .flexibility:                  return "유연성"
        case .highIntensityIntervalTraining:    return "고강도 인터벌 트레이닝"
        case .jumpRope:                     return "줄넘기"
        case .kickboxing:                   return "킥복싱"
        case .pilates:                      return "필라테스"
        case .snowboarding:                 return "스노보딩"
        case .stairs:                       return "계단"
        case .stepTraining:                 return "스텝 트레이닝"
        case .wheelchairWalkPace:           return "휠체어 걷기 속도"
        case .wheelchairRunPace:            return "휠체어 달리기 속도"
        case .taiChi:                       return "태극권"
        case .mixedCardio:                  return "혼합 카디오"
        case .handCycling:                  return "핸드 사이클링"
        case .discSports:                   return "디스크 스포츠"
        case .fitnessGaming:                return "피트니스 게이밍"
        case .cardioDance:                  return "카디오 댄스"
        case .socialDance:                  return "사회 댄스"
        case .pickleball:                   return "피클볼"
        case .cooldown:                     return "쿨다운"
        case .swimBikeRun:                  return "수영 자전거 달리기"
        case .transition:                   return "전환"
        case .underwaterDiving:             return "수중 다이빙"
        case .other:                        return "기타"
        @unknown default:                   return "기타"
        }
    }
}

// MARK: - Emoji

public enum EmojiGender {
    case male
    case female
}

public extension HKWorkoutActivityType {
    func associatedEmoji(for gender: EmojiGender = .male) -> String? {
        switch self {
        case .climbing:
            switch gender {
            case .female:                   return "🧗‍♀️"
            case .male:                     return "🧗🏻‍♂️"
            }
        case .dance, .danceInspiredTraining:
            switch gender {
            case .female:                   return "💃"
            case .male:                     return "🕺🏿"
            }
        case .gymnastics:
            switch gender {
            case .female:                   return "🤸‍♀️"
            case .male:                     return "🤸‍♂️"
            }
        case .handball:
            switch gender {
            case .female:                   return "🤾‍♀️"
            case .male:                     return "🤾‍♂️"
            }
        case .mindAndBody, .yoga, .flexibility:
            switch gender {
            case .female:                   return "🧘‍♀️"
            case .male:                     return "🧘‍♂️"
            }
        case .preparationAndRecovery:
            switch gender {
            case .female:                   return "🙆‍♀️"
            case .male:                     return "🙆‍♂️"
            }
        case .running:
            switch gender {
            case .female:                   return "🏃‍♀️"
            case .male:                     return "🏃‍♂️"
            }
        case .surfingSports:
            switch gender {
            case .female:                   return "🏄‍♀️"
            case .male:                     return "🏄‍♂️"
            }
        case .swimming:
            switch gender {
            case .female:                   return "🏊‍♀️"
            case .male:                     return "🏊‍♂️"
            }
        case .walking:
            switch gender {
            case .female:                   return "🚶‍♀️"
            case .male:                     return "🚶‍♂️"
            }
        case .waterPolo:
            switch gender {
            case .female:                   return "🤽‍♀️"
            case .male:                     return "🤽‍♂️"
            }
        case .wrestling:
            switch gender {
            case .female:                   return "🤼‍♀️"
            case .male:                     return "🤼‍♂️"
            }
        default:                            return associatedEmoji
        }
    }

    private var associatedEmoji: String? {
        switch self {
        case .americanFootball:             return "🏈"
        case .archery:                      return "🏹"
        case .badminton:                    return "🏸"
        case .baseball:                     return "⚾️"
        case .basketball:                   return "🏀"
        case .bowling:                      return "🎳"
        case .boxing:                       return "🥊"
        case .curling:                      return "🥌"
        case .cycling:                      return "🚲"
        case .equestrianSports:             return "🏇"
        case .fencing:                      return "🤺"
        case .fishing:                      return "🎣"
        case .functionalStrengthTraining:   return "💪"
        case .golf:                         return "⛳️"
        case .hiking:                       return "🥾"
        case .hockey:                       return "🏒"
        case .lacrosse:                     return "🥍"
        case .martialArts:                  return "🥋"
        case .mixedMetabolicCardioTraining: return "❤️"
        case .paddleSports:                 return "🛶"
        case .rowing:                       return "🛶"
        case .rugby:                        return "🏉"
        case .sailing:                      return "⛵️"
        case .skatingSports:                return "⛸"
        case .snowSports:                   return "🛷"
        case .soccer:                       return "⚽️"
        case .softball:                     return "🥎"
        case .tableTennis:                  return "🏓"
        case .tennis:                       return "🎾"
        case .traditionalStrengthTraining:  return "🏋️‍♂️"
        case .volleyball:                   return "🏐"
        case .waterFitness, .waterSports:   return "💧"
        case .barre:                        return "🥿"
        case .crossCountrySkiing:           return "⛷"
        case .downhillSkiing:               return "⛷"
        case .kickboxing:                   return "🥋"
        case .snowboarding:                 return "🏂"
        case .mixedCardio:                  return "❤️"
        case .discSports:                   return "🥏"
        case .fitnessGaming:                return "🎮"
        default:                            return nil
        }
    }
}
