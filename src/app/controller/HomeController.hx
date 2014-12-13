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
	
	/**
	 * Serve static files in ./public directory.
	 * In production mode it is preferable to use the server (nginx, apache etc..) to 
	 * serve static files instead.
	 */
	@:route(GET, "/public/*")
	function getPublicResource(rest:Array<String>) {
		return new DirectFilePathResult(rest.join('/'));
	}
	
	@:route(GET, "/$name")
	function homepage( ?name:String="World" ) {
		ufTrace( 'Hey $name, did you know you can trace straight to the browser console?' );
		return new ViewResult({ title: 'Hello $name' });
	}
	
	@:route(POST, "/subscribe")
	function signup( args:{ name:String, email:String } ) {
		signupApi.registerEmail( args.name, args.email );
		return new RedirectResult( '/thank/${args.name}' );
	}
	
	@:route(GET, "/thank/$name")
	function thankyou( ?name:String="World" ) {
		return new ViewResult({ title: 'Thanks $name!' });
	}
	
	@:route("/subscribers/list.csv")
	function listSubscribers() {
		context.auth.requirePermission( CanViewSubscriberList );
		var subscribers = signupApi.listSignups();
		var lines = [ for(name in subscribers.keys()) '$name,${subscribers[name]}'];
		var csv = lines.join("\n");
		return new ContentResult( csv, "text/csv" );
	}
}
