# A "Hello World" for Ufront [![Build Status](https://travis-ci.org/npretto/hello.svg?branch=master)](https://travis-ci.org/npretto/hello)

A simple example of Ufront running on the client and the server.

For help understanding the example, you can ask our community on one of our [community channels](http://ufront.net/community/) like [gitter](http://gitter.im/ufront/ufront).

This example is intentionally small, it shows off:

- Setting up an app to run on both the server and the client.
- Using a controller to respond to link clicks and form submits.
- Returning a ViewResult using the built in `haxe.Template` templating system.

There's obviously a lot more to Ufront, but this is supposed to be a very simple example.

### Viewing it online

We'll try make the example viewable online soon.

### Installation

	# Clone the repo
	git clone https://github.com/ufront/hello.git
	cd hello

	# Install all the required ufront libraries
	haxelib install all

	# Setup ufront shortcut
	haxelib run ufront --setup

	# Build both "server.hxml" and "client.hxml"
	ufront build    # Or shorter, `ufront b`

	# To test neko, run a temporary server:
	ufront server    # Or shorter, `ufront s`

	# Run a temporary server (PHP)
	cd www
	php -S localhost:2987

### Support

This has been tested and works server side with:

* PHP
* Neko

And client side with JS.

All testing is done with Haxe 3.2.

Please report bugs here: <https://github.com/ufront/hello/issues>

If you have general Ufront support questions, post to Stack Overflow and tag the question `ufront`.

### Contributions

Pull requests and contributions welcome:

- For the code, if you have an improvement, or a bug fix.
- For the comments in the code - if something is confusing and could do with some comments to explain what is going on.
- For this README and/or any other documentation.

If anyone provides a good pull request and shows they're trustworthy, I'm happy to give commit access too!
