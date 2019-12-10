//
//  Decimal.swift
//  Money
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Daniel Thorpe
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import Foundation
//import ValueCoding

/**
 # Decimal
 A value type which implements `DecimalNumberType` using `NSDecimalNumber` internally.
 
 It is generic over the decimal number behavior type, which defines the rounding
 and scale rules for base 10 decimal arithmetic.
 */
public struct _Decimal<Behavior: DecimalNumberBehaviorType>: DecimalNumberType, Comparable {
    public typealias Magnitude = Double
    
    public typealias DecimalNumberBehavior = Behavior
    
    public var magnitude: Magnitude
    
    public static func -=(lhs: inout _Decimal<Behavior>, rhs: _Decimal<Behavior>) {
        lhs = lhs.subtract(rhs)
    }
    
    public static func +=(lhs: inout _Decimal<Behavior>, rhs: _Decimal<Behavior>) {
        lhs = lhs.add(rhs)
    }
    
    public static func *=(lhs: inout _Decimal<Behavior>, rhs: _Decimal<Behavior>) {
        lhs = lhs.multiply(by: rhs)
    }
    
    public static func *(lhs: _Decimal<Behavior>, rhs: _Decimal<Behavior>) -> _Decimal<Behavior> {
        return lhs.multiply(by: rhs)
    }
    
    public static func +=(lhs: inout _Decimal<Behavior>, rhs: _Decimal<Behavior>) -> _Decimal<Behavior> {
        return lhs.add(rhs)
    }
    
    public static func -=(lhs: inout _Decimal<Behavior>, rhs: _Decimal<Behavior>) -> _Decimal<Behavior> {
        return lhs.subtract(rhs)
    }
    
    public static prefix func +(lhs: _Decimal<Behavior>) -> _Decimal<Behavior> {
        return lhs
    }
    
    public static prefix func -(lhs: _Decimal<Behavior>) -> _Decimal<Behavior> {
        return lhs.multiply(by: -1)
    }
    
    public static func ==(lhs: _Decimal<Behavior>, rhs: _Decimal<Behavior>) -> Bool {
        return lhs.storage == rhs.storage
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func <=(lhs: _Decimal<Behavior>, rhs: _Decimal<Behavior>) -> Bool {
        return lhs.storage <= lhs.storage
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func >=(lhs: _Decimal<Behavior>, rhs: _Decimal<Behavior>) -> Bool {
        return lhs.storage >= lhs.storage
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func >(lhs: _Decimal<Behavior>, rhs: _Decimal<Behavior>) -> Bool {
        return lhs.storage > lhs.storage
    }
    
    
    /// Access the underlying decimal storage.
    /// - returns: the `NSDecimalNumber`
    public let storage: NSDecimalNumber
    
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.storage = NSDecimalNumber(integerLiteral: Int(source))
        self.magnitude =  Double(source.magnitude as? String ?? "0.0")!//NSDecimalNumber(string: source.magnitude as? String)
    }
    
    /**
     Initialize a new value using the underlying decimal storage.
     
     - parameter storage: a `NSDecimalNumber` defaults to zero.
     */
    public init(storage: NSDecimalNumber = NSDecimalNumber.zero) {
        self.storage = storage
        self.magnitude = storage.doubleValue
    }
}

// MARK: - Equality

public func ==<B>(lhs: _Decimal<B>, rhs: _Decimal<B>) -> Bool {
    return lhs.storage == rhs.storage
}

// MARK: - Comparable

public func <<B>(lhs: _Decimal<B>, rhs: _Decimal<B>) -> Bool {
    return lhs.storage < rhs.storage
}

/// `Decimal` with plain decimal number behavior
public typealias PlainDecimal = _Decimal<DecimalNumberBehavior.Plain>

/// `BankersDecimal` with banking decimal number behavior
public typealias BankersDecimal = _Decimal<DecimalNumberBehavior.Bankers>

// MARK: - Value Coding

extension _Decimal: ValueCoding {
    public typealias Coder = _DecimalCoder<Behavior>
}

/**
 Coding class to support `_Decimal` `ValueCoding` conformance.
 */
public final class _DecimalCoder<Behavior: DecimalNumberBehaviorType>: NSObject, NSCoding, CodedValue,
CodingProtocol{
    
    public let value: _Decimal<Behavior>
    
    public required init(_ v: _Decimal<Behavior>) {
        value = v
    }
    
    public init?(coder aDecoder: NSCoder) {
        let storage = aDecoder.decodeObject(forKey: "storage") as! NSDecimalNumber
        value = _Decimal<Behavior>(storage: storage)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value.storage, forKey: "storage")
    }
}
