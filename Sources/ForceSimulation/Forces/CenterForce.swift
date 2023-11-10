extension Kinetics {
    /// A force that drives nodes towards the center.
    ///
    /// Center force is relatively fast, the complexity is `O(n)`,
    /// where `n` is the number of nodes.
    /// See [Collide Force - D3](https://d3js.org/d3-force/collide).
    public struct CenterForce: ForceProtocol {

        @usableFromInline var kinetics: Kinetics! = nil

        @inlinable
        public func apply() {
            assert(self.kinetics != nil, "Kinetics not bound to force")
            var meanPosition = Vector.zero
            for i in kinetics.range {
                meanPosition += kinetics.position[i]  //.position
            }
            let delta = meanPosition * (self.strength / Vector.Scalar(kinetics.validCount))

            for i in 0..<kinetics.validCount {
                kinetics.position[i] -= delta
            }
        }
        @inlinable
        public mutating func bindKinetics(_ kinetics: Kinetics) {
            self.kinetics = kinetics
        }

        public var center: Vector
        public var strength: Vector.Scalar

        @inlinable
        public
            init(center: Vector, strength: Vector.Scalar)
        {
            self.center = center
            self.strength = strength
        }

    }

}