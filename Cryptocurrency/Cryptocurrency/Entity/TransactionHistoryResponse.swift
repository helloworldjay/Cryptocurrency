//
//  TransactionHistoryResponse.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/09.
//

import Foundation

/**
{
   "status": "0000",
   "data": [
       {
           "transaction_date": "2022-02-08 23:28:13",
           "type": "bid",
           "units_traded": "0.0034",
           "price": "53221000",
           "total": "180951"
       },
       {
           "transaction_date": "2022-02-08 23:28:40",
           "type": "bid",
           "units_traded": "0.0312",
           "price": "53219000",
           "total": "1660432"
       }
   ]
}
*/

struct TransactionHistoryResponse: Decodable {
  let status: String
  let data: [TransactionHistoryData]
}

struct TransactionHistoryData: Decodable {
  let transactionDate: String
  let type: String
  let unitsTraded: String
  let price: String
  let total: String
  
  enum CodingKeys: String, CodingKey {
    case transactionDate = "transaction_date"
    case unitsTraded = "units_traded"
    case type ,price, total
  }
}
