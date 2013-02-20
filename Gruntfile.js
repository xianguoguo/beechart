module.exports = function( grunt ) {

	"use strict";

	var distpaths = [
			"dist/jquery.js",
			"dist/jquery.min.map",
			"dist/jquery.min.js"
		],
		readOptionalJSON = function( filepath ) {
			var data = {};
			try {
				data = grunt.file.readJSON( filepath );
			} catch(e) {}
			return data;
		};

	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),
		dst: readOptionalJSON("dist/.destination.json"),
		jade: {
	      debug: {
	        options: {
	          pretty: true
	        },
	        files: {
	          "index.html": "jade/index.jade",
	          "doc.html": "jade/doc.jade",
	          "demo.html": "jade/demo.jade",
	          "about.html": "jade/about.jade",
	          "bar-demo.html": "jade/bar-demo.jade",
	          "line-demo.html": "jade/line-demo.jade",
	          "pie-demo.html": "jade/pie-demo.jade",
	          "time-demo.html": "jade/time-demo.jade",
	          "charteditor.html": "jade/charteditor.jade",
	        }
	      }
	    },
	    stylus: {
	      compile: {
	        options: {
	          compress: false
	        },
	        files: {
	          'css/about.css': 'styl/about.styl',
	          'css/anythingslider.css': 'styl/anythingslider.styl',
	          'css/common.css': 'styl/common.styl',
	          'css/demo.css': 'styl/demo.styl',
	          'css/doc.css': 'styl/doc.styl',
	          'css/public.css': 'styl/public.styl',
	          'css/reset.css': 'styl/reset.styl',
	          'css/sons-of-obsidian.css': 'styl/sons-of-obsidian.styl',
	          'css/index.css': 'styl/index.styl',
	          'css/yid-chart-demo.css': 'styl/yid-chart-demo.styl',
	          'css/yid-chart-demo-merge.css': 'styl/yid-chart-demo-merge.styl'
	        }
	      }
	    },
	    connect:{
	 		server: {
	 			options:{
	 				port: 80,
		      		base: '.'
	 			}
		    }
	    },
		uglify: {
			all: {
				files: {
					"dist/yid-chart-demo-merge.js": [
									   "js/fdev-min.js",
									   "js/widget-min.js",
									   "js/flash-min.js",
									   "js/flash-chart-min.js",
									   "js/jquery.easing.1.2.js",
									   "js/jquery.anythingslider.js",
									   "js/yid-chart-demo.js"],
				    "dist/index-merge.js": [
									   "js/fdev-min.js",
									   "js/header-currentset.js",
									   "js/slider-nav-create.js"],
				    "dist/doc-merge.js": [
									   "js/google-code-prettify/prettify.js",
									   "js/google-code-prettify/lang-css.js",
									   "js/beechart/flash.js"]

				},
				options: {
					 // sourceMap: "dist/yid-chart-demo-merge.map",
					 // beautify: true,
					 // compress: false,
					 // mangle: false
				}
			}
		},
		watch: {
	      jade: {
	        files: ['jade/*.jade','jade/**/*.jade'],
	        tasks: 'jade'
	      },
	      stylus: {
	        files: ['styl/*.styl'],
	        tasks: 'stylus'
	      },
	      uglify: {
	        files: ["js/*.js","js/**/*.js"],
	        tasks: 'uglify'
	      }
	    }
	});
	// Load grunt tasks from NPM packages
	grunt.loadNpmTasks("grunt-compare-size");
	grunt.loadNpmTasks("grunt-contrib-uglify");
	grunt.loadNpmTasks("grunt-contrib-watch");
	grunt.loadNpmTasks("grunt-contrib-jade");
	grunt.loadNpmTasks("grunt-contrib-stylus");
	grunt.loadNpmTasks("grunt-contrib-connect");
	grunt.loadNpmTasks("grunt-contrib-mincss");

	// Default grunt
	// grunt.registerTask( "default", ["mincss"] );
	grunt.registerTask( "default", ["uglify", "jade", "stylus", "connect", "watch"] );

	// Short list as a high frequency watch task
	// grunt.registerTask( "dev", [ "selector", "build:*:*", "jshint" ] );
};
