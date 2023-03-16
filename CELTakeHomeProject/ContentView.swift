//
//  ContentView.swift
//  CELTakeHomeProject
//
//  Created by Dan Payne on 3/15/23.
//

import SwiftUI


class Change: ObservableObject {
  @Published var hundreds: Int = 10
  @Published var fifties: Int = 1
  @Published var twenties: Int = 4
  @Published var tens: Int = 1
  @Published var fives: Int = 1
  @Published var twos: Int = 0
  @Published var ones: Int = 4
  @Published var quarters: Int = 3
  @Published var dimes: Int = 2
  @Published var nickels: Int = 1
  @Published var pennies: Int = 4
}






struct ContentView: View {
  
  let changeURL = "https://frosty-glade-1979.fly.dev/"
  @FocusState private var focusedField: Field?
  @State private var amountD:Int = 198
  @State private var amountC:Int = 15
  @ObservedObject var changeData = Change()
  
  private let numberFormatter: NumberFormatter
  
  init() {
    numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
  }
  
  enum Field: Hashable {
    case myField
  }
  
  
  
  var body: some View {
    ZStack {
      Color(.gray)
        .ignoresSafeArea()
      VStack {
        VStack {
          
          
          HStack {
            ZStack {
              Image(changeData.hundreds == 0 ? "" : "hundreds1")
                .padding(.leading)
              VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text(changeData.hundreds == 0 ? "" : "x: \(changeData.hundreds)")
                  .font(.title)
                  .bold()
                Spacer()
              }
              
              
            }
            Image("fifties\(changeData.fifties)")
              .padding()
            Image("twentie\(changeData.twenties)")
              .padding(.trailing)
          }
          
          
          HStack {
            Image("tens\(changeData.tens)")
              .padding(.leading)
            Image("fives\(changeData.fives)")
              .padding()
            Image("one\(changeData.ones)")
              .padding(.trailing)
            
            
          }
          
          
          HStack {
            Image("quarters\(changeData.quarters)")
              .padding(.leading)
            Image("dimes\(changeData.dimes)")
              .padding()
            Image("nickels\(changeData.nickels)")
              .padding()
            Image("pennies\(changeData.pennies)")
              .padding(.trailing)
            
          }
          .padding()
          
          // end inner VStack Here
        }
        .padding()
        
        Spacer()
        
        HStack {
          
          Text("\(amountD).\(amountC)")
            .font(.title)
          
          
        VStack {
          
          
          Stepper("Dollars:", onIncrement: {
            amountD += 1
          }, onDecrement: {
            amountD -= 1
          })
          .frame(width: 160)
          
          
          Stepper("Cents:", onIncrement: {
            amountD += 1
          }, onDecrement: {
            amountD -= 1
          })
          .frame(width: 160)
          
          
          //          TextField("amount", value: $amount, formatter: numberFormatter)
          //            .focused($focusedField, equals: .myField)
          //            .keyboardType(.decimalPad)
          //            .font(.title)
          //            .bold()
          //            .multilineTextAlignment(.center)
          
        }.padding()
        
        
      }
        
        Button(action: doStuff) {
          Text("Change!")
          
            .frame(width: 150, height: 60)
            .background(.blue)
            .foregroundColor(.white)
            .bold()
            .font(.title2)
            .clipShape(Capsule())
          
        }
      }
      .padding()
      
    }
  }
  
  
  func fetchQuote(amount: Float) {
    let urlString = "\(changeURL)\(amount)"
    print("urlString: ", urlString)
    performRequest(urlString: urlString)
  }
  
  func performRequest(urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          print(error!)
          return
        }
        
        if let safeData = data {
          self.parseJSON(changeData: safeData)
        }
        
      }
      task.resume()
    }
  }
  
  func parseJSON(changeData: Data) {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(ChangeData.self, from: changeData)
      
      DispatchQueue.main.async {
        self.changeData.hundreds = decodedData.hundreds ?? 0
        self.changeData.fifties = decodedData.fifties ?? 0
        self.changeData.twenties = decodedData.twenties ?? 0
        self.changeData.tens = decodedData.tens ?? 0
        self.changeData.fives = decodedData.fives ?? 0
        self.changeData.ones = decodedData.ones ?? 0
        self.changeData.quarters = decodedData.quarters ?? 0
        self.changeData.dimes = decodedData.dimes ?? 0
        self.changeData.nickels = decodedData.nickels ?? 0
        self.changeData.pennies = decodedData.pennies ?? 0
        
        
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func doStuff() {
    
    DispatchQueue.global(qos: .userInitiated).async {
      var amount = "\(amountD).\(amountC)"
      var amountFloat = Float(amount)
      fetchQuote(amount: amountFloat!)
    }
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
