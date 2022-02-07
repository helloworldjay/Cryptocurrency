//
//  CoinType.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/23.
//

import Foundation

enum PaymentCurrency: String {
  case krw = "KRW"
  case btc = "BTC"
}

enum OrderCurrency: String, CaseIterable {
  case all = "ALL"
  case btc = "BTC"
  case eth = "ETH"
  case ltc = "LTC"
  case etc = "ETC"
  case xrp = "XRP"
  case bch = "BCH"
  case qtum = "QTUM"
  case btg = "BTG"
  case eos = "EOS"
  case icx = "ICX"
  case trx = "TRX"
  case elf = "ELF"
  case omg = "OMG"
  case knc = "KNC"
  case glm = "GLM"
  case zil = "ZIL"
  case waxp = "WAXP"
  case powr = "POWR"
  case lrc = "LRC"
  case steem = "STEEM"
  case strax = "STRAX"
  case zrx = "ZRX"
  case rep = "REP"
  case xem = "XEM"
  case snt = "SNT"
  case ada = "ADA"
  case ctxc = "CTXC"
  case bat = "BAT"
  case wtc = "WTC"
  case theta = "THETA"
  case loom = "LOOM"
  case waves = "WAVES"
  case dataTRUE = "TRUE"
  case link = "LINK"
  case enj = "ENJ"
  case vet = "VET"
  case mtl = "MTL"
  case iost = "IOST"
  case tmtg = "TMTG"
  case qkc = "QKC"
  case atolo = "ATOLO"
  case amo = "AMO"
  case bsv = "BSV"
  case orbs = "ORBS"
  case tfuel = "TFUEL"
  case valor = "VALOR"
  case con = "CON"
  case ankr = "ANKR"
  case mix = "MIX"
  case cro = "CRO"
  case fx = "FX"
  case chr = "CHR"
  case mbl = "MBL"
  case mxc = "MXC"
  case fct = "FCT"
  case trv = "TRV"
  case dad = "DAD"
  case wom = "WOM"
  case soc = "SOC"
  case boa = "BOA"
  case fleta = "FLETA"
  case sxp = "SXP"
  case cos = "COS"
  case apix = "APIX"
  case el = "EL"
  case basic = "BASIC"
  case hive = "HIVE"
  case xpr = "XPR"
  case vra = "VRA"
  case fit = "FIT"
  case egg = "EGG"
  case bora = "BORA"
  case arpa = "ARPA"
  case ctc = "CTC"
  case apm = "APM"
  case ckb = "CKB"
  case aergo = "AERGO"
  case anw = "ANW"
  case cennz = "CENNZ"
  case evz = "EVZ"
  case cyclub = "CYCLUB"
  case srm = "SRM"
  case qtcon = "QTCON"
  case uni = "UNI"
  case yfi = "YFI"
  case uma = "UMA"
  case aave = "AAVE"
  case comp = "COMP"
  case ren = "REN"
  case bal = "BAL"
  case rsr = "RSR"
  case nmr = "NMR"
  case rlc = "RLC"
  case uos = "UOS"
  case sand = "SAND"
  case gom2 = "GOM2"
  case ringx = "RINGX"
  case bel = "BEL"
  case obsr = "OBSR"
  case orc = "ORC"
  case pola = "POLA"
  case awo = "AWO"
  case adp = "ADP"
  case dvi = "DVI"
  case ghx = "GHX"
  case mir = "MIR"
  case mvc = "MVC"
  case bly = "BLY"
  case wozx = "WOZX"
  case anv = "ANV"
  case grt = "GRT"
  case mm = "MM"
  case biot = "BIOT"
  case xno = "XNO"
  case snx = "SNX"
  case sofi = "SOFI"
  case cola = "COLA"
  case nu = "NU"
  case oxt = "OXT"
  case lina = "LINA"
  case map = "MAP"
  case aqt = "AQT"
  case wiken = "WIKEN"
  case ctsi = "CTSI"
  case mana = "MANA"
  case lpt = "LPT"
  case mkr = "MKR"
  case sushi = "SUSHI"
  case asm = "ASM"
  case pundix = "PUNDIX"
  case celr = "CELR"
  case lf = "LF"
  case arw = "ARW"
  case msb = "MSB"
  case rly = "RLY"
  case ocean = "OCEAN"
  case bfc = "BFC"
  case alice = "ALICE"
  case coti = "COTI"
  case cake = "CAKE"
  case bnt = "BNT"
  case xvs = "XVS"
  case chz = "CHZ"
  case axs = "AXS"
  case dao = "DAO"
  case dai = "DAI"
  case matic = "MATIC"
  case woo = "WOO"
  case bake = "BAKE"
  case velo = "VELO"
  case bcd = "BCD"
  case xlm = "XLM"
  case gxc = "GXC"
  case vsys = "VSYS"
  case ipx = "IPX"
  case wicc = "WICC"
  case ont = "ONT"
  case luna = "LUNA"
  case aion = "AION"
  case meta = "META"
  case klay = "KLAY"
  case ong = "ONG"
  case algo = "ALGO"
  case jst = "JST"
  case xtz = "XTZ"
  case mlk = "MLK"
  case wemix = "WEMIX"
  case dot = "DOT"
  case atom = "ATOM"
  case ssx = "SSX"
  case temco = "TEMCO"
  case hibs = "HIBS"
  case burger = "BURGER"
  case doge = "DOGE"
  case ksm = "KSM"
  case ctk = "CTK"
  case xym = "XYM"
  case bnb = "BNB"
  case nft = "NFT"
  case sun = "SUN"
  case xec = "XEC"
  case pci = "PCI"
  case sol = "SOL"
  case med = "MED"
  case inch1 = "1INCH"
  case boba = "BOBA"
  case gala = "GALA"
  case btt = "BTT"
  
