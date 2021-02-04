//
//  Model types.swift
//
//  Created for Miner by Michael Simone
//

import Foundation


// https://benscheirman.com/2017/06/swift-json/


struct UnderlyingValue {
	let hashpower: String
	let electricityRate: String
	let online_miner_count: String
}


extension UnderlyingValue: Decodable {
	enum CodingKeys: String, CodingKey {
		case online_miner_count
		case hashpower
		case electricityRate
	}
}



//"meta":{"errCode":0,"errMessage":""
	
struct Meta : Codable {
	let errCode:Int
	let errMessage:String
	
}


// {"meta":{"errCode":0,"errMessage":""},"data":{"value":"430992.00","percentage":0,"low":false,"show":false}}

struct HashRate_data : Codable {
	let value:Double
	let percentage:Int
	let low:Bool
	let show:Bool
}

struct HashRate : Codable {
	let meta:Meta
	let data:HashRate_data
}


/*
struct Pair<A, B> {
	var one: A
	var two: B
	init(_ one: A, _ two: B) {
		self.one = one
		self.two = two
	}
}

extension Pair: Encodable where A: Encodable, B: Encodable { }
extension Pair: Decodable where A: Decodable, B: Decodable { }
extension Pair: Equatable where A: Equatable, B: Equatable { }
extension Pair: Hashable where A: Hashable, B: Hashable { }
*/



enum Datum: Codable {
	//case double(Double)
	case double(NSNumber)
	//case int(Int64)
	case int(NSNumber)

	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		// NB we try to decode as Int64 *BEFORE* trying as Double !!!
		// b/c if we try Double first then all values will wind up being turned into Double.
		
		if let x = try? container.decode(Int64.self) {
			//self = .int(x)
			self = .int(NSNumber(value:x))
			return
		}

		if let x = try? container.decode(Double.self) {
			//self = .double(x)
			self = .double(NSNumber(value:x))
			return
		}
		

		throw DecodingError.typeMismatch(Datum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
	}

	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		switch self {
		case .double(let x):
			//try container.encode(x)
			try container.encode(x.doubleValue)

		case .int(let x):
			//try container.encode(x)
			try container.encode(x.int64Value)
		}
	}
}


struct HashrateVsElectricity_data : Codable {
	let hashrate:[[Int64]]   // date, value
	let electricity:[[Datum]]  // date, value
	let minDate:Int64
}


struct HashrateVsElectricity : Codable {
	let meta:Meta
	let data:HashrateVsElectricity_data
}



/*
struct HashRate {
	let tags: [String]
}

extension HashRate: Decodable {
	enum CodingKeys: String, CodingKey {
		case tags
	}
}
*/


struct ElectricityUsed_data : Codable {
	let value:Double
	let percentage:Int
	let low:Bool
	let show:Bool
}

struct ElectricityUsed : Codable {
	let meta:Meta
	let data:HashRate_data
}

/*
struct Electricity {
    let tags: [String]
}

extension Electricity: Decodable {
    enum CodingKeys: String, CodingKey {
        case tags
    }
}
*/


struct Invoice {
    let id: String;
    let electricity_used: String;
    let id_user: String;
    let username: String;
    let month: String;
    let month_name: String;
    let year: String;
    let due_date: Date;
    let id_status: String;
    let status: String;
    let amount_due: String;
    let client_report_paid: Bool;
    let sent: Bool;
    let extra_lines: String;
}

extension Invoice: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case electricity_used
        case id_user
        case username
        case month
        case month_name
        case year
        case due_date
        case id_status
        case status
        case amount_due
        case client_report_paid
        case sent
        case extra_lines
    }
}

struct Miner {
    let id: String;
    let locationId: String;
    let hashrate: String;

    let h1_hashrate: String;
    let h2_hashrate: String;
    let h3_hashrate: String;

    let cur_status: String;
    let cur_ip: String;
    let ip: String;
    let primary_ip: String;
    let secondary_ip: String;
    let url: String;
    let user: String;
    let password: String;
    let alternative_user: String
    let alternative_password: String;
    let statusModifiedTime: Date;
    let statusDescription: String;
    let electricityUse: String;
    let power_meter: String;
    let computed_power_meter: String;
    let userPool: String;
    let client: String;
    let owner: String;
    let real_username: String;
    let worker_name_2: String;
    let worker_name_3: String;
    let pending_worker_name: String;
    let prefix_order: String;
    let prefix_name: String;
    let position_string: String;
    let id_position: String;
    let position_number: String;
    let position_shelf_number: String;
    let position_switch_number: String;
    let position_rack_number: String;
    let position_container_number: String;
    let id_group: String;

    let macAddress: String;

    let timed_out: String;
    let for_recollection: Bool;
    let tries: String;
    let read_only: Bool;
    let wmv11_preferred: Bool;
    let pools: [String];
}

extension Miner: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case locationId
        case hashrate

        case h1_hashrate
        case h2_hashrate
        case h3_hashrate

        case cur_status
        case cur_ip
        case ip
        case primary_ip
        case secondary_ip
        case url
        case user
        case password
        case alternative_user
        case alternative_password
        case statusModifiedTime
        case statusDescription
        case electricityUse
        case power_meter
        case computed_power_meter
        case userPool
        case client
        case owner
        case real_username
        case worker_name_2
        case worker_name_3
        case pending_worker_name
        case prefix_order
        case prefix_name
        case position_string
        case id_position
        case position_number
        case position_shelf_number
        case position_switch_number
        case position_rack_number
        case position_container_number
        case id_group

        case macAddress

        case timed_out
        case for_recollection
        case tries
        case read_only
        case wmv11_preferred
        case pools
    }
}


struct Wrapper<T: Decodable>: Decodable {
	let items: [T]
}
