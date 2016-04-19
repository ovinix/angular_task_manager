app.controller('listsCtrl', [
'$scope',
'listFactory',
'taskFactory',
function($scope, listFactory, taskFactory){
	$scope.lists = [];
	$scope.newListTitle = '';

	$scope.getLists = function() {
		listFactory.query()
		.then(
			function success (response) {
				console.log(response);
				$scope.lists = response.data;
			},
			function error (response) {
				console.log(response);
			}
		);
	};

	$scope.getLists();

	$scope.addList = function() {
		if ($scope.newListTitle === '') { return; }
		listFactory.create({
			title: $scope.newListTitle
		}).then(
			function success(response) {
				$scope.lists.push(response.data);
				console.log(response);
			},
			function error (response) {
				console.log(response);
			}
		);
		$scope.newListTitle = '';
	};

	$scope.delList = function(list) {
		listFactory.destroy(list)
		.then(
			function success(response) {
				var index = $scope.lists.indexOf(list);
				$scope.lists.splice(index, 1);
				console.log('delList success', response);
			},
			function error (response) {
				console.log(response);
			}
		);
	};

	$scope.updList = function(list) {
		listFactory.update(list)
		.then(
			function success(response) {
				console.log('update', response);
			},
			function error (response) {
				console.log(response);
			}
		);
	};

	$scope.addTask = function(list, task) {
		taskFactory.create(list, task)
		.then(
			function success(response) {
				list.tasks.push(response.data);
			},
			function error (response) {
				console.log(response);
			}
		);
	};

	$scope.delTask = function(list, task) {
		taskFactory.destroy(list, task)
		.then(
			function success(response) {
				var index = list.tasks.indexOf(task);
				list.tasks.splice(index, 1);
			},
			function error (response) {
				console.log(response);
			}
		);
	};

	$scope.cmpltTask = function(list, task) {
		taskFactory.complete(list, task)
		.then(
			function success(response) {
				$scope.getLists();
				console.log('completed', response);

			},
			function error (response) {
				console.log(response);
			}
		);
	};

	$scope.prtzTask = function(list, task) {
		taskFactory.prioritize(list, task)
		.then(
			function success(response) {
				$scope.getLists();
				console.log('priority changed', response);

			},
			function error (response) {
				console.log(response);
			}
		);
	};
}]);