  var koreanName: String {
    switch self {
    case .btc:
      return "비트코인"
    case .eth:
      return "이더리움"
    case .ltc:
      return "라이트코인"
    case .etc:
      return "이더리움 클래식"
    case .xrp:
      return "리플"
    case .bch:
      return "비트코인 캐시"
    case .qtum:
      return "퀀텀"
    case .btg:
      return "비트코인 골드"
    case .eos:
      return "이오스"
    case .icx:
      return "아이콘"
    case .trx:
      return "트론"
    case .elf:
      return "엘프"
    case .omg:
      return "오미세고"
    case .knc:
      return "카이버 네트워크"
    case .glm:
      return "골렘"
    case .zil:
      return "질리카"
    case .waxp:
      return "왁스"
    case .powr:
      return "파워렛저"
    case .lrc:
      return "루프링"
    case .steem:
      return "스팀"
    case .strax:
      return "스트라티스"
    case .zrx:
      return "제로엑스"
    case .rep:
      return "어거"
    case .xem:
      return "넴"
    case .snt:
      return "스테이터스네트워크토큰"
    case .ada:
      return "에이다"
    case .ctxc:
      return "코르텍스"
    case .bat:
      return "베이직어텐션토큰"
    case .wtc:
      return "월튼체인"
    case .theta:
      return "쎄타토큰"
    case .loom:
      return "룸네트워크"
    case .waves:
      return "웨이브"
    case .dataTRUE:
      return "트루체인"
    case .link:
      return "체인링크"
    case .enj:
      return "엔진코인"
    case .vet:
      return "비체인"
    case .mtl:
      return "메탈"
    case .iost:
      return "이오스트"
    case .tmtg:
      return "더마이다스터치골드"
    case .qkc:
      return "쿼크체인"
    case .atolo:
      return "라이즌"
    case .amo:
      return "아모코인"
    case .bsv:
      return "비트코인에스브이"
    case .orbs:
      return "오브스"
    case .tfuel:
      return "쎄타퓨엘"
    case .valor:
      return "밸러토큰"
    case .con:
      return "코넌"
    case .ankr:
      return "앵커"
    case .mix:
      return "믹스마블"
    case .cro:
      return "크립토닷컴체인"
    case .fx:
      return "펑션엑스"
    case .chr:
      return "크로미아"
    case .mbl:
      return "무비블록"
    case .mxc:
      return "머신익스체인지코인"
    case .fct:
      return "피르마체인"
    case .trv:
      return "트러스트버스"
    case .dad:
      return "다드"
    case .wom:
      return "왐토큰"
    case .soc:
      return "소다코인"
    case .boa:
      return "보아"
    case .fleta:
      return "플레타"
    case .sxp:
      return "스와이프"
    case .cos:
      return "콘텐토스"
    case .apix:
      return "아픽스"
    case .el:
      return "엘리시아"
    case .basic:
      return "베이직"
    case .hive:
      return "하이브"
    case .xpr:
      return "프로톤"
    case .vra:
      return "베라시티"
    case .fit:
      return "300피트 네트워크"
    case .egg:
      return "네스트리"
    case .bora:
      return "보라"
    case .arpa:
      return "알파체인"
    case .ctc:
      return "크레딧코인"
    case .apm:
      return "에이피엠 코인"
    case .ckb:
      return "너보스"
    case .aergo:
      return "아르고"
    case .anw:
      return "앵커뉴럴월드"
    case .cennz:
      return "센트럴리티"
    case .evz:
      return "이브이지"
    case .cyclub:
      return "싸이클럽"
    case .srm:
      return "세럼"
    case .qtcon:
      return "퀴즈톡"
    case .uni:
      return "유니스왑"
    case .yfi:
      return "연파이낸스"
    case .uma:
      return "우마"
    case .aave:
      return "에이브"
    case .comp:
      return "컴파운드"
    case .ren:
      return "렌"
    case .bal:
      return "밸런서"
    case .rsr:
      return "리저브라이트"
    case .nmr:
      return "뉴메레르"
    case .rlc:
      return "아이젝"
    case .uos:
      return "울트라"
    case .sand:
      return "샌드박스"
    case .gom2:
      return "고머니2"
    case .ringx:
      return "링엑스"
    case .bel:
      return "벨라프로토콜"
    case .obsr:
      return "옵저버"
    case .orc:
      return "오르빗 체인"
    case .pola:
      return "폴라리스 쉐어"
    case .awo:
      return "에이아이워크"
    case .adp:
      return "어댑터 토큰"
    case .dvi:
      return "디비전"
    case .ghx:
      return "게이머코인"
    case .mir:
      return "미러 프로토콜"
    case .mvc:
      return "마일벌스"
    case .bly:
      return "블로서리"
    case .wozx:
      return "이포스"
    case .anv:
      return "애니버스"
    case .grt:
      return "더그래프"
    case .mm:
      return "밀리미터토큰"
    case .biot:
      return "바이오패스포트"
    case .xno:
      return "제노토큰"
    case .snx:
      return "신세틱스"
    case .sofi:
      return "라이파이낸스"
    case .cola:
      return "콜라토큰"
    case .nu:
      return "누사이퍼"
    case .oxt:
      return "오키드"
    case .lina:
      return "리니어파이낸스"
    case .map:
      return "맵프로토콜"
    case .aqt:
      return "알파쿼크"
    case .wiken:
      return "위드"
    case .ctsi:
      return "카르테시"
    case .mana:
      return "디센트럴랜드"
    case .lpt:
      return "라이브피어"
    case .mkr:
      return "메이커"
    case .sushi:
      return "스시스왑"
    case .asm:
      return "어셈블프로토콜"
    case .pundix:
      return "펀디엑스"
    case .celr:
      return "셀러네트워크"
    case .lf:
      return "링크플로우"
    case .arw:
      return "아로와나토큰"
    case .msb:
      return "미스블록"
    case .rly:
      return "랠리"
    case .ocean:
      return "오션프로토콜"
    case .bfc:
      return "바이프로스트"
    case .alice:
      return "마이네이버앨리스"
    case .coti:
      return "코티"
    case .cake:
      return "팬케이크스왑"
    case .bnt:
      return "뱅코르"
    case .xvs:
      return "비너스"
    case .chz:
      return "칠리즈"
    case .axs:
      return "엑시인피니티"
    case .dao:
      return "다오메이커"
    case .dai:
      return "다이"
    case .matic:
      return "폴리곤"
    case .woo:
      return "우네트워크"
    case .bake:
      return "베이커리토큰"
    case .velo:
      return "벨로프로토콜"
    case .bcd:
      return "비트코인 다이아몬드"
    case .xlm:
      return "스텔라루멘"
    case .gxc:
      return "지엑스체인"
    case .vsys:
      return "브이시스템즈"
    case .ipx:
      return "타키온프로토콜"
    case .wicc:
      return "웨이키체인"
    case .ont:
      return "온톨로지"
    case .luna:
      return "루나"
    case .aion:
      return "아이온"
    case .meta:
      return "메타디움"
    case .klay:
      return "클레이튼"
    case .ong:
      return "온톨로지가스"
    case .algo:
      return "알고랜드"
    case .jst:
      return "저스트"
    case .xtz:
      return "테조스"
    case .mlk:
      return "밀크"
    case .wemix:
      return "위믹스"
    case .dot:
      return "폴카닷"
    case .atom:
      return "코스모스"
    case .ssx:
      return "썸씽"
    case .temco:
      return "템코"
    case .hibs:
      return "힙스"
    case .burger:
      return "버거스왑"
    case .doge:
      return "도지코인"
    case .ksm:
      return "쿠사마"
    case .ctk:
      return "써틱"
    case .xym:
      return "심볼"
    case .bnb:
      return "바이낸스코인"
    case .nft:
      return "에이피이엔에프티"
    case .sun:
      return "썬"
    case .xec:
      return "이캐시"
    case .pci:
      return "페이코인"
    case .sol:
      return "솔라나"
    case .med:
      return "메디블록"
    case .inch1:
      return "1인치"
    case .boba:
      return "보바토큰"
    case .gala:
      return "갈라"
    case .btt:
      return "비트토렌트"
    default:
      return "신규 코인"
    }
  }

  static var orderCurrencyDictionaryByTicker: [OrderCurrency : String] {
    var orderCurrencyDictionary: [OrderCurrency : String] = [:]

    self.allCases.forEach {
      orderCurrencyDictionary[$0] = $0.rawValue
    }
    return orderCurrencyDictionary
  }
  
  static func search(with name: String) -> OrderCurrency {
    for orderCurrency in OrderCurrency.allCases {
      if orderCurrency.rawValue == name {
        return orderCurrency
      }
    }
    return .all
  }
  
  static func filteredCurrencies(with letter: String) -> [OrderCurrency : String] {
    if letter.isEmpty {
      return self.orderCurrencyDictionaryByTicker
    }

    var currencies: [OrderCurrency : String] = [:]

    let letterSeparator = LetterSeparator()
    let separatedLetter = letterSeparator.seperatedLetter(from: letter)

    OrderCurrency.allCases.forEach {
      if letterSeparator.seperatedOrderCurrencyLetter(from: $0).contains(separatedLetter) {
        currencies[$0] = $0.rawValue
      }
    }
    return currencies
  }
}
