package app.model;

import buddy.*;
using buddy.Should;

class RegistrationTest extends BuddySuite {
	public function new() {
		describe("When visiting the homepage", {
			it("should validate correctly", {
				var reg1 = new Registration();
				reg1.name = "Jason";
				reg1.email = "jo@ufront.net";
				reg1.validate().should.be(true);

				var reg2 = new Registration();
				reg2.name = null;
				reg2.email = "null@ufront.net";
				reg2.validate().should.be(true);
			});

			it("should invalidate correctly", {
				var reg3 = new Registration();
				reg3.name = "Jason";
				reg3.email = "J@";
				reg3.validate().should.be(false);
				reg3.validationErrors.toString().should.be("Please enter a valid email");
			});
		});
	}
}