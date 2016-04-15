app.controller('tasksCtrl', [
'$scope',
'$location',
'$timeout',
'$routeParams',
'taskFactory',
'listFactory',
function($scope, $location, $timeout, $routeParams, taskFactory, listFactory){
	$scope.list = listFactory.read($routeParams.list_id);
	if (typeof $scope.list === 'undefined' ) {
		$location.path('/');
		return;
	}

	$scope.originalTask = taskFactory.read($routeParams.list_id, $routeParams.task_id);
	if (typeof $scope.originalTask === 'undefined' ) {
		$location.path('/');
		return;
	}
	$scope.task = angular.copy($scope.originalTask);

	$scope.updTask = function() {
		angular.copy($scope.task, $scope.originalTask);
		taskFactory.update($scope.task);
		$location.path('/');
	};

 	$scope.$on('$viewContentLoaded', function() {
 		$timeout(function(){
	        $('#datetimepicker1').datetimepicker({
				format: "YYYY-MM-DD h:mm A"
			})
			.on('dp.change', function(event) {
                console.log('time changed!');
                console.log($('#deadline_at').val());
                if ($('#datetimepicker1').data("DateTimePicker").date()) {
	                console.log($('#datetimepicker1').data("DateTimePicker").date().toJSON());
	                $scope.task.deadline_at = $('#datetimepicker1').data("DateTimePicker").date().toJSON();
	            } else {
	            	$scope.task.deadline_at = null;
	            }
	            $scope.$apply();
            });
        }, 0);
 	});
}]);