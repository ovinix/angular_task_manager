app.factory('commentFactory', ['$http', 'Upload', function($http, Upload){
	factory = {};

	factory.upload = function(comment, method, url) {
		options = {
			url: url,
            method: method,
            fields: { comment: {
            				content: comment.content,
            				file: comment.file
			        	}
			        }
		};
		return Upload.upload(options);
	};

	factory.create = function(task, comment) {
		// return $http.post('/tasks/' + task.id + '/comments', comment);
		return factory.upload(comment, "POST", '/tasks/' + task.id + '/comments');
	};

	factory.destroy = function(task, comment) {
		return $http.delete('/tasks/' + task.id + '/comments/' + comment.id);
	};

	return factory;
}]);