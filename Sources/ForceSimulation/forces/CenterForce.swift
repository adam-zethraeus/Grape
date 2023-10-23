//
//  CenterForce.swift
//
//
//  Created by li3zhen1 on 10/16/23.
//
import NDTree

/// A force that drives nodes towards the center.
/// Center force is relatively fast, the complexity is $O(n)$,
/// where `n` is the number of nodes.
/// See [Collide Force - D3](https://d3js.org/d3-force/collide).
final public class CenterForce<NodeID, V>: ForceLike
where NodeID: Hashable, V: VectorLike, V.Scalar: SimulatableFloatingPoint {



    public var center: V
    public var strength: V.Scalar
    weak var simulation: Simulation<NodeID, V>?

    internal init(center: V, strength: V.Scalar) {
        self.center = center
        self.strength = strength
    }

    public func apply() {
        guard let sim = self.simulation else { return }
        let alpha = sim.alpha

        var meanPosition = V.zero
        for n in sim.nodePositions {
            meanPosition += n  //.position
        }
        let delta = meanPosition * (self.strength / V.Scalar(sim.nodePositions.count))

        for i in sim.nodePositions.indices {
            sim.nodePositions[i] -= delta
        }
    }

}

extension Simulation {

    /// Create a center force that drives nodes towards the center.
    /// Center force is relatively fast, the complexity is `O(n)`,
    /// where `n` is the number of nodes.
    /// See [Collide Force - D3](https://d3js.org/d3-force/collide).
    /// - Parameters:
    ///  - center: The center of the force.
    ///  - strength: The strength of the force.
    @discardableResult
    public func createCenterForce(center: V, strength: V.Scalar = 0.1) -> CenterForce<NodeID, V> {
        let f = CenterForce<NodeID, V>(center: center, strength: strength)
        f.simulation = self
        self.forces.append(f)
        return f
    }

}
