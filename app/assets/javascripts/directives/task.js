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