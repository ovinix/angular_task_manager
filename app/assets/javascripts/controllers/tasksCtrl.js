app.controller('tasksCtrl', [
'$scope',
'$location',
'$timeout',
'$routeParams',
'taskFactory',
'listFactory',
function($scope, $location, $timeout, $routeParams, taskFactory, listFactory){
	$scope.list = {};

	listFactory.read($routeParams.list_id)
	.then(
		function success(response) {
			$scope.list = response.data;
			console.log('List read', response);
			if (!isDTPinit) {
				initDateTimePicker();
			};
		},
		function error (response) {
			console.log(response);
			$location.path('/');
		}
	);

	$scope.task = {};
	taskFactory.read($routeParams.list_id, $routeParams.task_id)
	.then(
		function success(response) {
			$scope.task = response.data;
			console.log('Task read', response);
			if (!isDTPinit) {
				initDateTimePicker();
			};
		},
		function error (response) {
			console.log(response);
			$location.path('/');
		}
	);

	var isDTPinit = false;
	initDateTimePicker = function() {
		isDTPinit = true;
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
	};

	$scope.updTask = function() {
		if ($scope.task.done) {
			$scope.task.completed_at = moment.utc().toJSON();
		}
		else {
			$scope.task.completed_at = null;
		}
		taskFactory.update($scope.list, $scope.task)
		.then(
			function success(response) {
				$location.path('/');
			},
			function error (response) {
				$location.path('/');
			}
		);
		
	};

 	// $scope.$on('$viewContentLoaded', function() {
 	// 	$timeout(function(){
	 //        $('#datetimepicker1').datetimepicker({
		// 		format: "YYYY-MM-DD h:mm A"
		// 	})
		// 	.on('dp.change', function(event) {
  //               console.log('time changed!');
  //               console.log($('#deadline_at').val());
  //               if ($('#datetimepicker1').data("DateTimePicker").date()) {
	 //                console.log($('#datetimepicker1').data("DateTimePicker").date().toJSON());
	 //                $scope.task.deadline_at = $('#datetimepicker1').data("DateTimePicker").date().toJSON();
	 //            } else {
	 //            	$scope.task.deadline_at = null;
	 //            }
	 //            $scope.$apply();
  //           });
  //       }, 0);
 	// });
}]);