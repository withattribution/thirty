var murmurHash3 = require('cloud/libs/murmurHash3.min.js');
var moment = require('cloud/libs/moment.min.js');

// curl -X POST \
//   -H "X-Parse-Application-Id: pMydn1FlUYwUcXeLRRAMFp3zcZPz3lRQ6IITQEe2" \
//   -H "X-Parse-REST-API-Key: xZvVVirqiqEeHsivxTcUHPygbGQy9qS3u9DjLHsW" \
//   -H "Content-Type: application/json" \
//   -d '{"movie":"The Matrix"}' \
//   https://api.parse.com/1/functions/testRelation

Parse.Cloud.define("testRelation",function(request,response){
  console.log("test in progress");

  var container = [];

  var Parent = Parse.Object.extend("parent");
  var parent = new Parent();
  var relation = parent.relation("children");

  var Child = Parse.Object.extend("child");

  for (var i = 0; i < 3; i++) {
      var child = new Child();
      child.set("status",false);
      child.set("date",new Date());
      container.push(child);
  };

  Parse.Object.saveAll( container ).then(function(){
    parent.save().then(function(){
      // var relation = child.relation("parent");

      for (var j = 0; j < container.length; j++) {
        relation.add(container[j]);
        //relation.add(child);
      };

      parent.save(null, {
        success:function(obj) {
          response.success("check your corners");
        }, error:function(error){
          response.error("aww fuck");
        }
      });

    });

  });

});

// curl -X POST \
//   -H "X-Parse-Application-Id: pMydn1FlUYwUcXeLRRAMFp3zcZPz3lRQ6IITQEe2" \
//   -H "X-Parse-REST-API-Key: xZvVVirqiqEeHsivxTcUHPygbGQy9qS3u9DjLHsW" \
//   -H "Content-Type: application/json" \
//   -d '{"movie":"The Matrix"}' \
//   https://api.parse.com/1/functions/changeChild

Parse.Cloud.define("getChildren",function(request,response){
  console.log("time to get the children");

  var Parent = Parse.Object.extend("parent");
  var query = new Parse.Query(Parent);

  query.get("24EJTx4Ce1",function(pOBJ){
    var relation = pOBJ.relation("children");
    var q = relation.query();
    q.find({
      success: function(list) {
        response.success(list);
      },
      error: function(object, error) {
       response.error(error.code);
        // error is a Parse.Error with an error code and description.
      }
    });
  });
});

Parse.Cloud.define("changeChild",function(request,response){
  var Child = Parse.Object.extend("child");
  var query = new Parse.Query(Child);
  query.get("KLNZ9aTIky",function(childObj){
    console.log("got this object: "+childObj.id);
    childObj.set("status",true);
    childObj.save(null,{
      success: function() {
        response.success("saved a child with code");
      },
      error: function(error) {
        response.error("child save failed: "+error);
      }
    });
  });
});

Parse.Cloud.define("activeDay",function(request,response){
  //offset client time to match server timezone
  //which is assumed to be GMT 0 
  var offset = request.user.get("gmtOffset") * (-1);                    
  var seed = request.params.seed;
  var activeDay = murmurHash3.x86.hash32(moment().zone(offset).format("MM/DD/YYYY"),seed);
  //console.log("the active hash: "+activeDay);
  // console.log("the offset date: "+moment().zone(offset).format("MM/DD/YYYY"));
  var query = new Parse.Query("ChallengeDay");
  query.equalTo("active",activeDay);
  query.include("intent");
  query.first({
    success: function(day) {
      response.success(day);
    },
    error: function(error) {
      response.error("active day query failed: "+error);
    }
  });
});

function saveIntent(defaults) {

}

Parse.Cloud.define("joinChallenge",function(request,response){
  var challengeId = request.params.challenge;
  var offset = request.user.get("gmtOffset") * (-1);
  console.log("the param for the challenge id: "+challengeId);

  var query = new Parse.Query("Challenge");
  query.get(challengeId).then(function(challenge){

    var Intent = Parse.Object.extend("Intent");
    var intent = new Intent();
    intent.save({
           start: moment().zone(offset).toDate(),
             end: moment().zone(offset).add('days',(challenge.get("duration") - 1)).toDate(),
            user: request.user,
    accomplished: false,
       challenge: challenge
    }, {
      success: function(intent) {
        console.log("intent saved with ID: "+intent.id);
        var userSeed = murmurHash3.x86.hash32(request.user.id);
        // console.log("user seed: "+userSeed);
        var defaults = {
              startMoment: moment().zone(offset),
                //end moment includes day past challenge for challenge day array creation 
                endMoment: moment().zone(offset).add('days',challenge.get("duration")),
        challengeUserSeed: murmurHash3.x86.hash32(challenge.id,userSeed),
                 required: challenge.get("freq")
                   // intent: intent
        }

        var days = populateDays(defaults);

        Parse.Object.saveAll( days, {
          success: function(days) {
            var toRelate = {
                days: days,
              intent: intent
            };
            var relatedIntent = relateToIntent(toRelate);
            //resave intent with related challenge days
            relatedIntent.save(null, {
              success: function(intent) {
                response.success(intent);
              },          
              error: function(error) {
               response.error("saving intent error: "+error.code);
              }
            });
          },
          error: function(error) {
            response.error("saving days error: "+error.code);
          },
        });

      },
      error: function(intent, error) {
        response.error("intent creation error: " +error.code);
      }

    });
  });

});

function relateToIntent(object)
{
  var relation = object.intent.relation("days");
  for (var i = 0; i < object.days.length; i++) {
    relation.add(object.days[i]);
  };
  return object.intent;
}

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
    // day.set("intent",defaults.intent);

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