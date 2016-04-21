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

app.directive('listView', ['$location', function($location) {
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
					// id: scope.list.tasks.length + 1,
					// list_id: scope.list.id,
					content: scope.newTaskContent
				});
				scope.newTaskContent = '';
			};

			scope.editTask = function(list, task){
				path = "list/" + list.id + "/task/" + task.id;
			    $location.path(path);
			};
		}
	};
}]);

app.directive('listTitle', [function() {
	return {
		restrict: 'A',
		scope: {
			fieldValue: '=',
			updateList: '&',
			deleteList: '&'
		},
		templateUrl: "_list-title.html",
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

app.directive('taskDeadline', [function() {
	return {
		restrict: 'A',
		scope: {
			deadline: '@',
			xs: '@'
		},
		templateUrl: '_task-deadline.html',
		link: function(scope, element, attrs) {
			scope.isFailed = function() {
				if (moment(scope.deadline) > moment.utc()) {
					return false;
				} else {
					return true;
				}
			};
		}
	};
}]);

app.directive('commentView', [function() {
	return {
		restrict: 'A',
		templateUrl: '_comment.html'
	};
}]);

app.directive('commentForm', [function() {
	return {
		restrict: 'A',
		templateUrl: '_comment-form.html'
	};
}]);