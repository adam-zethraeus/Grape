extension GrapeEffect {
    @usableFromInline
    internal struct Opacity {
        @usableFromInline
        let value: Double

        @inlinable
        public init(_ value: Double) {
            self.value = value
        }
    }
}

extension GrapeEffect.Opacity: GraphContentModifier {
    @inlinable
    public func _into<NodeID>(
        _ context: inout _GraphRenderingContext<NodeID>
    ) where NodeID: Hashable {
        // context.opacityStack.append(value)
    }

    @inlinable
    public func _exit<NodeID>(
        _ context: inout _GraphRenderingContext<NodeID>
    ) where NodeID: Hashable {
        // context.opacityStack.removeLast()
    }
}
