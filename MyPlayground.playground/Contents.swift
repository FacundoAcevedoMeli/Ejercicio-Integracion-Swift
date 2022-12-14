import Foundation
import UIKit


struct Parking {
    
    
    private (set) var vehicles: Set<Vehicle> = []
    
    // Register
    
    private var parkingRegister : (vehicles : Int,earnings : Int) = (0,0)
    
    // Constants
    
    private let minimumMinutes: Int = 120
    private let rateMinutes: Double = 15.0
    private let discount: Double = 15
    private let maxVehicles : Int = 20

    mutating func checkInVehicle(_ vehicle : Vehicle , onFinish: (Bool) -> Void){
        
        guard vehicles.count < maxVehicles else {
            onFinish(false)
            return
        }
                
        onFinish(vehicles.insert(vehicle).inserted)
        
    }
    
    mutating func checkOutVehicle( plate : String , onSuccess : (Int) -> Void , onError : () -> Void ){
        
        let vehicleToCheckOut =  vehicles.first { vehicle in
            vehicle.plate == plate
        }
        
        guard let vehicleToCheckOut = vehicleToCheckOut else {
            onError()
            return
        }

        let fee = calculateFee(type: vehicleToCheckOut.type, parkedTime: vehicleToCheckOut.parkedTime , hasDiscountCard: vehicleToCheckOut.hasDiscountCard )
        
        onSuccess(fee)
        
        parkingRegister.vehicles += 1
        parkingRegister.earnings += fee

        vehicles.remove(vehicleToCheckOut)
        
    }
    
    
    mutating func calculateFee(type : VehicleType , parkedTime : Int , hasDiscountCard : Bool ) -> Int {
        
        var fee = type.rate
        
        if parkedTime > minimumMinutes {
            let total = (Double(parkedTime - minimumMinutes) / rateMinutes ).rounded(.up)
            fee += Int(total) * 5
        }
                        
        return  hasDiscountCard ? applyDisscount(fee: fee) : fee
    }
    
    func showStatistics(){
        print("\(self.parkingRegister.vehicles) vehicles have checked out and have earnings of $\(self.parkingRegister.earnings)")
    }
    
    private func applyDisscount(fee : Int) -> Int {
        return Int(Double(fee) * ((100 - discount) / 100) )
    }

    func listVehicles() {
        self.vehicles.enumerated().forEach { index , vehicle in
            print("\(index) - Vehicle plate is \(vehicle.plate)")
        }
    }
}

struct Vehicle: Parkable , Hashable {
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
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(plate)
    }
    
}

enum VehicleType {
  case car
  case miniBus
  case bus
  case motorcycle
  
  var rate: Int {
    switch self {
    case .car: return 20
    case .motorcycle: return 15
    case .miniBus: return 25
    case .bus: return 30
    }
  }
}

protocol Parkable {
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

let vehicle16 = Vehicle(plate: "321SGB", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle17 = Vehicle(plate: "999GGG", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle18 = Vehicle(plate: "109HGH", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle19 = Vehicle(plate: "111LOL", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle20 = Vehicle(plate: "HXD213", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicles = [ vehicle1 , vehicle2 , vehicle3 , vehicle4 , vehicle5 , vehicle6 , vehicle7 , vehicle8 , vehicle9 , vehicle10 , vehicle11 , vehicle12 , vehicle13 , vehicle14 , vehicle15 , vehicle16 , vehicle17 , vehicle18 , vehicle19 , vehicle20 ]

// Insert all vehicles

vehicles.forEach { vehicle in
    alkeParking.checkInVehicle(vehicle ) { canInsert in
        print( canInsert ? "Welcome to AlkeParking!" : "Sorry, the check-in failed")
    }
}

print("Insert vehicle 1 again")

alkeParking.checkInVehicle(vehicle1, onFinish: { canInsert in
    print( canInsert ? "Welcome to AlkeParking!" : "Sorry, the check-in failed")
})

print("Checkout vehicle 1")

alkeParking.checkOutVehicle(plate: vehicle1.plate) {fee in
    print("Your fee is \(fee). Come back soon")
} onError: {
    print("Sorry, the check-out failed")
}


// List vehicle  plates

alkeParking.listVehicles()

// List earnings and vehicles

alkeParking.showStatistics()
