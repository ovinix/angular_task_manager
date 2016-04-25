app.directive('commentView', [function() {
	return {
		restrict: 'A',
		templateUrl: '_comment.html'
	};
}]);

app.directive('commentForm', [function() {
	return {
		restrict: 'A',
		templateUrl: '_comment-form.html'
	};
}]);