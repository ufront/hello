# A Clean, Blazing-Fast "Hello World" for Ufront [![Build Status](https://travis-ci.org/ufront/hello.svg?branch=master)](https://travis-ci.org/ufront/hello)

A simple example of Ufront running on the client and the server.

If you are unable to understand the example, please feel free to ask our community on one of our [community channels](http://ufront.net/community/) like [gitter](http://gitter.im/ufront/ufront).

Our example is intentionally small. It exists in order to display the process of:

- Setting up an app to run on both the server and the client.
- Using a controller to respond to link clicks and form submits.
- Returning a ViewResult using the built in `haxe.Template` templating system.

There's obviously a lot more to Ufront, but this is supposed to be a very simple example. For more comprehensive guides, you can visit the [ufront-nodejs-guide](https://github.com/kevinresol/ufront-nodejs-guide/)

### Viewing it online

We'll try make the example viewable online soon.

### Installation

Currently you need to use the development version of haxelib, so these instructions are a little longer than normal.
This will be simplified when we release a new haxelib version.


	# Install the Ufront libraries and dependencies
	haxelib install ufront
	haxelib install ufront-client

	# Clone and set up the development version of Ufront
	git clone --recursive https://github.com/ufront/ufront.git
	cd ufront
	./setupDev

	# Setup ufront shortcut
	haxelib run ufront --setup

	# Build both "server.hxml" and "client.hxml"
	cd submodules/hello
	ufront build            # Or shorter, `ufront b`

	# To test neko, run a temporary server:
	ufront server           # Or shorter, `ufront s`

	# Run a temporary server (PHP)
	cd www
	php -S localhost:2987

	# To run the NodeJS server:
	cd www
	node server.js

### Support

This has been tested and works server side with:

* Server-side:
	* PHP
	* Neko
	* JS (Node)
* Client-side:
	* JS (Browser)

All testing is done with Haxe 3.2.

Please report bugs here: <https://github.com/ufront/hello/issues>

If you have general Ufront support questions, post to Stack Overflow and tag the question `ufront`.

### Contributions

Pull requests and contributions welcome:

- For the code, if you have an improvement, or a bug fix.
- For the comments in the code - if something is confusing and could do with some comments to explain what is going on.
- For this README and/or any other documentation.

If anyone provides a good pull request and shows they're trustworthy, I'm happy to give commit access too!

hail satan
