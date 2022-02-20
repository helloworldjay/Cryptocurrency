//
//  PersistenceManager.swift
//  Cryptocurrency
//
//  Created by 김민성 on 2022/02/18.
//

import Foundation

enum PersistenceActionType {
 case add, remove
}

enum PersistenceManager {
  static private let defaults = UserDefaults.standard

  enum Keys {
    static let favorites = "favorites"
  }

  static func updateWith(item: CoinItemCurrency, actionType: PersistenceActionType, completed: @escaping (UserDefaultsError?) -> Void) {
    retrieveFavorites {
      switch $0 {
      case .success(let favorites):
        var retrievedFavorite = favorites

        switch actionType {
        case .add:
          guard !retrievedFavorite.contains(item) else {
            completed(UserDefaultsError.unvalidItemError)
            return
          }
          retrievedFavorite.append(item)
        case .remove:
          retrievedFavorite.removeAll {
            $0.orderCurrency == item.orderCurrency && $0.paymentCurrency == item.paymentCurrency
          }
        }
        completed(save(favorites: retrievedFavorite))
      case .failure(let error):
        completed(error)
      }
    }
  }

  static func retrieveFavorites(completed: @escaping (Result<[CoinItemCurrency], UserDefaultsError>) -> Void) {
    guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
      completed(.success([]))
      return
    }

    do {
      let decoder = JSONDecoder()
      let favorites = try decoder.decode([CoinItemCurrency].self, from: favoritesData)
      completed(.success(favorites))
    } catch {
      completed(.failure(.decodingError))
    }
  }

  static func save(favorites: [CoinItemCurrency]) -> UserDefaultsError? {
    do {
      let encoder = JSONEncoder()
      let encodedFavorites = try encoder.encode(favorites)
      defaults.set(encodedFavorites, forKey: Keys.favorites)
      return nil
    } catch {
      return .encodingError
    }
  }

  static func isContained(with item: CoinItemCurrency) -> Bool {
    var result = false
    retrieveFavorites {
      switch $0 {
      case .success(let favorite):
        if favorite.contains(item) {
          result = true
        } else {
          result = false
        }
      case .failure(let error):
        print(error)
      }
    }
    return result
  }
}
