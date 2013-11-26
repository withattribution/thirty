
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.beforeSave("Activity", function(request, response) {
	var verfiyKey = request.object.get("verify");
	if (verfiyKey == undefined) {
		//essentially only modify the challenge day on Activity Class
		//saves that are associated with a Verification Class Key
		response.success();
		return;
	}

	var challengeDayId = request.object.get("challengeDay");
	var challengeDay = Parse.Object.extend("ChallengeDay");

	var query = new Parse.Query(challengeDay);
	query.get(challengeDayId.id, {
		success: function(challengeDay) {
			//increment the challenge day completed key as a
			//service-side only update
 			challengeDay.increment("completed");

 			if (challengeDay.get("completed") == challengeDay.get("required")) 
 			{
 				challengeDay.set("accomplished",true); 
 			}

 		  challengeDay.save(null, {
				success: function(challengeDay) {
					alert('challenge day saved: ' + challengeDay.id);
					response.success();
				},
				error: function(challengeDay, error) {
					// Execute any logic that should take place if the save fails.
					// error is a Parse.Error with an error code and description.
					alert('failed challenge day saving: ' + error.description);
					response.error(error.description);
				}
			});

		},
		error: function(object, error) {
 			// The object was not retrieved successfully.
 			// error is a Parse.Error with an error code and description.
			alert('failed to query challenge day: ' + error.description);
 			response.error(error.description);
		}
	});
});

// after save
// Parse.Cloud.afterSave("Comment", function(request) {
//   query = new Parse.Query("Post");
//   query.get(request.object.get("post").id, {
// 	success: function(post) {
// 	  post.increment("comments");
// 	  post.save();
// 	},
// 	error: function(error) {
// 	  console.error("Got an error " + error.code + " : " + error.message);
// 	}
//   });
// });
