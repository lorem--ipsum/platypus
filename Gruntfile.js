/*global module:false, require:false*/
module.exports = function(grunt) {
  'use strict';

  // Load Deps
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  // Travis doesn't have chrome, so we need to overwrite some options
  var testConfig = function(configFile, customOptions) {
    var options = { configFile: configFile, keepalive: true };
    var travisOptions = process.env.TRAVIS && { browsers: ['Firefox'], reporters: 'dots' };
    return grunt.util._.extend(options, customOptions, travisOptions);
  };

  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> Lorem Ipsum ' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',

    watch: {
      source: {
        files: ['src/*'],
        tasks: ['default']
      },

      test: {
        files: ['test/*'],
        tasks: ['karma']
      }
    },

    karma: {
      options: testConfig('karma.conf.js'),

      continuous: {
        singleRun: true,
        autoWatch: false,
        browsers: ['PhantomJS']
      }
    },

    peg: {
      grammar: {
        src: "src/grammar.peg",
        dest: ".tmp/grammar.js",
        options: {exportVar: "Peg.parser"}
      }
    },

    run: {
      percify: {
        cmd: 'tools/percify.sh',
        args: ['.tmp/grammar.js', '.tmp/ng-grammar.js', 'platypus.grammar']
      }
    },

    coffee: {
      compile: {
        files: {'.tmp/platy.js': ['src/*.coffee']}
      }
    },

    concat: {
      options: {banner: '<%= banner %>', stripBanners: true},
      js: {src: ['.tmp/ng-grammar.js', '.tmp/platy.js'], dest: 'dist/platypus.js'}
    },

    uglify: {
      options: {banner: '<%= banner %>'},
      js: {src: 'dist/platypus.js', dest: 'dist/platypus.min.js'}
    }
  });

  // Default task.
  grunt.registerTask('default', ['peg', 'run', 'coffee', 'concat', 'uglify', 'karma']);

  grunt.registerTask('fast-build', ['concat', 'uglify']);
  grunt.registerTask('coverage', ['concat', 'karma:unit']);
};
