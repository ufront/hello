package app.api;

import buddy.*;
import sys.db.*;
import app.api.SignupApi;
import app.model.Registration;
import ufront.mailer.TestMailer;
import sys.FileSystem;
using buddy.Should;

class SignupApiTest extends BuddySuite {
	public function new() {
		describe("When users sign up", {

			var api:SignupApi;
			var testMailer:TestMailer;
			var file = 'testdb.sqlite';

			before({
				// Set up a database to use
				if ( FileSystem.exists(file) )
					FileSystem.deleteFile( file );
				Manager.cnx = Sqlite.open( file );
				TableCreate.create( Registration.manager );

				// Set up the API object
				api = new SignupApi();
				testMailer = new TestMailer();
				api.mailer = testMailer;
			});

			it("Should record it to the database and send an email", {
				api.registerEmail( "Jason", "jjjj@ufront.net" );
				testMailer.messagesSent.length.should.be( 1 );
				testMailer.messagesSent[0].toList.first().email.should.be( "jjjj@ufront.net" );
				testMailer.messagesSent[0].ccList.first().email.should.be( Config.app.contactEmail );
				var registrations = Registration.manager.all();
				registrations.length.should.be( 1 );
				registrations.first().name.should.be( "Jason" );
				registrations.first().email.should.be( "jjjj@ufront.net" );
			});
			it("Should return an accurate list of sugnups", {
				api.registerEmail( "Jason", "jjjj@ufront.net" );
				api.registerEmail( "Anna", "aaaa@ufront.net" );
				api.registerEmail( null, "no-reply@ufront.net" );
				var signups = api.listSignups();
				Lambda.count( signups ).should.be( 3 );
				signups["Jason"].should.be( "jjjj@ufront.net" );
				signups["Anna"].should.be( "aaaa@ufront.net" );
				signups["no-reply"].should.be( "no-reply@ufront.net" );
			});

			after({
				if ( FileSystem.exists(file) )
					FileSystem.deleteFile( file );
			});
		});
	}
}