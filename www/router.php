<?php
	// If you are using the `php -S` development server, this file sets up URL rewriting, mod-rewrite style.
	// If you're not using the PHP development server, you can delete this file.
	if (file_exists(__DIR__ . '/' . $_SERVER['REQUEST_URI'])) {
		return false; // serve the requested resource as-is.
	} else {
		include_once 'index.php';
	}
?>
