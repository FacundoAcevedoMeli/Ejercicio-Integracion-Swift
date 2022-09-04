import Foundation

struct Parking {
    
    private var vehicles: Set<Vehicle>
    private let maxVehicles : Int = 5
    private var parkingRegister : (vehicles : Int,earnings : Int) = (0,0)
    
    init(){
        vehicles = []
    }
    
    mutating func checkInVehicle(_ vehicle : Vehicle , onFinish: (Bool) -> Void){
        
        guard vehicles.count < maxVehicles else {
            onFinish(false)
            return
        }
        
        let result = vehicles.insert(vehicle)
        
        if result.inserted {
            onFinish(true)
        } else {
            onFinish(false)
        }
        
    }
    
    mutating func checkOutVehicle( plate : String , onSuccess : (Int) -> Void , onError : () -> Void ){
        
        let vehicleToCheckOut =  vehicles.first { vehicle in
            if vehicle.plate == plate {
                return true
            }
            return false
        }
        
        guard let vehicleToCheckOut = vehicleToCheckOut else {
            onError()
            return
        }

        let fee = calculateFee(type: vehicleToCheckOut.type, parkedTime: vehicleToCheckOut.parkedTime , hasDiscountCard: vehicleToCheckOut.hasDiscountCard )
        
        onSuccess(fee)
        parkingRegister.vehicles += 1

        vehicles.remove(vehicleToCheckOut)
        
    }
    
    
    mutating func calculateFee(type : VehicleType , parkedTime : Int , hasDiscountCard : Bool ) -> Int {
        
        var fee = type.tarifa
        
        if parkedTime > 120 {
            let total = (Double(parkedTime - 120) / 15.0 ).rounded(.up)
            fee += Int(total) * 5
        }
                
        let discount = hasDiscountCard ? 0.85 : 1
        
        parkingRegister.earnings += fee

        return Int( Double(fee) * discount )
    }

}

struct Vehicle: Parkable {
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    var discountCard: String?
    var parkedTime: Int {
    Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
  }
  
  static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
    lhs.plate == rhs.plate
  }
    
}

enum VehicleType {
  case car
  case miniBus
  case bus
  case motorcycle
  
  var tarifa: Int {
    switch self {
    case .car: return 20
    case .motorcycle: return 15
    case .miniBus: return 25
    case .bus: return 30
    }
  }
}

protocol Parkable: Hashable {
    var plate: String { get }
    var type: VehicleType { get }
    var discountCard: String? { get }
    var hasDiscountCard: Bool { get }
    var checkInTime: Date { get }
    var parkedTime: Int { get }
    
}

extension Parkable {
    var hasDiscountCard: Bool { discountCard != nil }
}

extension Parkable {
    
      func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
      }
}

var alert = { insert in
    insert ? print("Welcome to AlkeParking!") : print("Sorry, the check-in failed")
}

var alertCheckout : (Int) -> () = {fee in
    print("Your fee is \(fee). Come back soon")
}

var alkeParking = Parking()

let vehicle1 = Vehicle(plate: "AA111AA", type:
                        VehicleType.car, checkInTime: Date(timeInterval: -60*193 , since: Date() ) , discountCard: nil
)

let vehicle2 = Vehicle(plate: "B222BBB", type:
VehicleType.motorcycle, checkInTime: Date(), discountCard: nil)

let vehicle3 = Vehicle(plate: "CC333CC", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle4 = Vehicle(plate: "DD444DD", type:
VehicleType.bus, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_002")

let vehicle5 = Vehicle(plate: "AA111BB", type:
VehicleType.car, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_003")

let vehicle6 = Vehicle(plate: "B222CCC", type:

VehicleType.motorcycle, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_004")

let vehicle7 = Vehicle(plate: "CC333DD", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle8 = Vehicle(plate: "DD444EE", type:
VehicleType.bus, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_005")

let vehicle9 = Vehicle(plate: "AA111CC", type:
VehicleType.car, checkInTime: Date(), discountCard: nil)

let vehicle10 = Vehicle(plate: "B222DDD", type:
VehicleType.motorcycle, checkInTime: Date(), discountCard: nil)

let vehicle11 = Vehicle(plate: "CC333EE", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle12 = Vehicle(plate: "DD444GG", type:
VehicleType.bus, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_006")

let vehicle13 = Vehicle(plate: "AA111DD", type:
VehicleType.car, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_007")

let vehicle14 = Vehicle(plate: "B222EEE", type:
VehicleType.motorcycle, checkInTime: Date(), discountCard: nil)

let vehicle15 = Vehicle(plate: "CC333FF", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicles = [ vehicle1 , vehicle2 , vehicle3 , vehicle4 , vehicle5 , vehicle6 , vehicle7 , vehicle8 , vehicle9 , vehicle10 , vehicle11 , vehicle12 , vehicle13 , vehicle14 , vehicle15 ]

vehicles.forEach { vehicle in
    alkeParking.checkInVehicle(vehicle , onFinish: alert)
}

alkeParking.checkOutVehicle(plate: vehicle1.plate , onSuccess: alertCheckout , onError: {
    print("error")
})

