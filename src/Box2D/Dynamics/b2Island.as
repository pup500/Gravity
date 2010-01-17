﻿/*
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

	
import Box2D.Common.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.Contacts.*;
import Box2D.Dynamics.Joints.*;
import Box2D.Collision.*;

import Box2D.Common.b2internal;
use namespace b2internal;


/*
Position Correction Notes
=========================
I tried the several algorithms for position correction of the 2D revolute joint.
I looked at these systems:
- simple pendulum (1m diameter sphere on massless 5m stick) with initial angular velocity of 100 rad/s.
- suspension bridge with 30 1m long planks of length 1m.
- multi-link chain with 30 1m long links.

Here are the algorithms:

Baumgarte - A fraction of the position error is added to the velocity error. There is no
separate position solver.

Pseudo Velocities - After the velocity solver and position integration,
the position error, Jacobian, and effective mass are recomputed. Then
the velocity constraints are solved with pseudo velocities and a fraction
of the position error is added to the pseudo velocity error. The pseudo
velocities are initialized to zero and there is no warm-starting. After
the position solver, the pseudo velocities are added to the positions.
This is also called the First Order World method or the Position LCP method.

Modified Nonlinear Gauss-Seidel (NGS) - Like Pseudo Velocities except the
position error is re-computed for each constraint and the positions are updated
after the constraint is solved. The radius vectors (aka Jacobians) are
re-computed too (otherwise the algorithm has horrible instability). The pseudo
velocity states are not needed because they are effectively zero at the beginning
of each iteration. Since we have the current position error, we allow the
iterations to terminate early if the error becomes smaller than b2_linearSlop.

Full NGS or just NGS - Like Modified NGS except the effective mass are re-computed
each time a constraint is solved.

Here are the results:
Baumgarte - this is the cheapest algorithm but it has some stability problems,
especially with the bridge. The chain links separate easily close to the root
and they jitter as they struggle to pull together. This is one of the most common
methods in the field. The big drawback is that the position correction artificially
affects the momentum, thus leading to instabilities and false bounce. I used a
bias factor of 0.2. A larger bias factor makes the bridge less stable, a smaller
factor makes joints and contacts more spongy.

Pseudo Velocities - the is more stable than the Baumgarte method. The bridge is
stable. However, joints still separate with large angular velocities. Drag the
simple pendulum in a circle quickly and the joint will separate. The chain separates
easily and does not recover. I used a bias factor of 0.2. A larger value lead to
the bridge collapsing when a heavy cube drops on it.

Modified NGS - this algorithm is better in some ways than Baumgarte and Pseudo
Velocities, but in other ways it is worse. The bridge and chain are much more
stable, but the simple pendulum goes unstable at high angular velocities.

Full NGS - stable in all tests. The joints display good stiffness. The bridge
still sags, but this is better than infinite forces.

Recommendations
Pseudo Velocities are not really worthwhile because the bridge and chain cannot
recover from joint separation. In other cases the benefit over Baumgarte is small.

Modified NGS is not a robust method for the revolute joint due to the violent
instability seen in the simple pendulum. Perhaps it is viable with other constraint
types, especially scalar constraints where the effective mass is a scalar.

This leaves Baumgarte and Full NGS. Baumgarte has small, but manageable instabilities
and is very fast. I don't think we can escape Baumgarte, especially in highly
demanding cases where high constraint fidelity is not needed.

Full NGS is robust and easy on the eyes. I recommend this as an option for
higher fidelity simulation and certainly for suspension bridges and long chains.
Full NGS might be a good choice for ragdolls, especially motorized ragdolls where
joint separation can be problematic. The number of NGS iterations can be reduced
for better performance without harming robustness much.

Each joint in a can be handled differently in the position solver. So I recommend
a system where the user can select the algorithm on a per joint basis. I would
probably default to the slower Full NGS and let the user select the faster
Baumgarte method in performance critical scenarios.
*/


