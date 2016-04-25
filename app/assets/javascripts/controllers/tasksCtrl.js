app.controller('tasksCtrl', [
'$scope',
'$location',
'$timeout',
'$routeParams',
'taskFactory',
'listFactory',
'commentFactory',
function($scope, $location, $timeout, $routeParams, taskFactory, listFactory, commentFactory){
	$scope.list = {};
	$scope.task = {};
	$scope.errors = {};

	listFactory.read($routeParams.list_id)
	.then(
		function success(response) {
			$scope.list = response.data;
		},
		function error (response) {
			console.log(response);
			$location.path('/');
		}
	);

	
	taskFactory.read($routeParams.list_id, $routeParams.task_id)
	.then(
		function success(response) {
			$scope.task = response.data;
		},
		function error (response) {
			console.log(response);
			$location.path('/');
		}
	);

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

	$scope.addComment = function() {
		if(typeof $scope.comment === 'undefined') { return; };
		commentFactory.create($scope.task, $scope.comment)
		.then(
			function success(response) {
				$scope.task.comments.push(response.data);
				$scope.comment = null;
			},
			function error (response) {
				$scope.errors = response.data;
				console.log(response);
			}
		);
	};

	$scope.delComment = function(comment) {
		commentFactory.destroy($scope.task, comment)
		.then(
			function success(response) {
				var index = $scope.task.comments.indexOf(comment);
				$scope.task.comments.splice(index, 1);				
			},
			function error(response) {
				console.log(response);
			}
		);
	};

 	$scope.$on('$viewContentLoaded', function() {
 		$timeout(function(){
 			// Set DateTimePicker
	        $('#datetimepicker1').datetimepicker({
				format: "YYYY-MM-DD h:mm A"
			})
			.on('dp.change', function(event) {
                if ($('#datetimepicker1').data("DateTimePicker").date()) {
	                $scope.task.deadline_at = $('#datetimepicker1').data("DateTimePicker").date().toJSON();
	            } else {
	            	$scope.task.deadline_at = null;
	            }
	            $scope.$apply();
            });

			// Check file input size
            $('#comment_file input').bind('change', function() {
				var size_in_megabytes = this.files[0].size/1024/1024;
				if (size_in_megabytes > 1) {
					alert('Maximum file size is 1MB. Please choose a smaller file.');
				}
			});
        }, 0);
 	});
}]);