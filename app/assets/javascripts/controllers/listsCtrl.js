app.controller('listsCtrl', ['$scope', 'listFactory', function($scope, listFactory){
	$scope.lists = listFactory.query();

	$scope.newListTitle = '';

	$scope.addList = function() {
		if ($scope.newListTitle === '') { return; }
		listFactory.create({
			id: $scope.lists.length + 1,
			title: $scope.newListTitle,
			tasks: []
		});
		$scope.newListTitle = '';
	};

	$scope.delList = function(list) {
		listFactory.destroy(list);
	};

	$scope.updList = function(list) {
		listFactory.update(list);
	};

	$scope.addTask = function(list, task) {
		listFactory.createTask(list, task);
	};

	$scope.delTask = function(list, task) {
		listFactory.destroyTask(list, task);
	};

	$scope.cmpltTask = function(list, task) {
		listFactory.completeTask(list, task);
	};

	$scope.prtzTask = function(list, task) {
		listFactory.prioritizeTask(list, task);
	};
}]);