/**
* @private
*/
public class b2Island
{
<<<<<<< HEAD
	public function b2Island(
=======
	
	public function b2Island()
	{
		m_bodies = new Array/*b2Body*/();
		m_contacts = new Array/*b2Contact*/();
		m_joints = new Array/*b2Joint*/();
	}
	
	public function Initialize(
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
	bodyCapacity:int,
	contactCapacity:int,
	jointCapacity:int,
	allocator:*,
<<<<<<< HEAD
	listener:b2ContactListener)
=======
	listener:b2ContactListener,
	contactSolver:b2ContactSolver):void
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
	{
		var i:int;
		
		m_bodyCapacity = bodyCapacity;
		m_contactCapacity = contactCapacity;
		m_jointCapacity	 = jointCapacity;
		m_bodyCount = 0;
		m_contactCount = 0;
		m_jointCount = 0;
		
		m_allocator = allocator;
		m_listener = listener;
<<<<<<< HEAD
		
		//m_bodies = (b2Body**)allocator->Allocate(bodyCapacity * sizeof(b2Body*));
		m_bodies = new Array(bodyCapacity);
		for (i = 0; i < bodyCapacity; i++)
			m_bodies[i] = null;
		
		//m_contacts = (b2Contact**)allocator->Allocate(contactCapacity	 * sizeof(b2Contact*));
		m_contacts = new Array(contactCapacity);
		for (i = 0; i < contactCapacity; i++)
			m_contacts[i] = null;
		
		//m_joints = (b2Joint**)allocator->Allocate(jointCapacity * sizeof(b2Joint*));
		m_joints = new Array(jointCapacity);
		for (i = 0; i < jointCapacity; i++)
=======
		m_contactSolver = contactSolver;
		
		for (i = m_bodies.length; i < bodyCapacity; i++)
			m_bodies[i] = null;
		
		for (i = m_contacts.length; i < contactCapacity; i++)
			m_contacts[i] = null;
		
		for (i = m_joints.length; i < jointCapacity; i++)
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
			m_joints[i] = null;
		
	}
	//~b2Island();
	
	public function Clear() : void
	{
		m_bodyCount = 0;
		m_contactCount = 0;
		m_jointCount = 0;
	}

	public function Solve(step:b2TimeStep, gravity:b2Vec2, allowSleep:Boolean) : void
	{
		var i:int;
		var j:int;
		var b:b2Body;
		var joint:b2Joint;
		
		// Integrate velocities and apply damping.
		for (i = 0; i < m_bodyCount; ++i)
		{
			b = m_bodies[i];
			
<<<<<<< HEAD
			if (b.IsStatic())
=======
			if (b.GetType() != b2Body.b2_dynamicBody)
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
				continue;
			
			// Integrate velocities.
			//b.m_linearVelocity += step.dt * (gravity + b.m_invMass * b.m_force);
			b.m_linearVelocity.x += step.dt * (gravity.x + b.m_invMass * b.m_force.x);
			b.m_linearVelocity.y += step.dt * (gravity.y + b.m_invMass * b.m_force.y);
			b.m_angularVelocity += step.dt * b.m_invI * b.m_torque;
			
<<<<<<< HEAD
			// Reset forces.
			b.m_force.SetZero();
			b.m_torque = 0.0;
			
=======
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
			// Apply damping.
			// ODE: dv/dt + c * v = 0
			// Solution: v(t) = v0 * exp(-c * t)
			// Time step: v(t + dt) = v0 * exp(-c * (t + dt)) = v0 * exp(-c * t) * exp(-c * dt) = v * exp(-c * dt)
			// v2 = exp(-c * dt) * v1
			// Taylor expansion:
			// v2 = (1.0f - c * dt) * v1
<<<<<<< HEAD
			b.m_linearVelocity.Multiply( b2Math.b2Clamp(1.0 - step.dt * b.m_linearDamping, 0.0, 1.0) );
			b.m_angularVelocity *= b2Math.b2Clamp(1.0 - step.dt * b.m_angularDamping, 0.0, 1.0);
			
			// Check for large velocities.
			//if (b2Dot(b->m_linearVelocity, b->m_linearVelocity) > b2_maxLinearVelocitySquared)
			if ((b.m_linearVelocity.LengthSquared()) > b2Settings.b2_maxLinearVelocitySquared)
			{
				b.m_linearVelocity.Normalize();
				b.m_linearVelocity.x *= b2Settings.b2_maxLinearVelocity;
				b.m_linearVelocity.y *= b2Settings.b2_maxLinearVelocity;
			}
			
			if (b.m_angularVelocity * b.m_angularVelocity > b2Settings.b2_maxAngularVelocitySquared)
			{
				if (b.m_angularVelocity < 0.0)
				{
					b.m_angularVelocity = -b2Settings.b2_maxAngularVelocity;
				}
				else
				{
					b.m_angularVelocity = b2Settings.b2_maxAngularVelocity;
				}
			}
		}
		
		var contactSolver:b2ContactSolver = new b2ContactSolver(step, m_contacts, m_contactCount, m_allocator);
		
=======
			b.m_linearVelocity.Multiply( b2Math.Clamp(1.0 - step.dt * b.m_linearDamping, 0.0, 1.0) );
			b.m_angularVelocity *= b2Math.Clamp(1.0 - step.dt * b.m_angularDamping, 0.0, 1.0);
		}
		
