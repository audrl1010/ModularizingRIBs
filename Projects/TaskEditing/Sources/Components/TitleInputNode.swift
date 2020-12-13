//
//  TitleInputNode.swift
//  TaskEditing
//
//  Created by myunggison on 12/13/20.
//

import AsyncDisplayKit
import BonMot

public class TitleInputNode: ASEditableTextNode {
  
  enum Typo {
    static let typing = StringStyle([
      .font(.systemFont(ofSize: 14)),
      .color(.black)
    ])
    
    static let placeholder = StringStyle([
      .font(.systemFont(ofSize: 14)),
      .color(.gray)
    ])
  }
  
  public override init() {
    super.init()
  }
  
  public override init(textKitComponents: ASTextKitComponents, placeholderTextKitComponents: ASTextKitComponents) {
    super.init(textKitComponents: textKitComponents, placeholderTextKitComponents: placeholderTextKitComponents)
    
    self.attributedPlaceholderText = "Do something...".styled(with: Typo.placeholder)
    self.typingAttributes = Typo.typing.rawStrings
    
    self.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    
    self.autocorrectionType = .no
    
    self.cornerRadius = 5
    self.borderColor = UIColor.lightGray.cgColor
    self.borderWidth = 1
    
    self.style.width = .init(unit: .fraction, value: 1.0)
  }
}
