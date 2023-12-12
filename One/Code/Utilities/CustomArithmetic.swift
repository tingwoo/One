//
//  CustomArithmetic.swift
//  One
//
//  Created by Tingwu on 2023/12/10.
//

import Foundation

extension BDouble {
    var denominatorBInt: BInt {
        var result: BInt = 0
        var base: BInt = 1
        for item in self.denominator {
            result += base * BInt(item)
            base *= BInt(2) ** BInt(64)
        }
        return result
    }

    var numeratorBInt: BInt {
        var result: BInt = 0
        var base: BInt = 1
        for item in self.numerator {
            result += base * BInt(item)
            base *= BInt(2) ** BInt(64)
        }
        return result
    }
}

struct BComplex: CustomStringConvertible {
    var re: BDouble
    var im: BDouble

    init(re: BDouble, im: BDouble) {
        self.re = re
        self.im = im
    }

    init(re: BDouble) {
        self.re = re
        self.im = 0
    }

    init() {
        self.re = BDouble(0)
        self.im = BDouble(0)
    }

    static func ==(lhs: BComplex, rhs: BComplex) -> Bool {
        return (lhs.re == rhs.re) && (lhs.im == rhs.im)
    }

    func conjugate() -> BComplex {
        return BComplex(re: self.re, im: -self.im)
    }

    func isInteger() -> Bool { //
        return self.im == 0 && self.re.denominator == [UInt64(1)]
    }

    func isPositive() -> Bool? { //
        if self.im != 0 { return nil }
        return self.re.isPositive()
    }

    func isReal() -> Bool {
        return self.im == 0
    }

    func isImaginary() -> Bool {
        return self.re == 0
    }

    static func +(left: BComplex, right: BComplex) -> BComplex {
        return BComplex(re: left.re + right.re, im: left.im + right.im)
    }

    static func -(left: BComplex, right: BComplex) -> BComplex {
        return BComplex(re: left.re - right.re, im: left.im - right.im)
    }

    static prefix func -(c: BComplex) -> BComplex {
        return BComplex(re: -c.re, im: -c.im)
    }

    static func *(left: BComplex, right: BComplex) -> BComplex {
        return BComplex(re: left.re * right.re - left.im * right.im,
                        im: left.re * right.im + left.im * right.re)
    }

    static func /(left: BComplex, right: BComplex) throws -> BComplex {
        if right == BComplex() {
            throw CalculationError.divisionByZero
        }

        return left * right.conjugate() *
        BComplex(
            re: 1 / (right.re * right.re + right.im * right.im),
            im: 0
        )
    }

    var description: String {
        if im > 0 {
            return "\(re) + \(im)i"
        }
        if im < 0 {
            return "\(re) - \(-im)i"
        }
        return "\(re)"
    }
}

func BPow(_ base: BComplex, _ exponent: BComplex) throws -> BComplex {
    // special cases
    if base == BComplex() && exponent == BComplex() { throw CalculationError.zeroExponent }
    if base == BComplex(re: 1, im: 0) { return base }
    if exponent == BComplex() { return BComplex(re: 1, im: 0) }
    if exponent == BComplex(re: 1, im: 0) { return base }

    if base.isReal() && exponent.isReal() {
        if exponent.isPositive() == false {
            return try BPow(BComplex(re: 1) / base, -exponent)
        }

        if exponent.isInteger() {
            var exponentInt: BInt = BInt(exponent.re.description)!
            var part: BComplex = base
            var result: BComplex = BComplex(re: 1, im: 0)
            while exponentInt != 0 {
                if exponentInt % 2 == 1 {
                    result = result * part
                }
                exponentInt /= 2
                part = part * part
            }
            return result
        } else {
            if base.re < 0 {
                throw CalculationError.negativeExponent
            }

            let de = exponent.re.denominatorBInt
            let nu = exponent.re.numeratorBInt

            let exponentInt: BInt = nu / de
            let exponentDouble: Double = Double((exponent.re - exponentInt).decimalExpansion(precisionAfterDecimalPoint: 20))!

            var result = try BPow(base, BComplex(re: BDouble(exponentInt)))

            if base.re > 1000 {
                result = result * BComplex(re: BDouble(pow(1000, exponentDouble)))
                result = result * (try BPow(base / BComplex(re: 1000), BComplex(re: exponent.re - exponentInt)))

            } else if base.re < 0.001 {
                result = result * BComplex(re: BDouble(pow(0.001, exponentDouble)))
                result = result * (try BPow(base * BComplex(re: 1000), BComplex(re: exponent.re - exponentInt)))

            } else {
                let baseDouble: Double = Double(base.re.decimalExpansion(precisionAfterDecimalPoint: 20))!
                result = result * BComplex(re: BDouble(pow(baseDouble, exponentDouble)))
            }

            return result
        }

    }

    throw CalculationError.nonRealExponent
}
