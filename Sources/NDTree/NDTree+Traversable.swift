//
//  File.swift
//  
//
//  Created by li3zhen1 on 10/16/23.
//

public protocol Traversable {
    
    @inlinable func visit(
        shouldVisitChildren: (Self) -> Bool
    )
    
    @inlinable func visitPostOrdered(
        _ action: (Self) -> ()
    )
    
}


extension NDTree: Traversable {
    
    @inlinable public func visit(shouldVisitChildren: (NDTree<V,D>) -> Bool) {
        if shouldVisitChildren(self), let children {
            // this is an internal node
            for t in children { 
                t.visit(shouldVisitChildren: shouldVisitChildren)
            }
        }
    }
    

    @inlinable public func visitPostOrdered(
        _ action: (NDTree<V, D>) -> ()
    ) {
        if let children {
            for c in children {
                c.visitPostOrdered(action)
            }
        }
        action(self)
    }
}