		m_contactSolver.Initialize(step, m_contacts, m_contactCount, m_allocator);
		var contactSolver:b2ContactSolver = m_contactSolver;

>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
		// Initialize velocity constraints.
		contactSolver.InitVelocityConstraints(step);
		
		for (i = 0; i < m_jointCount; ++i)
		{
			joint = m_joints[i];
			joint.InitVelocityConstraints(step);
		}
		
		// Solve velocity constraints.
		for (i = 0; i < step.velocityIterations; ++i)
		{	
			for (j = 0; j < m_jointCount; ++j)
			{
				joint = m_joints[j];
				joint.SolveVelocityConstraints(step);
			}
			
			contactSolver.SolveVelocityConstraints();
		}
		
		// Post-solve (store impulses for warm starting).
<<<<<<< HEAD
=======
		for (i = 0; i < m_jointCount; ++i)
		{
			joint = m_joints[i];
			joint.FinalizeVelocityConstraints();
		}
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
		contactSolver.FinalizeVelocityConstraints();
		
		// Integrate positions.
		for (i = 0; i < m_bodyCount; ++i)
		{
			b = m_bodies[i];
			
<<<<<<< HEAD
			if (b.IsStatic())
				continue;
=======
			if (b.GetType() == b2Body.b2_staticBody)
				continue;
				
			// Check for large velocities.
			// b2Vec2 translation = step.dt * b.m_linearVelocity;
			var translationX:Number = step.dt * b.m_linearVelocity.x;
			var translationY:Number = step.dt * b.m_linearVelocity.y;
			//if (b2Dot(translation, translation) > b2_maxTranslationSquared)
			if ((translationX*translationX+translationY*translationY) > b2Settings.b2_maxTranslationSquared)
			{
				b.m_linearVelocity.Normalize();
				b.m_linearVelocity.x *= b2Settings.b2_maxTranslation * step.inv_dt;
				b.m_linearVelocity.y *= b2Settings.b2_maxTranslation * step.inv_dt;
			}
			var rotation:Number = step.dt * b.m_angularVelocity;
			if (rotation * rotation > b2Settings.b2_maxRotationSquared)
			{
				if (b.m_angularVelocity < 0.0)
				{
					b.m_angularVelocity = -b2Settings.b2_maxRotation * step.inv_dt;
				}
				else
				{
					b.m_angularVelocity = b2Settings.b2_maxRotation * step.inv_dt;
				}
			}
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
			
			// Store positions for continuous collision.
			b.m_sweep.c0.SetV(b.m_sweep.c);
			b.m_sweep.a0 = b.m_sweep.a;
			
			// Integrate
			//b.m_sweep.c += step.dt * b.m_linearVelocity;
			b.m_sweep.c.x += step.dt * b.m_linearVelocity.x;
			b.m_sweep.c.y += step.dt * b.m_linearVelocity.y;
			b.m_sweep.a += step.dt * b.m_angularVelocity;
			
			// Compute new transform
			b.SynchronizeTransform();
			
			// Note: shapes are synchronized later.
		}
		
		// Iterate over constraints.
		for (i = 0; i < step.positionIterations; ++i)
		{
			var contactsOkay:Boolean = contactSolver.SolvePositionConstraints(b2Settings.b2_contactBaumgarte);
			
			var jointsOkay:Boolean = true;
			for (j = 0; j < m_jointCount; ++j)
			{
				joint = m_joints[j];
				var jointOkay:Boolean = joint.SolvePositionConstraints(b2Settings.b2_contactBaumgarte);
				jointsOkay = jointsOkay && jointOkay;
			}
			
			if (contactsOkay && jointsOkay)
			{
				break;
			}
		}
		
		Report(contactSolver.m_constraints);
		
