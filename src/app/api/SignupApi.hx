package app.api;

import ufront.api.*;
import app.model.Registration;
import ufront.mailer.UFMailer;
import ufront.mail.Email;
import ufront.mail.EmailAddress;
import app.Permissions;
using tink.CoreApi;
using StringTools;

class AsyncSignupApi extends UFAsyncApi<SignupApi> {}
class SignupApi extends UFApi {

	@inject public var mailer:UFMailer;

	public function registerEmail( name:String, email:String ):Int {
		email = email.trim();

		var reg = new Registration();
		reg.email = email;
		reg.name = name;
		reg.save();

		var msg = 'Hi $name, thanks for visiting our website! We will be in touch in 48 hours.';
		var email =
			new Email()
			.to( email )
			.cc( Config.app.contactEmail )
			.from( Config.app.contactEmail )
			.setSubject( 'Hello $name!' )
			.setHtml( '<p>$msg</p>' )
			.setText( msg )
		;
		mailer.sendSync( email ).sure();

		return reg.id;
	}

	public function listSignups():Map<String,String> {
		//auth.requirePermission( CanViewSubscriberList );
		var signups = new Map();
		for ( reg in Registration.manager.all() ) {
			var name = (reg.name!=null) ? reg.name : (reg.email:EmailAddress).username;
			signups[name] = reg.email;
		}
		return signups;
	}
}
