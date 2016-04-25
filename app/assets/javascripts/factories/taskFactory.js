app.factory('taskFactory', ['$http', function($http){
	var factory = {};

	var tasks = [];

	factory.read = function(list_id, task_id) {
		return $http.get('/lists/' + list_id + '/tasks/' + task_id);
	};

	factory.update = function(list, task) {
		return $http.put('/lists/' + list.id + '/tasks/' + task.id, task);
	};

	factory.create = function(list, task) {
		return $http.post('/lists/' + list.id + '/tasks/', task);
	};

	factory.destroy = function(list, task) {
		return $http.delete('/lists/' + list.id + '/tasks/' + task.id);
	};

	factory.complete = function(list, task) {
		return $http.patch('/lists/' + list.id
						+ '/tasks/' + task.id
						+ '/complete', task);
	};

	factory.prioritize = function(list, task) {
		return $http.patch('/lists/' + list.id
						+ '/tasks/' + task.id
						+ '/prioritize', task);
	};

	return factory;
}]);