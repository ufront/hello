import ufront.app.ClientJsApplication;
import ufront.view.TemplatingEngines;
import ufront.remoting.HttpAsyncConnection;
import ufront.remoting.HttpConnection;
import app.controller.*;

class Client {
	static var clientApp:ClientJsApplication;

	static function main() {

		clientApp = new ClientJsApplication({
			indexController: HomeController,
			templatingEngines: [TemplatingEngines.erazor],
			defaultLayout: "layout.html"
		});

		clientApp.listen();
	}
}
