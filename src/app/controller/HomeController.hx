package app.controller;

import ufront.web.Controller;
import app.api.SignupApi;
import ufront.web.result.*;
import ufront.ufadmin.controller.UFAdminHomeController;
import app.Permissions;

class HomeController extends Controller {

	@inject
	public var signupApi:SignupApi;
	
	@:route("/ufadmin/*")
	public var ufAdminController:UFAdminHomeController;
	
	@:route(GET, "/$name")
	public function homepage( ?name:String="World" ) {
		ufTrace( 'Hey $name, did you know you can trace straight to the browser console?' );
		return new ViewResult({ title: 'Hello $name' });
	}
	
	@:route(POST, "/subscribe")
	public function signup( args:{ name:String, email:String } ) {
		signupApi.registerEmail( args.name, args.email );
		var name = (args.name!=""&&args.name!=null) ? args.name : "World";
		return new RedirectResult( '/thank/$name' );
	}
	
	@:route(GET, "/thank/$name")
	public function thankyou( name:String ) {
		return new ViewResult({ title: 'Thanks $name!' });
	}
	
	@:route("/subscribers/list.csv")
	public function listSubscribers() {
		context.auth.requirePermission( CanViewSubscriberList );
		var subscribers = signupApi.listSignups();
		var lines = [ for(name in subscribers.keys()) '$name,${subscribers[name]}'];
		var csv = lines.join("\n");
		return new ContentResult( csv, "text/csv" );
	}
}
