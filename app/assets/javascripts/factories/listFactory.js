app.factory('listFactory', ['$http',function($http){
	var factory = {};

	factory.query = function() {
		return $http.get('/lists');
	};

	factory.read = function(list_id) {
		return $http.get('/lists/' + list_id);
	};

	factory.create = function(list) {
		return $http.post('/lists', list);
	};

	factory.destroy = function(list) {
		return $http.delete('/lists/' + list.id);
	};

	factory.update = function(list) {
		return $http.put('/lists/' + list.id, list);
	};

	return factory;
}]);