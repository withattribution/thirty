
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

var murmurHash3 = require('cloud/libs/murmurHash3.min.js');
var moment = require('cloud/libs/moment.min.js');

Parse.Cloud.define("hello", function(request, response)
{
	var d = new Date();
	var dd = [d.getMonth()+1, d.getDate(), d.getFullYear()].join('/');
	console.log('the formatted date: '+dd);

	var hash = murmurHash3.x86.hash32(dd);

  response.success('the hash: '+hash);
});

Parse.Cloud.afterSave("Challenge",function(request,response)
{
	var Intent = Parse.Object.extend("Intent");
	var intent = new Intent();
	
	intent.save({
 		start: moment().toDate(),
  		end: moment().add('days',request.object.get("duration")).toDate(),
  		user: request.user,
  		challenge:request.object.id
	}, {
		success: function(intent) {
			alert('intent saved: ' + intent.id);
			// response.success();
		},
		error: function(intent, error) {
			// Execute any logic that should take place if the save fails.
			// error is a Parse.Error with an error code and description.
			alert('failed intent saving: ' + error.message);
			// response.error(error.description);
		}
	});
});

Parse.Cloud.afterSave("Intent", function(request, response)
{
	var formattedDate = moment().format("MM/DD/YYYY");
	var challengeIdSeed =  murmurHash3.x86.hash32(request.object.get("challenge"));
	var hash = murmurHash3.x86.hash32(formattedDate,challengeIdSeed);
	console.log("the hash: "+hash);
});

Parse.Cloud.beforeSave("Activity", function(request, response)
{
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
