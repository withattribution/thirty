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

//America/Denver
//.tz("America/Toronto").zone();
Parse.Cloud.afterSave("Challenge",function(request,response)
{
	var Intent = Parse.Object.extend("Intent");
	var intent = new Intent();

	intent.save({
 			start: moment().toDate(),
  			end: moment().add('days',(request.object.get("duration") - 1)).toDate(),
  		 user: request.user,
	challenge: request.object
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
	console.log('the date: '+defaults.startMoment.format("MM/DD/YYYY"));
	console.log("the first day hash: "+murmurHash3.x86.hash32(defaults.startMoment.format("MM/DD/YYYY"),defaults.challengeUserSeed))

	for (var d = defaults.startMoment; d.isBefore(defaults.endMoment,'day'); d.add('days',1))
	{ 
		var day = new Day();
		day.set("required",defaults.required); 
		day.set("completed",0); 
		day.set("accomplished",false); 
		day.set("ordinal",o); 
		day.set("active",murmurHash3.x86.hash32(d.format("MM/DD/YYYY"),defaults.challengeUserSeed)); 
		day.set("intent",defaults.intent); 

		challengeDays.push(day);
		o++;
	}
	return challengeDays;
};

Parse.Cloud.afterSave("Intent", function(request, response)
{
	console.log("user id: "+request.user.id);

	var userSeed = murmurHash3.x86.hash32(request.user.id);
	console.log("user seed: "+userSeed);

	var challenge = request.object.get("challenge");

  challenge.fetch().then(function() {
  	console.log("chalId: "+challenge.id);

  	var chUsrSeed = murmurHash3.x86.hash32(challenge.id,userSeed);
  	console.log("chalUserSeed: "+chUsrSeed);

  	var defaults = {
		        startMoment: moment(request.object.get("start")),
							endMoment: moment(request.object.get("end")).add('days',1),
		  challengeUserSeed: murmurHash3.x86.hash32(challenge.id,userSeed),
		    			 	 intent: request.object,
		        	 required: challenge.get("freq")
		}
		var days = populateDays(defaults);
		
		Parse.Object.saveAll( days, {
	   success: function(days) {
	    // All the objects were saved.
	    console.log("all the days are saved");
	   },
	   error: function(error) {
	   	// An error occurred while saving one of the objects.
	   	console.log("errored out all hard"+error.code);
	   },
	 });

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
