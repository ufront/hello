package app.controller;

import TestAll.MockSignupApi;
import ufront.web.result.*;
import ufront.auth.*;
import app.Permissions;

// These imports are common for our various test-suite tools.
import buddy.*;
import mockatoo.Mockatoo.*;
using buddy.Should;
using ufront.test.TestUtils;
using mockatoo.Mockatoo;

class HomeControllerTest extends BuddySuite {
	public function new() {

		var ufApp = TestAll.getTestApp();

		var controller = new HomeController();
		controller.signupApi = new MockSignupApi();
		@:privateAccess controller.context = "/".mockHttpContext();

		describe("When visiting the homepage", {

			it("should say Hello World", {
				var result = controller.homepage();
				var title:String = result.data['title'];
				title.should.be("Hello World");
			});
			it("should set the title", {
				var result = controller.homepage("Jason");
				var title:String = result.data['title'];
				title.should.be("Hello Jason");
			});
			it("should use the correct view and layout", function (done) {
				"/"
					.mockHttpContext()
					.testRoute( ufApp )
					.assertSuccess()
					.checkResult( ViewResult, function(vr:ViewResult) {
						// TODO: check that we have the correct ViewPath and Layout.
						// Currently, this information happens in vr.execute(), but is not recorded.
						done();
					});
			});
		});

		describe("When a user subscribes", {
			var result = controller.signup({ name:"Jason", email:"jjjj@ufront.net" });
			var result2 = controller.signup({ name:null, email:"aaaa@ufront.net" });
			it("should use the API to process their subscription", {
				// TODO: when we're using a real mock object we can count method calls easier.
				var numTimesAPICalled = Lambda.count( untyped controller.signupApi.entries );
				numTimesAPICalled.should.be( 2 );
			});
			it("should return a redirect result to the thank you page", {
				result.url.should.be( "/thank/Jason" );
				result2.url.should.be( "/thank/null" );
				result.permanentRedirect.should.be( false );
			});
		});

		describe("When a user lands on the thank you page", {
			it("should use the correct view and layout", {
				var result = controller.thankyou("Jason");
				var title:String = result.data['title'];
				title.should.be("Thanks Jason!");

				var result2 = controller.thankyou();
				var title:String = result2.data['title'];
				title.should.be("Thanks World!");
			});
		});


		describe("When you try to view the subscriber list", {
			it("should generate a text/CSV result", {
				var result = controller.listSubscribers();
				result.contentType.should.be( "text/csv" );
				var lines = result.content.split("\n");
				lines.length.should.be( 2 );
				lines[0].should.be("Jason,jjjj@ufront.net");
				lines[1].should.be(",aaaa@ufront.net");
			});
			it("should still work if we have zero users", {
				controller.signupApi = new MockSignupApi();
				var result = controller.listSubscribers();
				result.content.length.should.be( 0 );
			});
			it("should throw an error if you don't have permission", {
				@:privateAccess controller.context.auth = new NobodyAuthHandler();
				try {
					// TODO: Submit feature request for Buddy to support Enums in throwType and throwValue.
					controller.listSubscribers();
					fail( "Should have thrown an AuthError.NoPermission(CanViewSubscriberList)");
				}
				catch ( e:AuthError ) {
					Type.enumEq( e, AuthError.NoPermission(CanViewSubscriberList) ).should.be( true );
				}
			});
		});
	}
}