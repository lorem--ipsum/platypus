module.exports = function(config) {
  config.set({
    basePath: '.',

    files: [
      'bower_components/angular/angular.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'test/*.spec.coffee',
      'dist/platypus.min.js',
    ],

    coverageReporter: {
      type : 'text-summary',
      dir : '../coverage/'
    },

    reporters: ['dots', 'coverage'],

    autoWatch: true,

    browsers: ['PhantomJS'],

    preprocessors: {
      'test/*.spec.coffee': ['coffee'],
      'dist/platypus.min.js': ['coverage']
    },

    frameworks: ['jasmine']
  });
};
