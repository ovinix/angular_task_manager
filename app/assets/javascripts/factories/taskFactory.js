app.factory('taskFactory', ['listFactory', function(listFactory){
	var factory = {};

	var tasks = [];

	factory.read = function(list_id, task_id) {
		// TODO
		list = listFactory.read(list_id);

		function findTasks(task) { 
		    return task.id == task_id;
		};

		return list.tasks.find(findTasks);
	};

	factory.update = function(task) {
		console.log('updateTask', task);
	};

	return factory;
}]);