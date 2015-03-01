# A "Hello World" for Ufront [![Build Status](https://travis-ci.org/npretto/hello.svg?branch=master)](https://travis-ci.org/npretto/hello)

A simple example of ufront.

It's more than merely a hello world, it tries to show you a few different things ufront can do, but I've tried to keep it very small and very approachable.

Contributions welcome!

### Installation

	# Clone the repo
	git clone https://github.com/ufront/hello.git
	cd hello
	
	# Install all the required ufront libraries
	haxelib install all
	
	# Setup ufront shortcut
	haxelib run ufront --setup
	
	# Build both "server.hxml" and "tasks.hxml" (or shorter: `ufront b`)
	ufront build
	
	# You may need to create a database called "ufhelloworld" for a user called "ufhelloworld" and a password of "ufhelloworld".
	# Alternatively use your own settings and change src/conf/mysql.json
	
	# Run the tasks (or shorter: `ufront t`)
	ufront tasks
	
	# Setup our database tables
	ufront t --setup-tables
	
	# Create an admin user
	ufront t --create-admin-user jason mysecretpassword
	
	# Run a temporary server (Neko) (or shorter: `ufront s`)
	ufront server
	**or**
	cd www
	nekotools server -rewrite -p 8000 -h localhost -d ./
	
	# Run a temporary server (PHP)
	php -S localhost:2987

### Things to look out for

In the code:

- [src/app/api/SignupApi.hx](src/app/api/SignupApi.hx) - an API, this can be shared between the server, the CLI task runner, and the client (using remoting).
- [src/app/controller/HomeController.hx](src/app/controller/HomeController.hx) - our main controller.  Look out for:
	- How we `@inject` our APIs.
	- How we use `@:route()` to get functions (or sub controllers) to respond to certain URIs.
	- How we can listen to a GET or POST request for a certain route.
	- How each route returns an `ActionResult`, whether that's a `ViewResult`, a `ContentResult` or a `RedirectResult` etc.
	- How the `ViewResult` we return doesn't specify the view file to use.  We guess it based on the method name.
	- How we use `context.auth.requirePermission()` to require a user to be logged in and have a certain permission.
	- How we use `ufTrace` (or `ufLog`, `ufWarn` and `ufError`) to send a log message directly to the browser console (or the server logs). Normal `trace()` works if `-debug` is enabled.
- [src/app/model/Registration.hx](src/app/model/Registration.hx) - a simple model to show you how to save the database.  Look out for:
	- The way we use `sys.db.Types` typedefs to specify certain SQL column types.
	- The unique index we create for the table using metadata on the class.
	- How we specify validation on a field using metadata.  You won't be able to save an object if one of it's fields are invalid.
- [src/Config.hx](src/Config.hx) and [src/conf/*.json](src/conf/) - a quick, clean way to include configuration in your app.
- [src/Server.hx](src/Server.hx)- the starting point for our web app.  Look out for:
	- The kind of configuration options for we have for `UfrontApplication`. In particular we ask to use the `Erazor` templating engine with the "layout.html" default layout.
	- How we inject a `SMTPMailer` and `DBMailer` to be used for emailing people who subscribe. (Note the SMTPMailer is commented out by default).
	- We use `neko.Web.cacheModule` to speed things up on mod_neko.  Please note this can cause issues with the neko development server, so it's best to disable it in development by compiling with `-debug`.
	- The way we wrap each request in a `sys.db.Transaction` so that if errors are thrown the database is left in a good state.
- [src/Tasks.hx](src/Tasks.hx) - the starting point for our CLI tool.  Look out for:
	- All the scaffolding in `main()` to set up our tool, inject our things, and execute it.
	- How we inject things (setting up the injections in `main()`, and using them in our `UFTaskSet`).
	- How the comments, function names, and arguments automatically transform into a self-documented CLI app, thanks to the awesome MCLI library!
- [www/view/layout.html](www/view/layout.html) - the default layout for our website, using the `erazor` templating engine. Note the `@viewContent` variable where our main content goes.
- [www/view/home/](www/view/home/) - the folder for all our views in `HomeController`.  We guess the names based on the controller name (`HomeController` becomes `home/`) and the action name (`thankyou()` becomes `thankyou.html`).

When visiting the site:

- `http://localhost:2987/` - the default argument we use.
- `http://localhost:2987/Jason` - specifying our own argument.
- `http://localhost:2987/ufadmin` - log in to the admin panel!  If you haven't set up an admin account, anyone will be able to access this.  If you set one up (using `ufront t --create-admin-user`) then it will be limited to only you being able to log in.
- `http://localhost:2987/ufadmin/db` - this only works in Neko, but lets you sync changes in your models to the database. It's pretty clever, and will suffice until we have a full migration system.  It also adds unique indexes and constraints that `TableCreate.create()` misses.
- `http://localhost:2987/ufadmin/dbmailer` - look at the emails that have been sent out
- `http://localhost:2987/ufadmin/easyauth` - view users, change their passwords, and login as them.  More features coming soon!

### Support and Contributions

Please use the ufront versions specified in the `*.hxml` files.

Currently tested in Neko and PHP.  Very open to getting this compiling on other platforms.

Currently tested with Haxe 3.1.3, and the latest development version.  PHP Database interactions had a bunch of bug fixes in 3.2+, so keep that in mind.

Please report bugs here: <https://github.com/ufront/hello/issues>

If you have general Ufront support questions, post to Stack Overflow and tag the question `haxe`.

Pull requests and contributions welcome:

- For the code, if you have an improvement, or a bug fix.
- For the comments in the code - if something is confusing and could do with some comments to explain what is going on.
- For this README and/or any other documentation.

If anyone provides a good pull request and shows they're awesome, I'm happy to give commit access too!