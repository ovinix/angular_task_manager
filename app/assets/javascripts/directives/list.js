app.directive('listView', ['$location', function($location) {
	return {
		restrict: 'A',
		templateUrl: "_list.html",
		link: function(scope, element, attrs) {
			scope.newTaskContent = '';

			scope.addNewTask = function() {
				if (scope.newTaskContent === '') { return; }
				scope.addTask(scope.list, {
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