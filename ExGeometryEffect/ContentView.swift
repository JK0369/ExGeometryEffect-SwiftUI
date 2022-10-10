//
//  ContentView.swift
//  ExGeometryEffect
//
//  Created by 김종권 on 2022/10/10.
//

import SwiftUI

struct ContentView: View {
  @State var likes = 0.0
  
  var body: some View {
    HStack {
      Text("likes: \(Int(likes))")
        .frame(width: 150, alignment: .leading)
        .padding()
      Button(
        action: { withAnimation(.spring()) { self.likes += 1 } },
        label: {
          HStack {
            Text("like more")
            Image(systemName: "hand.thumbsup")
              .modifier(LikeEffect(offset: likes))
          }
        }
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct LikeEffect: GeometryEffect {
  var offset: Double
  
  var animatableData: Double {
    get { offset }
    set { offset = newValue }
  }
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    /// offset에 1이 들어온 경우: 0.0, 0.1, 0.2, 0.3 ... 1.0
    /// offset에 2가 들어온 경우: 1.0, 1.1, 1.2, 1.3 ... 2.0
    
    /// 0.0 ~ 1.0까지의 값: 0.0, 0.1, ... 0.9, 0.8, 0.9, 1.0
    let reducedValue = offset - floor(offset)
    print(offset, reducedValue)
    /// 움직인 각도
    let value = 1.0-(cos(2*reducedValue*Double.pi)+1)/2
    let angle = CGFloat(Double.pi*value*0.3)
    let translation = CGFloat(20*value)
    let scaleFactor = CGFloat(1+value)
    
    let affineTransform = CGAffineTransform(translationX: size.width*0.5, y: size.height*0.5)
      .rotated(by: CGFloat(angle))
      .translatedBy(x: -size.width*0.5+translation, y: -size.height*0.5-translation)
      .scaledBy(x: scaleFactor, y: scaleFactor)
    
    return ProjectionTransform(affineTransform)
  }
}