		if (allowSleep){
			
			var minSleepTime:Number = Number.MAX_VALUE;
			
			var linTolSqr:Number = b2Settings.b2_linearSleepTolerance * b2Settings.b2_linearSleepTolerance;
			var angTolSqr:Number = b2Settings.b2_angularSleepTolerance * b2Settings.b2_angularSleepTolerance;
			
			for (i = 0; i < m_bodyCount; ++i)
			{
				b = m_bodies[i];
<<<<<<< HEAD
				if (b.m_invMass == 0.0)
=======
				if (b.GetType() == b2Body.b2_staticBody)
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
				{
					continue;
				}
				
				if ((b.m_flags & b2Body.e_allowSleepFlag) == 0)
				{
					b.m_sleepTime = 0.0;
					minSleepTime = 0.0;
				}
				
				if ((b.m_flags & b2Body.e_allowSleepFlag) == 0 ||
					b.m_angularVelocity * b.m_angularVelocity > angTolSqr ||
<<<<<<< HEAD
					b2Math.b2Dot(b.m_linearVelocity, b.m_linearVelocity) > linTolSqr)
=======
					b2Math.Dot(b.m_linearVelocity, b.m_linearVelocity) > linTolSqr)
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
				{
					b.m_sleepTime = 0.0;
					minSleepTime = 0.0;
				}
				else
				{
					b.m_sleepTime += step.dt;
<<<<<<< HEAD
					minSleepTime = b2Math.b2Min(minSleepTime, b.m_sleepTime);
=======
					minSleepTime = b2Math.Min(minSleepTime, b.m_sleepTime);
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
				}
			}
			
			if (minSleepTime >= b2Settings.b2_timeToSleep)
			{
				for (i = 0; i < m_bodyCount; ++i)
				{
<<<<<<< HEAD
					b = m_bodies[i];
					b.m_flags |= b2Body.e_sleepFlag;
					b.m_linearVelocity.SetZero();
					b.m_angularVelocity = 0.0;
=======
					b = m_bodies[i]; 
					b.SetAwake(false);
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
				}
			}
		}
	}
	
	
	public function SolveTOI(subStep:b2TimeStep) : void
	{
		var i:int;
		var j:int;
<<<<<<< HEAD
		var contactSolver:b2ContactSolver = new b2ContactSolver(subStep, m_contacts, m_contactCount, m_allocator);
		
		// No warm starting needed for TOI events.
		
		// For joints, initialize with the last full step warm starting values
		subStep.warmStarting = true;
		
=======
		m_contactSolver.Initialize(subStep, m_contacts, m_contactCount, m_allocator);
		var contactSolver:b2ContactSolver = m_contactSolver;
		
		// No warm starting is needed for TOI events because warm
		// starting impulses were applied in the discrete solver.

		// Warm starting for joints is off for now, but we need to
		// call this function to compute Jacobians.
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
		for (i = 0; i < m_jointCount;++i)
		{
			m_joints[i].InitVelocityConstraints(subStep);
		}
		
		
		// Solve velocity constraints.
		for (i = 0; i < subStep.velocityIterations; ++i)
		{
			contactSolver.SolveVelocityConstraints();
			for (j = 0; j < m_jointCount;++j)
			{
<<<<<<< HEAD
				m_joints[j].InitVelocityConstraints(subStep);
=======
				m_joints[j].SolveVelocityConstraints(subStep);
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
			}
		}
		
		// Don't store the TOI contact forces for warm starting
		// because they can be quite large.
		
		// Integrate positions.
		for (i = 0; i < m_bodyCount; ++i)
		{
			var b:b2Body = m_bodies[i];
			
<<<<<<< HEAD
			if (b.IsStatic())
				continue;
=======
			if (b.GetType() == b2Body.b2_staticBody)
				continue;
				
			// Check for large velocities.
			// b2Vec2 translation = subStep.dt * b.m_linearVelocity;
			var translationX:Number = subStep.dt * b.m_linearVelocity.x;
			var translationY:Number = subStep.dt * b.m_linearVelocity.y;
			//if (b2Dot(translation, translation) > b2_maxTranslationSquared)
			if ((translationX*translationX+translationY*translationY) > b2Settings.b2_maxTranslationSquared)
			{
				b.m_linearVelocity.Normalize();
				b.m_linearVelocity.x *= b2Settings.b2_maxTranslation * subStep.inv_dt;
				b.m_linearVelocity.y *= b2Settings.b2_maxTranslation * subStep.inv_dt;
			}
			
			var rotation:Number = subStep.dt * b.m_angularVelocity;
			if (rotation * rotation > b2Settings.b2_maxRotationSquared)
			{
				if (b.m_angularVelocity < 0.0)
				{
					b.m_angularVelocity = -b2Settings.b2_maxRotation * subStep.inv_dt;
				}
				else
				{
					b.m_angularVelocity = b2Settings.b2_maxRotation * subStep.inv_dt;
				}
			}
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
			
			// Store positions for continuous collision.
			b.m_sweep.c0.SetV(b.m_sweep.c);
			b.m_sweep.a0 = b.m_sweep.a;
			
			// Integrate
			b.m_sweep.c.x += subStep.dt * b.m_linearVelocity.x;
			b.m_sweep.c.y += subStep.dt * b.m_linearVelocity.y;
			b.m_sweep.a += subStep.dt * b.m_angularVelocity;
			
			// Compute new transform
			b.SynchronizeTransform();
			
			// Note: shapes are synchronized later.
		}
		
		// Solve position constraints.
		var k_toiBaumgarte:Number = 0.75;
		for (i = 0; i < subStep.positionIterations; ++i)
		{
			var contactsOkay:Boolean = contactSolver.SolvePositionConstraints(k_toiBaumgarte);
			var jointsOkay:Boolean = true;
			for (j = 0; j < m_jointCount;++j)
			{
				var jointOkay:Boolean = m_joints[j].SolvePositionConstraints(b2Settings.b2_contactBaumgarte);
				jointsOkay = jointsOkay && jointOkay;
			}
			
			if (contactsOkay && jointsOkay)
			{
				break;
			}
		}
		Report(contactSolver.m_constraints);
	}

