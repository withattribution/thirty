
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

var murmurHash3 = require('cloud/libs/murmurHash3.min.js');
var moment = require('cloud/libs/moment.min.js');

// Parse.Cloud.define("hello", function(request, response)
// {
// 	var d = new Date();
// 	var dd = [d.getMonth()+1, d.getDate(), d.getFullYear()].join('/');
// 	console.log('the formatted date: '+dd);

// 	var hash = murmurHash3.x86.hash32(dd);

//   response.success('the hash: '+hash);
// });

Parse.Cloud.afterSave("Challenge",function(request,response)
{
	var Intent = Parse.Object.extend("Intent");
	var intent = new Intent();

	intent.save({
 			start: moment().toDate(),
  			end: moment().add('days',(request.object.get("duration") - 1)).toDate(),
  		 user: request.user,
	challenge:request.object.id
	}, {
		success: function(intent) {
			console.log("intent saved");
		},
		error: function(intent, error) {
			console.log(error.description);
		}
	});
});

function populateDays(defaults)
{
	var Day = Parse.Object.extend("ChallengeDay");

	var challengeDays = new Array();
	var o = 1;

	for (var d = defaults.startMoment; d.isBefore(defaults.endMoment,'day'); d.add('days',1))
	{ 
		var day = new Day();
		day.set("required",defaults.required); 
		day.set("completed",0); 
		day.set("accomplished",false); 
		day.set("ordinal",o); 
		day.set("active",murmurHash3.x86.hash32(d.format("MM/DD/YYYY"),defaults.challengeIdSeed)); 
		day.set("intent",defaults.intentId); 

		challengeDays.push(day);
		o++;
	}

	return challengeDays;
};


Parse.Cloud.afterSave("Intent", function(request, response)
{
	var challenge = Parse.Object.extend("Challenge");

	var query = new Parse.Query(challenge);
	query.get(request.object.get("challenge"), {
		success: function(challenge) {
			var defaults =
			    {
			        startMoment: moment(request.object.get("start")),
								endMoment: moment(request.object.get("end")).add('days',1),
			    challengeIdSeed: murmurHash3.x86.hash32(request.object.get("challenge")),
			    			 intentId: request.object.id,
			        	 required: challenge.get("freq")
			    };

			var days = populateDays(defaults);

			Parse.Object.saveAll(days, {
			   success: function(days) {
			     // All the objects were saved.
			     console.log("all the days are saved");
			   },
			   error: function(error) {
			   	console.log("errored out all hard"+error.code);
			     // An error occurred while saving one of the objects.
			   },
			 });
		},
		error: function(object, error) {
 			// The object was not retrieved successfully.
 			// error is a Parse.Error with an error code and description.
 			console.log(error.description);
		}
	});
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
