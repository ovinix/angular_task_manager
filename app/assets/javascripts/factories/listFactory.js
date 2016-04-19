app.factory('listFactory', ['$http',function($http){
	var factory = {};

	// var lists = [
	// 	{	id: 1, 
	// 		title: "For Home", 
	// 		tasks: [
	// 			{"id":4,"user_id":1,"list_id":1,"content":"Test","deadline_at":null,"priority":"important","done":false},
	// 			{"id":3,"user_id":1,"list_id":1,"content":"Call Mam","deadline_at":null,"priority":"normal","done":false},
	// 			{"id":1,"user_id":1,"list_id":1,"content":"Clean the rooom","deadline_at":"2016-04-22T00:00:00.000+03:00","priority":"normal","done":false},
	// 			{"id":2,"user_id":1,"list_id":1,"content":"Buy a milk","deadline_at":null,"priority":"normal","done":true}
	// 		]
	// 	},
	// 	{	id: 2, 
	// 		title: "Ruby Garage",
	// 		tasks: []
	// 	}
	// ];

	factory.query = function() {
		// return lists;
		return $http.get('/lists');
	};

	factory.read = function(list_id) {
		// // TODO
		// function findLists(list) { 
		//     return list.id == list_id;
		// };

		// return lists.find(findLists);
		return $http.get('/lists/' + list_id);
	};

	factory.create = function(list) {
		// lists.push(list);
		return $http.post('/lists', list);
	};

	factory.destroy = function(list) {
		// var index = lists.indexOf(list);
		// lists.splice(index, 1);
		return $http.delete('/lists/' + list.id);
	};

	factory.update = function(list) {
		return $http.put('/lists/' + list.id, list);
	};

	return factory;
}]);