//
//  Positions.swift
//  MoyskladNew
//
//  Created by Kostya on 26/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
import Foundation

public class MSPosition : Metable {
	public let meta : MSMeta
	public let id : MSID
	public var assortment : MSEntity<MSAssortment>
	public var quantity : Double
    public var reserve: Double
    public var shipped: Double
	public var price : Money
	public var discount : Double
	public var vat : Double
    public var gtd : String?
    public var country: MSEntity<MSCountry>?
    public var inTransit: Double
    public var correctionAmount: Double
    public var calculatedQuantity: Double
    public var correctionSum: Double
    // себестоимость
    public var cost: Money
    
    public init(meta : MSMeta,
                id : MSID,
                assortment : MSEntity<MSAssortment>,
                quantity : Double,
                reserve: Double,
                shipped: Double,
                price : Money,
                discount : Double,
                vat : Double,
                gtd : String?,
                country : MSEntity<MSCountry>?,
                inTransit: Double,
                correctionAmount: Double,
                calculatedQuantity: Double,
                correctionSum: Double,
                cost: Money) {
        self.meta = meta
        self.id = id
        self.assortment = assortment
        self.quantity = quantity
        self.reserve = reserve
        self.shipped = shipped
        self.price = price
        self.discount = discount
        self.vat = vat
        self.gtd = gtd
        self.country = country
        self.inTransit = inTransit
        self.correctionAmount = correctionAmount
        self.calculatedQuantity = calculatedQuantity
        self.correctionSum = correctionSum
        self.cost = cost
    }
    
    public func copy() -> MSPosition {
        return MSPosition(meta: meta,
                          id: id,
                          assortment: assortment,
                          quantity: quantity,
                          reserve: reserve,
                          shipped: shipped,
                          price: price,
                          discount: discount,
                          vat: vat,
                          gtd: gtd,
                          country: country,
                          inTransit: inTransit,
                          correctionAmount: correctionAmount,
                          calculatedQuantity: calculatedQuantity,
                          correctionSum: correctionSum,
                          cost: cost)
    }
}
