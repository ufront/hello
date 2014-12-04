class Config {
	public static var app = CompileTime.parseJsonFile( 'conf/app.json' );
	
	#if server
		public static var mysql = CompileTime.parseJsonFile( 'conf/mysql.json' );
		public static var smtp = CompileTime.parseJsonFile( 'conf/smtp.json' );
	#end
}