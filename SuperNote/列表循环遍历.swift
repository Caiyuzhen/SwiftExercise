import Foundation
import SwiftUI


struct Dog {
    var name: String
    var age: Int
    var id: String { name }
}


func main() {
    let dogs = [
        Dog(name: "饭团", age: 2),
        Dog(name: "嘟嘟", age: 3)
    ]
    
    
    
    List {
       Text("DogList")
            .bold().foregroundColor(.accentColor)
        
        VStack {
            ForEach(dogs, id: \.name) { dog in
                Text("\(dog.name) \(dog.age) 岁")
            }
        }
    }
    
    
//    List {
//        Section("组A") {
//            ForEach(pomernian, content: buildDogNameView)
//                .listRowSeparator(.red)
//                .listSectionSeparator(.visible, deges: .bottom)
//                .listSectionSeparator(.purple, edges: .all)
//        }
//        Section("组B") {
//            ForEach(pomernian, id: \.self) {
//                buildDogNameView(dog: husky[index])
//                    .listRowSPearator(.hidden)
//                    .listRowBackground(Color.teal.opacity(index % 2 == 0 ? 0.2 : 0.1))
//            }
//        }
//    }
         
}

//main()

    


