var murmurHash3 = require('cloud/libs/murmurHash3.min.js');
var moment = require('cloud/libs/moment.min.js');

Parse.Cloud.define("activeDay",function(request,response){
  var offset = request.user.get("gmtOffset") * (-1);//offset client time to match server timezone 
                                                    //which is assumed to be GMT 0 
  var seed = request.params.seed;
  var activeDay = murmurHash3.x86.hash32(moment().zone(offset).format("MM/DD/YYYY"),seed);
  console.log("the active hash: "+activeDay);
  // console.log("the offset date: "+moment().zone(offset).format("MM/DD/YYYY"));
  var query = new Parse.Query("ChallengeDay");
  query.equalTo("active",activeDay);
  query.include("intent");
  query.first({
    success: function(day) {
      console.log("active lookup success!: "+day);
      response.success(day);
    },
    error: function(error) {
      response.error("active lookup failed: "+error);
    }
  });
});

Parse.Cloud.afterSave("Challenge",function(request,response)
{
  var offset = request.user.get("gmtOffset") * (-1);
  //When a user creates a challenge, they automatically are "joining" that challenge as well
  var Intent = Parse.Object.extend("Intent");
  var intent = new Intent();

  intent.save({
       start: moment().zone(offset).toDate(),
         end: moment().zone(offset).add('days',(request.object.get("duration") - 1)).toDate(),
        user: request.user,
accomplished: false,
   challenge: request.object
  }, {
    success: function(intent) {
      console.log("intent saved with ID: "+intent.id);
    },
    error: function(intent, error) {
      console.log(error.description);
    }
  });
});

Parse.Cloud.afterSave("Intent",function(request,response){
  var challenge = request.object.get("challenge");
  challenge.fetch().then(function() {
    var offset = request.user.get("gmtOffset") * (-1);
    var userSeed = murmurHash3.x86.hash32(request.user.id);
    // console.log("user seed: "+userSeed);
    console.log("the challenge id: "+challenge.id);

    var defaults = {
            // startMoment: moment(request.object.get("start")),
            //   endMoment: moment(request.object.get("end")).add('days',1),
            startMoment: moment().zone(offset),
              endMoment: moment().zone(offset).add('days',challenge.get("duration")), //includes day past challenge for challenge day array creation
      challengeUserSeed: murmurHash3.x86.hash32(challenge.id,userSeed),
               required: challenge.get("freq"),
                 intent: request.object
    }
    var days = populateDays(defaults);

    Parse.Object.saveAll( days, {
      success: function(days) {
        console.log("all the days saved")
      },
      error: function(error) {
      // An error occurred while saving one of the objects.
        console.log("errored out all hard"+error.code);
      },
    });
  });
});


function populateDays(defaults)
{
  var Day = Parse.Object.extend("ChallengeDay");
  // var challengeDays = new Array();
  var challengeDays = [];
  var o = 1;
  // console.log('the date: '+defaults.startMoment.format("MM/DD/YYYY"));
  // console.log("the first day hash: "+murmurHash3.x86.hash32(defaults.startMoment.format("MM/DD/YYYY"),defaults.challengeUserSeed))
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

Parse.Cloud.beforeSave("Activity", function(request, response)
{
  var verfiyKey = request.object.get("verify");
  if (verfiyKey == undefined) {
    //essentially only modify the challenge day on Activity Class
    //saves that are associated with a Verification Class Key
    response.success();
    return;
  }
  var challengeDay = request.object.get("challengeDay");

  challengeDay.fetch().then(function() {
    //increment the challenge day completed key as a
    //service-side only update
    challengeDay.increment("completed");

    if (challengeDay.get("completed") == challengeDay.get("required")) 
    {
      challengeDay.set("accomplished",true); 
    }

    challengeDay.save(null, {
      success: function(challengeDay) {
        console.log('challenge day saved: ' + challengeDay.id);
        response.success();
      },
      error: function(challengeDay, error) {
        // Execute any logic that should take place if the save fails.
        // error is a Parse.Error with an error code and description.
        console.log('failed challenge day saving: ' + error.description);
        response.error(error.description);
      }
    });

  });

});