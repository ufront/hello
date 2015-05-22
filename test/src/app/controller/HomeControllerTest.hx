package app.controller;

// These imports are specific to this test suite.
import app.api.*;
import app.controller.*;
import ufront.mailer.*;
import minject.Injector;
import ufront.app.UfrontApplication;
import ufront.web.result.ViewResult;
import ufront.web.result.RedirectResult;
import ufront.web.result.ContentResult;
import ufront.ufadmin.controller.*;
import ufront.auth.*;
import ufront.auth.EasyAuth;
import app.Permissions;

// These imports are common for our various test-suite tools.
import buddy.*;
import mockatoo.Mockatoo.*;
import ufront.test.TestUtils.NaturalLanguageTests.*;
import utest.Assert;
using buddy.Should;
using ufront.test.TestUtils;

class HomeControllerTest extends BuddySuite {
	public function new() {

		var ufApp = new UfrontApplication({
			indexController: HomeController,
			errorHandlers: [],
			disableBrowserTrace: true,
			templatingEngines: [ufront.view.TemplatingEngines.erazor],
			defaultLayout: "layout.html",
			viewPath: "www/view/"
		});
		ufApp.injectClass( UFMailer, TestMailer );
		ufApp.injectValue( SignupApi, new MockSignupApi() );
		ufApp.injectValue( EasyAuth, new EasyAuthAdminMode() );

		describe("When visiting the homepage", {

			it("should say Hello World", function(done) {
				whenIVisit( "/" )
					.onTheApp( ufApp )
					.itShouldLoad( HomeController, "homepage", ["World"] )
					.itShouldReturn( ViewResult, function (result) {
						var title:String = result.data['title'];
						title.should.be("Hello World");
						Assert.same( result.templateSource, FromEngine("home/homepage") );
						Assert.same( result.layoutSource, FromEngine("layout.html") );
					})
					.andFinishWith( done );
			});
			it("should set the title", function (done) {
				whenIVisit( "/Jason" )
					.onTheApp( ufApp )
					.itShouldLoad()
					.itShouldReturn( ViewResult, function(result:ViewResult) {
						var title:String = result.data['title'];
						title.should.be("Hello Jason");
					})
					.andFinishWith( done );
			});
		});

		describe("When a user subscribes", {
			it("should use the API to process their subscription and return a redirect", function (done) {
				var mockApi = new MockSignupApi();
				whenIVisit( "/subscribe", "POST", [ "name"=>"Jason", "email"=>"jjjj@ufront.net"] )
					.andInjectAValue( SignupApi, mockApi )
					.onTheApp( ufApp )
					.itShouldLoad( HomeController, "signup" )
					.itShouldReturn( RedirectResult, function(result) {
						result.url.should.be( "/thank/Jason" );
						result.permanentRedirect.should.be( false );
						// TODO: when we're using a real mock object we can count method calls easier.
						var numTimesAPICalled = Lambda.count( mockApi.entries );
						numTimesAPICalled.should.be( 1 );
					})
					.andFinishWith( done );
			});
			it("redirect to /thank/World if no name was given", function (done) {
				whenIVisit( "/subscribe", "POST", [ "name"=>"", "email"=>"aaaa@ufront.net" ] )
					.onTheApp( ufApp )
					.itShouldLoad( HomeController, "signup" )
					.itShouldReturn( RedirectResult, function(result) {
						result.url.should.be( "/thank/World" );
					})
					.andFinishWith( done );
			});
		});

		describe("When a user lands on the thank you page", {
			it("should show their name", function (done) {
				whenIVisit( "/thank/Nicolò" )
					.onTheApp( ufApp )
					.itShouldLoad( HomeController, "thankyou", ["Nicolò"] )
					.itShouldReturn( ViewResult, function(result) {
						var title:String = result.data['title'];
						title.should.be("Thanks Nicolò!");
						Assert.same( result.templateSource, FromEngine("home/thankyou") );
					})
					.andFinishWith( done );
			});
		});


		describe("When you try to view the subscriber list", {
			it("should generate a text/CSV result", function (done) {
				var mockApi = new MockSignupApi();
				mockApi.entries = [
					"Jason"=>"jjjj@ufront.net",
					""=>"aaaa@ufront.net",
				];
				whenIVisit( "/subscribers/list.csv" )
					.andInjectAValue( SignupApi, mockApi )
					.onTheApp( ufApp )
					.itShouldLoad( HomeController, "listSubscribers", [] )
					.itShouldReturn( ContentResult, function(result) {
						result.contentType.should.be( "text/csv" );
						var lines = result.content.split("\n");
						lines.length.should.be( 2 );
						lines[0].should.be("Jason,jjjj@ufront.net");
						lines[1].should.be(",aaaa@ufront.net");
					})
					.andFinishWith( done );
			});
			it("should still work if we have zero users", function(done) {
				var mockApi = new MockSignupApi();
				whenIVisit( "/subscribers/list.csv" )
					.andInjectAValue( SignupApi, mockApi )
					.onTheApp( ufApp )
					.itShouldLoad( HomeController, "listSubscribers", [] )
					.itShouldReturn( ContentResult, function(result) {
						result.content.length.should.be( 0 );
					})
					.andFinishWith( done );
			});
			it("should throw an error if you don't have permission", function(done) {
				whenIVisit( "/subscribers/list.csv" )
					.withTheAuthHandler( new NobodyAuthHandler() ) // pretend we don't have any permission.
					.onTheApp( ufApp )
					.itShouldFailWith( 500, AuthError.NoPermission(CanViewSubscriberList) )
					.andFinishWith( done );
			});
		});

		describe("When I want to have supreme authority", {
			it("should let me access UFAdmin", function(done) {
				whenIVisit( "/ufadmin" )
				.onTheApp( ufApp )
				.itShouldLoad( UFAdminHomeController )
				.andFinishWith( done );
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
