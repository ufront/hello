package app.model;

import ufront.db.Object;
import sys.db.Types;

@:index( email, unique )
class Registration extends Object {
	
	public var name:Null<SString<50>>;
	
	@:validate( _.length>3 && _.indexOf('@')>0 )
	public var email:SString<255>;
}