angular.module('npp', ['apojop', 'platypus'])

.config(function config($routeProvider) {
  $routeProvider
    .when('/', {controller: 'DemoCtrl', templateUrl: 'views/main.html'})
    .otherwise({redirectTo: '/'});
})

.controller('DemoCtrl', function($scope, $filter) {
  var data = [];

  var update = function() {
    var result = platy(data, $scope.expression);
    $scope.users = result.data;
    $scope.error = result.error;
  };


  $scope.loading = true;
  d3.json('assets/data.json', function(error, _data_) {
    data = _data_;
    update();
    $scope.loading = false;
    $scope.$apply()
  });

  $scope.expression = ''

  platy = $filter("platypus")

  $scope.$watch('expression', update);

  $scope.examples = [
    'id is 7',
    'id is not 7',
    'firstname contains "la" or "al"',
    '(age is between 24 and 27 and gender is "female") or company contains "bw"'
  ];
});
