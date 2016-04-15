var app = angular.module('taskManager', ['ngRoute', 'templates']);

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

app.directive('listView', [function() {
	return {
		restrict: 'A',
		templateUrl: "_list.html",
		link: function(scope, element, attrs) {
			// scope.tasks = scope.$eval(attrs.tasks);
			// scope.tasks = JSON.parse(attrs.tasks);
			scope.newTaskContent = '';

			scope.addNewTask = function() {
				if (scope.newTaskContent === '') { return; }
				scope.addTask(scope.list, {
					id: scope.list.tasks.length + 1,
					list_id: scope.list.id,
					content: scope.newTaskContent
				});
				scope.newTaskContent = '';
			};
		}
	};
}]);

app.directive('listEditable', [function() {
	return {
		restrict: 'A',
		scope: {
			fieldValue: '=',
			updateList: '&',
			deleteList: '&'
		},
		templateUrl: "_editable-field.html",
		link: function(scope, element, attrs) {
			scope.editable = false;
			scope.copyFieldValue = '';

			scope.changeState = function() {
				scope.editable = !scope.editable;
				scope.copyFieldValue = scope.fieldValue;
			};

			scope.save = function() {
				scope.updateList();
				scope.changeState();
			};

			scope.cancel = function() {
				scope.fieldValue = scope.copyFieldValue;
				scope.changeState();
			};
		}
	};
}]);