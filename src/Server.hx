import ufront.app.UfrontApplication;
import ufront.view.TemplatingEngines;
import app.controller.*;
import app.RemotingContext;
import ufront.mailer.*;
import sys.db.*;

class Server {
	static var ufApp:UfrontApplication;

	static function main() {

		ufApp = new UfrontApplication({
			indexController: HomeController,
			remotingApi: RemotingContext,
			templatingEngines: [TemplatingEngines.erazor],
			defaultLayout: "layout.html",
			logFile: "logs/helloworld.log"
		});

		var smtpMailer = null; // new SMTPMailer(Config.server.smtp);
		var dbMailer = new DBMailer( smtpMailer );
		ufApp.injectValue( UFMailer, dbMailer );

		// Execute the main request.
		run();

		// If we're on neko, and using the module cache, next time jump straight to the main request.
		#if (neko && !debug)
			neko.Web.cacheModule(run);
		#end
	}

	static function run() {
		var cnx = Mysql.connect( Config.mysql );
		Transaction.main( cnx, function () {
			ufApp.executeRequest();
		});
	}
}
