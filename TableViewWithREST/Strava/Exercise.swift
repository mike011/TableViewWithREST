import Foundation

struct Exercise : Codable {
	let resource_state : Int?
	let athlete : Athlete
	let name : String
	let distance : Double
	let moving_time : Int
	let elapsed_time : Int
	let total_elevation_gain : Double
	let type : String
	let workout_type : Int?
	let id : Int
	let external_id : String?
	let upload_id : Int?
	let start_date : String
	let start_date_local : String?
	let timezone : String?
	let utc_offset : Int?
	let start_latlng : [Double]?
	let end_latlng : [Double]?
	let location_city : String?
	let location_state : String?
	let location_country : String?
	let start_latitude : Double?
	let start_longitude : Double?
	let achievement_count : Int?
	let kudos_count : Int?
	let comment_count : Int?
	let athlete_count : Int?
	let photo_count : Int?
	let map : GeographyMap?
	let trainer : Bool?
	let commute : Bool
	let manual : Bool?
	let isPrivate : Bool?
	let visibility : String?
	let flagged : Bool?
	let gear_id : String
	let from_accepted_tag : Bool?
	let upload_id_str : String?
	let average_speed : Double
	let max_speed : Double
	let average_cadence : Double?
	let average_temp : Int?
	let average_watts : Double?
	let weighted_average_watts : Int?
	let kilojoules : Double?
	let device_watts : Bool?
	let has_heartrate : Bool?
	let heartrate_opt_out : Bool?
	let display_hide_heartrate_option : Bool?
	let max_watts : Int?
	let elev_high : Double?
	let elev_low : Double?
	let pr_count : Int?
	let total_photo_count : Int?
	let has_kudoed : Bool?

	enum CodingKeys: String, CodingKey {
		case resource_state
		case athlete
		case name
		case distance
		case moving_time
		case elapsed_time
		case total_elevation_gain
		case type
		case workout_type
		case id
		case external_id
		case upload_id
		case start_date
		case start_date_local
		case timezone
		case utc_offset = "utc_offset"
		case start_latlng = "start_latlng"
		case end_latlng = "end_latlng"
		case location_city = "location_city"
		case location_state = "location_state"
		case location_country = "location_country"
		case start_latitude = "start_latitude"
		case start_longitude = "start_longitude"
		case achievement_count = "achievement_count"
		case kudos_count = "kudos_count"
		case comment_count = "comment_count"
		case athlete_count = "athlete_count"
		case photo_count = "photo_count"
		case map
		case trainer = "trainer"
		case commute = "commute"
		case manual = "manual"
		case isPrivate = "private"
		case visibility = "visibility"
		case flagged = "flagged"
		case gear_id = "gear_id"
		case from_accepted_tag = "from_accepted_tag"
		case upload_id_str = "upload_id_str"
		case average_speed = "average_speed"
		case max_speed = "max_speed"
		case average_cadence = "average_cadence"
		case average_temp = "average_temp"
		case average_watts = "average_watts"
		case weighted_average_watts = "weighted_average_watts"
		case kilojoules = "kilojoules"
		case device_watts = "device_watts"
		case has_heartrate = "has_heartrate"
		case heartrate_opt_out = "heartrate_opt_out"
		case display_hide_heartrate_option = "display_hide_heartrate_option"
		case max_watts = "max_watts"
		case elev_high = "elev_high"
		case elev_low = "elev_low"
		case pr_count = "pr_count"
		case total_photo_count = "total_photo_count"
		case has_kudoed = "has_kudoed"
	}
}
