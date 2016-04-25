var app = angular.module('taskManager', ['ngRoute', 'templates', 'ngFileUpload', 'bootstrap.fileField']);

app.config(['$routeProvider',function($routeProvider) {
	$routeProvider
		.when('/', {
			templateUrl: '_lists.html',
			controller: 'listsCtrl'
		})
		.when('/list/:list_id/task/:task_id', {
			templateUrl: '_task.html',
			controller: 'tasksCtrl'
		})
		.otherwise({redirectTo: '/'});
}]);

app.filter('fromNow', ['$filter', function($filter) {
	return function(date) {
		if (moment.utc().diff(moment(date), 'days') < 7) {
			return moment(date).fromNow();
		} else {
			return $filter('date')(date, 'yyyy-MM-dd hh:mm a');
		}
	};
}]);