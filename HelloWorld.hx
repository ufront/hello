import ufront.MVC;

/**
This is an example of how to initiate and execute a Ufront app.
The process differs slightly between client and server.
**/
class HelloWorld {
	static function main() {
		#if server
			// Initialise the app on the server and execute the request.
			var ufApp = new UfrontApplication({
				indexController: HelloWorldController,
				defaultLayout: "layout.html"
			});
			ufApp.executeRequest();
		#elseif client
			// Initialise the app on the client and respond to "pushstate" requests as a single-page-app.
			var clientApp = new ClientJsApplication({
				indexController: HelloWorldController,
				defaultLayout: "layout.html"
			});
			clientApp.listen();
		#end
	}
}

/**
This is a very basic controller, that responds to URL routes and returns a view.
See `www/views/` for the HTML views we are using, using the default `haxe.Template` templating engine.
**/
class HelloWorldController extends Controller {
	@:route("/$name")
	public function hello( ?name:String="World" ) {
		ufTrace( 'Hey $name, did you know we can trace directly to the browser console?' );
		return new ViewResult({ title:'Hello $name' });
	}

	@:route(GET,"/signup/newname/")
	public function newNameForm() {
		return new ViewResult({ title:"Custom name" });
	}

	@:route(POST,"/signup/newname/")
	public function submitNewName( args:{name:String} ):ActionResult {
		if ( args.name.length>0 ) {
			return new RedirectResult( '/${args.name}/' );
		}
		else {
			return new ViewResult({ title:"Custom name", error: "Please include your name" }, "newNameForm");
		}
	}
}
