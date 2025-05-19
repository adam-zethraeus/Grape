/// A class that holds the state of the simulation, which
/// includes the positions, velocities of the nodes.
public struct Kinetics<Vector>
where Vector: SimulatableVector & L2NormCalculatable {

    /// The position of points stored in simulation.
    ///
    /// Ordered as the nodeIds you passed in when initializing simulation.
    /// They are always updated.
    /// Exposed publicly so examples & clients can read out the latest positions.
    public var position: UnsafeArray<Vector>

    // public var positionBufferPointer: UnsafeMutablePointer<Vector>

    /// The velocities of points stored in simulation.
    ///
    /// Ordered as the nodeIds you passed in when initializing simulation.
    /// They are always updated.
    @usableFromInline
    package var velocity: UnsafeArray<Vector>

    // public var velocityBufferPointer: UnsafeMutablePointer<Vector>

    /// The fixed positions of points stored in simulation.
    ///
    /// Ordered as the nodeIds you passed in when initializing simulation.
    /// They are always updated.
    @usableFromInline
    package var fixation: UnsafeArray<Vector?>


    public var validCount: Int
    public var alpha: Vector.Scalar
    public let alphaMin: Vector.Scalar
    public let alphaDecay: Vector.Scalar
    public let alphaTarget: Vector.Scalar
    public let velocityDecay: Vector.Scalar

    @usableFromInline
    var randomGenerator: Vector.Scalar.Generator



    @usableFromInline
    package let links: [EdgeID<Int>]

    // public var validRanges: [Range<Int>]
    // public var validRanges: Range<Int>

    @inlinable
    package var range: Range<Int> {
        return 0..<validCount
    }

    @inlinable
    init(
        links: [EdgeID<Int>],
        initialAlpha: Vector.Scalar,
        alphaMin: Vector.Scalar,
        alphaDecay: Vector.Scalar,
        alphaTarget: Vector.Scalar,
        velocityDecay: Vector.Scalar,
        position: [Vector],
        velocity: [Vector],
        fixation: [Vector?]
    ) {
        self.links = links
        // self.initializedAlpha = initialAlpha
        self.alpha = initialAlpha
        self.alphaMin = alphaMin
        self.alphaDecay = alphaDecay
        self.alphaTarget = alphaTarget
        self.velocityDecay = velocityDecay

        let count = position.count
        self.validCount = count

        self.position = .createBuffer(moving: position, fillingWithIfFailed: .zero)
        self.velocity = .createBuffer(moving: velocity, fillingWithIfFailed: .zero)
        self.fixation = .createBuffer(moving: fixation, fillingWithIfFailed: nil)
        self.randomGenerator = .init()
    }

    @inlinable
    package static var empty: Kinetics<Vector> {
        Kinetics(
            links: [],
            initialAlpha: 0,
            alphaMin: 0,
            alphaDecay: 0,
            alphaTarget: 0,
            velocityDecay: 0,
            position: [],
            velocity: [],
            fixation: []
        )
    }

}

extension Kinetics {
    @inlinable
    @inline(__always)
    func updatePositions() {
        for i in range {
            if let fix = fixation[i] {
                position[i] = fix
            } else {
                velocity[i] *= velocityDecay
                position[i] += velocity[i]
            }
        }
    }

    @inlinable
    @inline(__always)
    mutating func updateAlpha() {
        alpha += alphaTarget - alpha * alphaDecay
    }

}

public typealias Kinetics2D = Kinetics<SIMD2<Double>>
public typealias Kinetics3D = Kinetics<SIMD3<Float>>
