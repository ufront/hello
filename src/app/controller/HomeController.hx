package app.controller;

import ufront.web.Controller;
import app.api.SignupApi;
import ufront.web.result.*;
#if server
	import ufront.ufadmin.controller.UFAdminHomeController;
#end

/**
	Our HomeController is the entry point to our Hello World web app.
	By extending `ufront.web.Controller`, we get a macro-powered `execute()` method.
	The `execute` method picks the right method to execute based on the current HTTP Request and our `@:route()` information.
**/
class HomeController extends Controller {

	// All of our controllers are created using dependency injection.
	// Usually this is for injecting APIs, but you can use anything else you've added to your app injector.
	// Injected variables must be public and have the `@inject` metadata.
	@inject public var asyncSignupApi:AsyncSignupApi;

	#if server
		// You can add a sub-controller by declaring a public variable with `@:route()` metadata.
		// In our case, the `UFAdminHomeController` only works on the server, hence the `#if server` conditionals.
		// The "*" is a wildcard - it means any routes that start with "/ufadmin/" will be matched, including "/ufadmin/db/" etc.
		@:route("/ufadmin/*")
		public var ufAdminController:UFAdminHomeController;
	#end

	// Each "action" on our controller is just a function and a route.
	// When you visit that route, this method will execute, and show the desired result.
	@:route('/')
	public function homepage() {
		// This will load the view "home/homepage.html", with our default layout and the "Hello World" title.
		// The "home/" folder is picked because we are in `HomeController`, and "homepage.html" is picked because we are in `homepage()`.
		return new ViewResult({ title: 'Hello World' });
	}

	// Variables start with a "$", and can go in any section of the route, between the slashes.
	// Leading slashes and trailing slashes don't matter - you can include them or leave them out.
	// They will then be available as an argument to the function call.
	@:route(GET,"/$name/")
	public function welcome( name:String ) {
		// You can use ufTrace, ufLog, ufWarn and ufError to trace straight to the browser console.
		ufTrace( 'Hey $name, did you know you can trace straight to the browser console?' );
		// This time let's specify the template we want to use explicitly.
		return new ViewResult({ title: 'Hello $name' }, "/home/homepage.html");
	}

	// You can also specify `GET` and `POST` - only requests with a matching HTTP Method will execute this action.
	// If you want to read POST or GET parameters, use an `args:{}` parameter in your method.
	@:route(POST, "/subscribe")
	public function signup( args:{ name:String, email:String } ) {
		// Now we're going to make an API call.
		// Because modern JS browsers do not support synchronous HTTP calls, we have to use the async version of our API.
		// We're going to use the special ">>" syntax to respond to a successful API call and redirect the user.
		// See https://github.com/haxetink/tink_core#future to learn more about futures, surprises and the ">>" operator.
		return asyncSignupApi.registerEmail( args.name, args.email ) >> function(regID:Int) {
			trace( '${args.name} registered with $regID' );
			return new RedirectResult( '/thank/${args.name}' );
		}
	}

	@:route("/thank/$name")
	public function thankyou( name:String ) {
		return new ViewResult({ title: 'Thanks $name!' });
	}

	@:route("/subscribers/list.csv")
	public function showSubscribersCSV() {
		return asyncSignupApi.listSignups() >> function(subscribers:Map<String,String>) {
			var lines = [ for(name in subscribers.keys()) '$name,${subscribers[name]}'];
			var csv = lines.join("\n");
			// Look, a different content type! Note that ufront-client can only process text/html or redirects.
			return new ContentResult( csv, "text/csv" );
		}
	}

	@:route("/subscribers/list.html")
	public function showSubscribersTable() {
		return asyncSignupApi.listSignups() >> function(subscribers:Map<String,String>) {
			var lines = [ for(name in subscribers.keys()) '<tr><td>$name</td><td>${subscribers[name]}</td></tr>'];
			var rows = lines.join("\n");
			// Look, a different content type! Note that ufront-client can only process text/html or redirects.
			return new ContentResult( '<table class="table">$rows</table>', "text/html" );
		}
	}
}
