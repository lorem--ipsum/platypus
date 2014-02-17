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

  d3.json('assets/data.json', function(error, _data_) {
    data = _data_;
    update();
    $scope.$apply()
  });

  $scope.expression = '(id is between 2 and 7 and gender is "male") or (id is between 6 and 10 and gender is not "male")'

  platy = $filter("platypus")

  $scope.$watch('expression', update);
});
