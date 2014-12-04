import app.tasks.*;
import app.api.*;
import mcli.Dispatch;
import ufront.api.UFApi;
import ufront.mailer.*;
import ufront.tasks.*;
import ufront.auth.*;
import ufront.auth.api.*;
import sys.db.*;
import Config;
import tasks.*;
using tink.CoreApi;

class Tasks extends UFTaskSet
{
	/**
		The scaffolding to setup and run our CLI task runner
	**/
	static function main() {
		// Only access the command line runner from the command line, not the web.
		if ( !neko.Web.isModNeko ) {
			Transaction.main( Mysql.connect(Config.mysql), function () {

				var tasks = new Tasks();

				// Inject our content directory in case we need to write to it.
				tasks.inject( String, "uf-content/", "contentDirectory" );

				// Inject our mailer, which sends SMTP and saves a copy of emails to the DB also.
				var smtpMailer = null; //new SMTPMailer( Config.smtp );
				var dbMailer = new DBMailer( smtpMailer );
				tasks.inject( UFMailer, dbMailer );

				// Inject our auth system. EasyAuthAdminMode is useful for CLI tools because it lets you do anything.
				var auth = new EasyAuth.EasyAuthAdminMode();
				tasks.inject( UFAuthHandler, auth );
				tasks.inject( EasyAuth, auth );
				
				// Inject all our APIs.
				for ( api in CompileTime.getAllClasses(UFApi) ) tasks.inject( api );

				// Use CLI logging, which prints both to a log file and to the CLI output.
				tasks.useCLILogging("logs/helloworld.log");

				// Execute the task runner
				tasks.execute( Sys.args() );
			});
		}
	}

	//
	// Now, the actual Tasks member vars and methods.
	// These can be executed from the command line thanks to the fantastic mcli library.
	//

	@inject @:skip public var easyAuthApi:EasyAuthApi;
	@inject @:skip public var signupApi:SignupApi;


	/**
		Task for setting up our database tables.
	**/
	public function setupTables() {
		// Include all the models, so none are DCE'd (we might need them at some point...)
		CompileTime.importPackage("app");
		var models = CompileTime.getAllClasses(ufront.db.Object);
		for ( model in models ) {
			var name = Type.getClassName( model );
			var manager:Manager<Object> = untyped model.manager;
			if ( TableCreate.exists(manager)==false ) {
				trace( 'Creating table $name');
				TableCreate.create(manager);
			}
			else trace( 'Skipping table $name - already exists' );
		}
	}

	/**
		Create an admin user.
	**/
	public function createAdminUser( username:String, pass:String ) {
		var user = easyAuthApi.createUser( username, pass ).sure();
		easyAuthApi.assignPermissionToUser( EasyAuthPermissions.EAPCanDoAnything, user.id );
		trace( 'Created new admin user $user' );
	}

	/**
		Add a new subscriber
	**/
	public function addSubscriber( name:String, email:String ) {
		signupApi.registerEmail( name, email );
		trace( 'Done, emails should be sent to $email and yourself...' );
	}

	/**
		List all of our subscriptions
	**/
	public function listSubscriptions() {
		var subscriptions = signupApi.listSignups();
		Sys.println( 'Found ${Lambda.count(subscriptions)}' );
		for ( name in subscriptions.keys() ) {
			Sys.println( '$name,${subscriptions[name]}' );
		}
	}
}
