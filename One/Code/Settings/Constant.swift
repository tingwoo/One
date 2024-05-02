//
//  Constant.swift
//  One
//
//  Created by Tingwu on 2024/5/2.
//

import Foundation

enum ConstantSymbol: String, CaseIterable {
    // Numbers
    case n0 = "0"
    case n1 = "1"
    case n2 = "2"
    case n3 = "3"
    case n4 = "4"
    case n5 = "5"
    case n6 = "6"
    case n7 = "7"
    case n8 = "8"
    case n9 = "9"

    // Latin
    case a_l = "a"
    case b_l = "b"
    case c_l = "c"
    case d_l = "d"
    case e_l = "e"
    case f_l = "f"
    case g_l = "g"
    case h_l = "h"
    case i_l = "i"
    case j_l = "j"
    case k_l = "k"
    case l_l = "l"
    case m_l = "m"
    case n_l = "n"
    case o_l = "o"
    case p_l = "p"
    case q_l = "q"
    case r_l = "r"
    case s_l = "s"
    case t_l = "t"
    case u_l = "u"
    case v_l = "v"
    case w_l = "w"
    case x_l = "x"
    case y_l = "y"
    case z_l = "z"

    // Latin - Uppercase
    case a_u = "A"
    case b_u = "B"
    case c_u = "C"
    case d_u = "D"
    case e_u = "E"
    case f_u = "F"
    case g_u = "G"
    case h_u = "H"
    case i_u = "I"
    case j_u = "J"
    case k_u = "K"
    case l_u = "L"
    case m_u = "M"
    case n_u = "N"
    case o_u = "O"
    case p_u = "P"
    case q_u = "Q"
    case r_u = "R"
    case s_u = "S"
    case t_u = "T"
    case u_u = "U"
    case v_u = "V"
    case w_u = "W"
    case x_u = "X"
    case y_u = "Y"
    case z_u = "Z"

    // Greek
    case alpha = "α"
    case beta = "β"
    case gamma = "γ"
    case delta = "δ"
    case epsilon = "ε"
    case zeta = "ζ"
    case eta = "η"
    case theta = "θ"
    case iota = "ι"
    case kappa = "κ"
    case lambda = "λ"
    case mu = "μ"
    case nu = "ν"
    case xi = "ξ"
    case omicron = "ο"
    case pi = "π"
    case rho = "ρ"
    case sigma = "σ"
    case tau = "τ"
    case upsilon = "υ"
    case phi = "φ"
    case chi = "χ"
    case psi = "ψ"
    case omega = "ω"

    var isLowerCase: Bool {
        switch self {
        case .a_l, .b_l, .c_l, .d_l, .e_l, .f_l, .g_l, .h_l, .i_l, .j_l, .k_l, .l_l, .m_l, .n_l, .o_l, .p_l, .q_l, .r_l, .s_l, .t_l, .u_l, .v_l, .w_l, .x_l, .y_l, .z_l:
            return true
        default:
            return false
        }
    }

    // Method to check if symbol is uppercase
    var isUpperCase: Bool {
        switch self {
        case .a_u, .b_u, .c_u, .d_u, .e_u, .f_u, .g_u, .h_u, .i_u, .j_u, .k_u, .l_u, .m_u, .n_u, .o_u, .p_u, .q_u, .r_u, .s_u, .t_u, .u_u, .v_u, .w_u, .x_u, .y_u, .z_u:
            return true
        default:
            return false
        }
    }

    // Method to check if symbol is Greek
    var isGreek: Bool {
        switch self {
            case .alpha, .beta, .gamma, .delta, .epsilon, .zeta, .eta, .theta, .iota, .kappa, .lambda, .mu, .nu, .xi, .omicron, .pi, .rho, .sigma, .tau, .upsilon, .phi, .chi, .psi, .omega:
                return true
            default:
                return false
        }
    }

    var isNumber: Bool {
        switch self {
            case .n0, .n1, .n2, .n3, .n4, .n5, .n6, .n7, .n8, .n9:
                return true
            default:
                return false
        }
    }

    var isValidMain: Bool {
        !self.isNumber
    }

    var isValidSub: Bool {
        true
    }
}


struct Constant: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
    var main: ConstantSymbol?
    var sub: ConstantSymbol?

    var coefString: String = ""
    var coefValue: BDouble? {
        BDouble(coefString)
    }

    var expoString: String = ""
    var expoValue: BInt? {
        BInt(expoString)
    }

    var isValidCoef: Bool {
        coefValue != nil && coefString != ""
    }
    
    var isValidExpo: Bool {
        expoValue != nil && expoString != ""
    }

}

extension Constant {
    static let example = Constant(name: "Probability of innovation", main: .p_l, sub: .i_l, coefString: "3.2266", expoString: "-1")
}

extension [Constant] {
    static let example = [
        Constant(name: "Probability of innovation", main: .p_l, sub: .i_l, coefString: "3.2266", expoString: "-1"),
        Constant(name: "Square root of 2", main: .a_u, sub: .phi, coefString: "1.66245", expoString: "5"),
        Constant(name: "Planck's constant", main: .h_l, sub: nil, coefString: "6.62607", expoString: "-34"),
        Constant(name: "Characteristic impedance", main: .z_u, sub: .n0, coefString: "376.73", expoString: "0"),
        Constant(name: "Chen's constant", main: .m_l, sub: .w_u, coefString: "7.366", expoString: "11")]
}
