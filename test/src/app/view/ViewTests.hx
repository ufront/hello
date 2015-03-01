package app.view;

import buddy.*;
import ufront.view.*;
import ufront.view.TemplatingEngines.erazor;
using buddy.Should;
using Detox;

class ViewTests extends BuddySuite {

	var viewEngine:FileViewEngine;

	public function new() {

		viewEngine = new FileViewEngine();
		viewEngine.scriptDir = Sys.getCwd();
		viewEngine.path = "www/view/";


		describe("When rendering the layout", {
			it("should show insert the view and the title in the layout", function (done) {
				var data = {
					title: "Hello Haxe!",
					viewContent: "<div id='test'>Content</div>"
				}
				function test( page:DOMCollection ) {
					page.find( "title" ).text().should.be( "Hello Haxe!" );
					page.find( ".container #test" ).text().should.be( "Content" );
					page.find( ".container #test" ).attr( "id" ).should.be( "test" );
				}
				testTemplate( "layout.html", data, test, done );
			});
			it("should show insert the title in the homepage view", function (done) {
				var data = { title: "Hello Haxe!" }
				function test( page:DOMCollection ) {
					page.find( "h1" ).text().should.be( "Hello Haxe!" );
				}
				testTemplate( "home/homepage.html", data, test, done );
			});
			it("should show insert the title in the thank-you view", function (done) {
				var data = { title: "Hello Haxe!" }
				function test( page:DOMCollection ) {
					page.find( "h1" ).text().should.be( "Hello Haxe!" );
				}
				testTemplate( "home/thankyou.html", data, test, done );
			});
		});
	}

	// TODO: consider creating a ufront test helper that does just this.
	// It might be better to test it as part of the whole app, combined with controller execute.
	// It could test that the right view, right layout is called, and optionally, a function that gives the string output so you can interact with it.
	function testTemplate( path:String, data:TemplateData, test:DOMCollection->Void, done:?Bool->Void ) {
		viewEngine.getTemplateString( path ).handle(function (result) {
			switch result {
				case Success(Some(templateStr)):
					var template = erazor.factory( templateStr );
					var output = template.execute( data );
					var page = output.parse();
					test( page );
					done();
				case _:
					fail( 'Failed to retrieve template $path' );
					done();
			};
		});
	}
}