<<<<<<< HEAD
	static private var s_reportCR:b2ContactResult = new b2ContactResult();
	public function Report(constraints:Array) : void
	{
		var tMat:b2Mat22;
		var tVec:b2Vec2;
=======
	private static var s_impulse:b2ContactImpulse = new b2ContactImpulse();
	public function Report(constraints:Array/*b2ContactConstraint*/) : void
	{
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
		if (m_listener == null)
		{
			return;
		}
		
		for (var i:int = 0; i < m_contactCount; ++i)
		{
			var c:b2Contact = m_contacts[i];
			var cc:b2ContactConstraint = constraints[ i ];
<<<<<<< HEAD
			var cr:b2ContactResult = s_reportCR;
			cr.shape1 = c.m_shape1;
			cr.shape2 = c.m_shape2;
			var b1:b2Body = cr.shape1.m_body;
			var manifoldCount:int = c.m_manifoldCount;
			var manifolds:Array = c.GetManifolds();
			for (var j:int = 0; j < manifoldCount; ++j)
			{
				var manifold:b2Manifold = manifolds[ j ];
				cr.normal.SetV( manifold.normal );
				for (var k:int = 0; k < manifold.pointCount; ++k)
				{
					var point:b2ManifoldPoint = manifold.points[ k ];
					var ccp:b2ContactConstraintPoint = cc.points[ k ];
					cr.position = b1.GetWorldPoint(point.localPoint1);
					
					// TOI constraint results are not stored, so get
					// the result from the constraint.
					cr.normalImpulse = ccp.normalImpulse;
					cr.tangentImpulse = ccp.tangentImpulse;
					cr.id.key = point.id.key;
					
					m_listener.Result(cr);
				}
			}
=======
			
			for (var j:int = 0; j < cc.pointCount; ++j)
			{
				s_impulse.normalImpulses[j] = cc.points[j].normalImpulse;
				s_impulse.tangentImpulses[j] = cc.points[j].tangentImpulse;
			}
			m_listener.PostSolve(c, s_impulse);
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8
		}
	}
	

	public function AddBody(body:b2Body) : void
	{
		//b2Settings.b2Assert(m_bodyCount < m_bodyCapacity);
		body.m_islandIndex = m_bodyCount;
		m_bodies[m_bodyCount++] = body;
	}

	public function AddContact(contact:b2Contact) : void
	{
		//b2Settings.b2Assert(m_contactCount < m_contactCapacity);
		m_contacts[m_contactCount++] = contact;
	}

	public function AddJoint(joint:b2Joint) : void
	{
		//b2Settings.b2Assert(m_jointCount < m_jointCapacity);
		m_joints[m_jointCount++] = joint;
	}

	private var m_allocator:*;
	private var m_listener:b2ContactListener;
<<<<<<< HEAD

	b2internal var m_bodies:Array;
	b2internal var m_contacts:Array;
	b2internal var m_joints:Array;
=======
	private var m_contactSolver:b2ContactSolver;

	b2internal var m_bodies:Array/*b2Body*/;
	b2internal var m_contacts:Array/*b2Contact*/;
	b2internal var m_joints:Array/*b2Joint*/;
>>>>>>> cb6bab22251054172cb2be231e969ace5a7805e8

	b2internal var m_bodyCount:int;
	b2internal var m_jointCount:int;
	b2internal var m_contactCount:int;

	private var m_bodyCapacity:int;
	b2internal var m_contactCapacity:int;
	b2internal var m_jointCapacity:int;
	
};

}
