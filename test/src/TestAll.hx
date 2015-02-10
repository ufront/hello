package;


// These imports are common for our various test-suite tools.
import buddy.*;
import mockatoo.Mockatoo.*;
using buddy.Should;
using ufront.test.TestUtils;
using mockatoo.Mockatoo;

@:build(buddy.GenerateMain.build(["app"]))
class TestAll {}