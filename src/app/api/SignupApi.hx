package app.api;

import ufront.api.UFApi;
import app.model.Registration;
import ufront.mailer.UFMailer;
import ufront.mail.Email;
using tink.CoreApi;
using StringTools;

class SignupApi extends UFApi {
	
	@inject public var mailer:UFMailer;
	
	public function registerEmail( name:String, email:String ):Void {
		var reg = new Registration();
		reg.email = email;
		reg.name = name;
		reg.save();
		
		email = email.trim();
		
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
	}
	
	public function listSignups():Map<String,String> {
		return [for ( reg in Registration.manager.all() ) reg.name=>reg.email];
	}
}