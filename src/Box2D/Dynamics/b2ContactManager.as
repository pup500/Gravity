/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package Box2D.Dynamics{


import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Dynamics.Contacts.*;
import Box2D.Dynamics.*;
import Box2D.Common.Math.*;
import Box2D.Common.*;

import Box2D.Common.b2internal;
use namespace b2internal;


// Delegate of b2World.
/**
* @private
*/
<<<<<<< HEAD
public class b2ContactManager extends b2PairCallback
{
	public function b2ContactManager() {
		m_world = null;
		m_destroyImmediate = false;
=======
public class b2ContactManager 
{
	public function b2ContactManager() {
		m_world = null;
		m_contactCount = 0;
		m_contactFilter = b2ContactFilter.b2_defaultFilter;
		m_contactListener = b2ContactListener.b2_defaultListener;
		m_contactFactory = new b2ContactFactory(m_allocator);
		m_broadPhase = new b2DynamicTreeBroadPhase();
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
	};

	// This is a callback from the broadphase when two AABB proxies begin
	// to overlap. We create a b2Contact to manage the narrow phase.
<<<<<<< HEAD
	public override function PairAdded(proxyUserData1:*, proxyUserData2:*):*{
		var shape1:b2Shape = proxyUserData1 as b2Shape;
		var shape2:b2Shape = proxyUserData2 as b2Shape;
		
		var body1:b2Body = shape1.m_body;
		var body2:b2Body = shape2.m_body;
		
		if (body1.IsStatic() && body2.IsStatic())
		{
			return m_nullContact;
		}
		
		if (shape1.m_body == shape2.m_body)
		{
			return m_nullContact;
		}
		
		if (body2.IsConnected(body1))
		{
			return m_nullContact;
		}
		
		if (m_world.m_contactFilter != null && m_world.m_contactFilter.ShouldCollide(shape1, shape2) == false)
		{
			return m_nullContact;
		}
		
		// Call the factory.
		var c:b2Contact = b2Contact.Create(shape1, shape2, m_world.m_blockAllocator);
		
		if (c == null)
		{
			return m_nullContact;
		}
		
		// Contact creation may swap shapes.
		shape1 = c.m_shape1;
		shape2 = c.m_shape2;
		body1 = shape1.m_body;
		body2 = shape2.m_body;
=======
	public function AddPair(proxyUserDataA:*, proxyUserDataB:*):void {
		var fixtureA:b2Fixture = proxyUserDataA as b2Fixture;
		var fixtureB:b2Fixture = proxyUserDataB as b2Fixture;
		
		var bodyA:b2Body = fixtureA.GetBody();
		var bodyB:b2Body = fixtureB.GetBody();
		
		// Are the fixtures on the same body?
		if (bodyA == bodyB)
			return;
		
		// Does a contact already exist?
		var edge:b2ContactEdge = bodyB.GetContactList();
		while (edge)
		{
			if (edge.other == bodyA)
			{
				var fA:b2Fixture = edge.contact.GetFixtureA();
				var fB:b2Fixture = edge.contact.GetFixtureB();
				if (fA == fixtureA && fB == fixtureB)
					return;
				if (fA == fixtureB && fB == fixtureA)
					return;
			}
			edge = edge.next;
		}
		
		//Does a joint override collision? Is at least one body dynamic?
		if (bodyB.ShouldCollide(bodyA) == false)
		{
			return;
		}
		
		// Check user filtering
		if (m_contactFilter.ShouldCollide(fixtureA, fixtureB) == false)
		{
			return;
		}
		
		// Call the factory.
		var c:b2Contact = m_contactFactory.Create(fixtureA, fixtureB);
		
		// Contact creation may swap shapes.
		fixtureA = c.GetFixtureA();
		fixtureB = c.GetFixtureB();
		bodyA = fixtureA.m_body;
		bodyB = fixtureB.m_body;
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
		
		// Insert into the world.
		c.m_prev = null;
		c.m_next = m_world.m_contactList;
		if (m_world.m_contactList != null)
		{
			m_world.m_contactList.m_prev = c;
		}
		m_world.m_contactList = c;
		
		
		// Connect to island graph.
		
<<<<<<< HEAD
		// Connect to body 1
		c.m_node1.contact = c;
		c.m_node1.other = body2;
		
		c.m_node1.prev = null;
		c.m_node1.next = body1.m_contactList;
		if (body1.m_contactList != null)
		{
			body1.m_contactList.prev = c.m_node1;
		}
		body1.m_contactList = c.m_node1;
		
		// Connect to body 2
		c.m_node2.contact = c;
		c.m_node2.other = body1;
		
		c.m_node2.prev = null;
		c.m_node2.next = body2.m_contactList;
		if (body2.m_contactList != null)
		{
			body2.m_contactList.prev = c.m_node2;
		}
		body2.m_contactList = c.m_node2;
		
		++m_world.m_contactCount;
		return c;
		
	}

	// This is a callback from the broadphase when two AABB proxies cease
	// to overlap. We retire the b2Contact.
	public override function PairRemoved(proxyUserData1:*, proxyUserData2:*, pairUserData:*): void{
		
		if (pairUserData == null)
		{
			return;
		}
		
		var c:b2Contact = pairUserData as b2Contact;
		if (c == m_nullContact)
		{
			return;
		}
		
		// An attached body is being destroyed, we must destroy this contact
		// immediately to avoid orphaned shape pointers.
		Destroy(c);
=======
		// Connect to body A
		c.m_nodeA.contact = c;
		c.m_nodeA.other = bodyB;
		
		c.m_nodeA.prev = null;
		c.m_nodeA.next = bodyA.m_contactList;
		if (bodyA.m_contactList != null)
		{
			bodyA.m_contactList.prev = c.m_nodeA;
		}
		bodyA.m_contactList = c.m_nodeA;
		
		// Connect to body 2
		c.m_nodeB.contact = c;
		c.m_nodeB.other = bodyA;
		
		c.m_nodeB.prev = null;
		c.m_nodeB.next = bodyB.m_contactList;
		if (bodyB.m_contactList != null)
		{
			bodyB.m_contactList.prev = c.m_nodeB;
		}
		bodyB.m_contactList = c.m_nodeB;
		
		++m_world.m_contactCount;
		return;
		
	}

	public function FindNewContacts():void
	{
		m_broadPhase.UpdatePairs(AddPair);
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
	}
	
	static private const s_evalCP:b2ContactPoint = new b2ContactPoint();
	public function Destroy(c:b2Contact) : void
	{
		
<<<<<<< HEAD
		var shape1:b2Shape = c.m_shape1;
		var shape2:b2Shape = c.m_shape2;
		var body1:b2Body = shape1.m_body;
		var body2:b2Body = shape2.m_body;
		var cp:b2ContactPoint = s_evalCP;
		cp.shape1 = c.m_shape1;
		cp.shape2 = c.m_shape2;
		cp.friction = b2Settings.b2MixFriction(shape1.GetFriction(), shape2.GetFriction());
		cp.restitution = b2Settings.b2MixRestitution(shape1.GetRestitution(), shape2.GetRestitution());
		
		// Inform the user that this contact is ending.
		var manifoldCount:int = c.m_manifoldCount;
		if (manifoldCount > 0 && m_world.m_contactListener)
		{
			var manifolds:Array  = c.GetManifolds();
			
			for (var i:int = 0; i < manifoldCount; ++i)
			{
				var manifold:b2Manifold = manifolds[ i ];
				cp.normal.SetV(manifold.normal);
				
				for (var j:int = 0; j < manifold.pointCount; ++j)
				{
					var mp:b2ManifoldPoint = manifold.points[j];
					cp.position = body1.GetWorldPoint(mp.localPoint1);
					var v1:b2Vec2 = body1.GetLinearVelocityFromLocalPoint(mp.localPoint1);
					var v2:b2Vec2 = body2.GetLinearVelocityFromLocalPoint(mp.localPoint2);
					cp.velocity.Set(v2.x - v1.x, v2.y - v1.y);
					cp.separation = mp.separation;
					cp.id.key = mp.id._key;
					m_world.m_contactListener.Remove(cp);
				}
			}
=======
		var fixtureA:b2Fixture = c.GetFixtureA();
		var fixtureB:b2Fixture = c.GetFixtureB();
		var bodyA:b2Body = fixtureA.GetBody();
		var bodyB:b2Body = fixtureB.GetBody();
		
		if (c.m_manifold.m_pointCount > 0)
		{
			m_contactListener.EndContact(c);
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
		}
		
		// Remove from the world.
		if (c.m_prev)
		{
			c.m_prev.m_next = c.m_next;
		}
		
		if (c.m_next)
		{
			c.m_next.m_prev = c.m_prev;
		}
		
		if (c == m_world.m_contactList)
		{
			m_world.m_contactList = c.m_next;
		}
		
<<<<<<< HEAD
		// Remove from body 1
		if (c.m_node1.prev)
		{
			c.m_node1.prev.next = c.m_node1.next;
		}
		
		if (c.m_node1.next)
		{
			c.m_node1.next.prev = c.m_node1.prev;
		}
		
		if (c.m_node1 == body1.m_contactList)
		{
			body1.m_contactList = c.m_node1.next;
		}
		
		// Remove from body 2
		if (c.m_node2.prev)
		{
			c.m_node2.prev.next = c.m_node2.next;
		}
		
		if (c.m_node2.next)
		{
			c.m_node2.next.prev = c.m_node2.prev;
		}
		
		if (c.m_node2 == body2.m_contactList)
		{
			body2.m_contactList = c.m_node2.next;
		}
		
		// Call the factory.
		b2Contact.Destroy(c, m_world.m_blockAllocator);
		--m_world.m_contactCount;
=======
		// Remove from body A
		if (c.m_nodeA.prev)
		{
			c.m_nodeA.prev.next = c.m_nodeA.next;
		}
		
		if (c.m_nodeA.next)
		{
			c.m_nodeA.next.prev = c.m_nodeA.prev;
		}
		
		if (c.m_nodeA == bodyA.m_contactList)
		{
			bodyA.m_contactList = c.m_nodeA.next;
		}
		
		// Remove from body 2
		if (c.m_nodeB.prev)
		{
			c.m_nodeB.prev.next = c.m_nodeB.next;
		}
		
		if (c.m_nodeB.next)
		{
			c.m_nodeB.next.prev = c.m_nodeB.prev;
		}
		
		if (c.m_nodeB == bodyB.m_contactList)
		{
			bodyB.m_contactList = c.m_nodeB.next;
		}
		
		// Call the factory.
		m_contactFactory.Destroy(c);
		--m_contactCount;
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
	}
	

	// This is the top level collision call for the time step. Here
	// all the narrow phase collision is processed for the world
	// contact list.
	public function Collide() : void
	{
		// Update awake contacts.
<<<<<<< HEAD
		for (var c:b2Contact = m_world.m_contactList; c; c = c.m_next)
		{
			var body1:b2Body = c.m_shape1.m_body;
			var body2:b2Body = c.m_shape2.m_body;
			if (body1.IsSleeping() && body2.IsSleeping())
			{
				continue;
			}
			
			c.Update(m_world.m_contactListener);
		}
	}

	b2internal var m_world:b2World;

	// This lets us provide broadphase proxy pair user data for
	// contacts that shouldn't exist.
	private var m_nullContact:b2NullContact = new b2NullContact();
	private var m_destroyImmediate:Boolean;
	
=======
		var c:b2Contact = m_world.m_contactList;
		while (c)
		{
			var fixtureA:b2Fixture = c.GetFixtureA();
			var fixtureB:b2Fixture = c.GetFixtureB();
			var bodyA:b2Body = fixtureA.GetBody();
			var bodyB:b2Body = fixtureB.GetBody();
			if (bodyA.IsAwake() == false && bodyB.IsAwake() == false)
			{
				c = c.GetNext();
				continue;
			}
			
			// Is this contact flagged for filtering?
			if (c.m_flags & b2Contact.e_filterFlag)
			{
				// Should these bodies collide?
				if (bodyB.ShouldCollide(bodyA) == false)
				{
					var cNuke:b2Contact = c;
					c = cNuke.GetNext();
					Destroy(cNuke);
					continue;
				}
				
				// Check user filtering.
				if (m_contactFilter.ShouldCollide(fixtureA, fixtureB) == false)
				{
					cNuke = c;
					c = cNuke.GetNext();
					Destroy(cNuke);
					continue;
				}
				
				// Clear the filtering flag
				c.m_flags &= ~b2Contact.e_filterFlag;
			}
			
			var proxyA:* = fixtureA.m_proxy;
			var proxyB:* = fixtureB.m_proxy;
			
			var overlap:Boolean = m_broadPhase.TestOverlap(proxyA, proxyB);
			
			// Here we destroy contacts that cease to overlap in the broadphase
			if ( overlap == false)
			{
				cNuke = c;
				c = cNuke.GetNext();
				Destroy(cNuke);
				continue;
			}
			
			c.Update(m_contactListener);
			c = c.GetNext();
		}
	}

	
	b2internal var m_world:b2World;
	b2internal var m_broadPhase:IBroadPhase;
	
	b2internal var m_contactList:b2Contact;
	b2internal var m_contactCount:int;
	b2internal var m_contactFilter:b2ContactFilter;
	b2internal var m_contactListener:b2ContactListener;
	b2internal var m_contactFactory:b2ContactFactory;
	b2internal var m_allocator:*;
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
};

}
