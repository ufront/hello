package;

// These imports are specific to this test suite.
import app.api.*;
import app.controller.*;
import ufront.ufadmin.controller.*;
import ufront.mailer.*;
import ufront.auth.EasyAuth;
import minject.Injector;
import ufront.app.UfrontApplication;

// These imports are common for our various test-suite tools.
import buddy.*;
import mockatoo.Mockatoo.*;
using buddy.Should;
using ufront.test.TestUtils;
using mockatoo.Mockatoo;

@:build(buddy.GenerateMain.build(["app"]))
class TestAll extends BuddySuite {

	public static function getTestApp() {
		var ufApp = new UfrontApplication({
			indexController: HomeController,
			errorHandlers: [],
			disableBrowserTrace: true,
			templatingEngines: [ufront.view.TemplatingEngines.erazor],
			defaultLayout: "layout.html",
			viewPath: "www/view/"
		});
		ufApp.inject( UFMailer, TestMailer );
		ufApp.inject( SignupApi, new MockSignupApi() );
		ufApp.inject( EasyAuth, new EasyAuthAdminMode() );
		return ufApp;
	}

	public function new() {
		describe("When visiting the site", {

			var ufApp = getTestApp();

			it("should not give us 404s", {
				"/"
					.mockHttpContext()
					.testRoute( ufApp )
					.assertSuccess( HomeController, "homepage", ["World"]);
				"/Jason"
					.mockHttpContext()
					.testRoute( ufApp )
					.assertSuccess( HomeController, "homepage", ["Jason"]);
				"/ufadmin"
					.mockHttpContext()
					.testRoute( ufApp )
					.assertSuccess( UFAdminHomeController );
				"/subscribe"
					.mockHttpContext( "POST", [ "name"=>"Jason", "email"=>"jjjj@ufront.net", ] )
					.testRoute( ufApp )
					.assertSuccess( HomeController, "signup", [{name:"Jason",email:"jjjj@ufront.net"}] );
				"/thank/Anna"
					.mockHttpContext()
					.testRoute( ufApp )
					.assertSuccess( HomeController, "thankyou", ["Anna"]);
				"/subscribers/list.csv"
					.mockHttpContext()
					.testRoute( ufApp )
					.assertSuccess( HomeController, "listSubscribers", []);
			});
		});
	}
}

// TODO: Our UFApi macros and the Mockatoo macros are clashing, so we can't do `mock(SignupApi)` at the moment.
class MockSignupApi extends SignupApi {
	public var entries:Map<String,String> = new Map();

	public function registerEmail( name:String, email:String ):Void {
		if ( name==null )
			name = "";
		entries[name] = email;
	}

	public function listSignups():Map<String,String> {
		return entries;
	}
}