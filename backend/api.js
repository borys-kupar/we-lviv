/**
 * This is the RESTful API - make it so when you have more time:
 * http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api#snake-vs-camel
 * Be nice to your fellow programmers!
 */

// @todo: export databse and other environment settings to a separate config

var restify       = require('restify')
,   fs            = require('fs')
,   databaseUrl   = 'welviv' // "username:password@example.com/mydb"
,   collections   = ['stories']
,   db            = require('mongojs').connect(databaseUrl, collections)
,   stories  = db.collection('stories')
;


var ip_addr = 'localhost';
var port    =  '8000';

var server = restify.createServer({
    name : "welviv"
});
server.use(restify.queryParser());
server.use(restify.bodyParser());
server.use(restify.CORS());
//server.use(restify.fullResponse());

function corsHandler(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:9000');
    res.setHeader('Access-Control-Allow-Headers', 'Origin, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version, X-Response-Time, X-PINGOTHER, X-CSRF-Token, Cache-Control, X-Requested-With');
    res.setHeader('Access-Control-Allow-Methods', 'PUT, DELETE, POST');
    res.setHeader('Access-Control-Expose-Headers', 'X-Api-Version, X-Request-Id, X-Response-Time');
    res.setHeader('Access-Control-Max-Age', '1000');
    return next();
}

function optionsRoute(req, res, next) {
    res.send(200);
    return next();
}

server.opts('/\.*/', corsHandler, optionsRoute);
server.listen(port ,ip_addr, function(){
    console.log('%s listening at %s ', server.name , server.url);
});

var PATH = '/stories'
server.post( {path: '/login', version: '0.0.1'} , login );
server.get ( {path: PATH, version: '0.0.1'} , findAllStories);
server.get ( {path: PATH +'/:storyId', version: '0.0.1'} , findStory);
server.post( {path: PATH, version: '0.0.1'} , addStory );
server.put( {path: PATH +'/:storyId', version: '0.0.1'} , setStory );
server.del ( {path: PATH +'/:storyId', version: '0.0.1'} , deleteStory );


var publicProjection = {
  "$project" : {
    "title" : 1,
    "description" : 1
  }
};

function login(req, res, next) {
    console.log(req.session);
}

function findAllStories(req, res , next) {
    res.setHeader('Access-Control-Allow-Origin','*');
    stories.aggregate([publicProjection] , function(err , success) {
        //console.log('Response success ' , success);
        if (err) { console.log('Response error ' , err); }
        if(success) {
            res.send(200 , success);
            return next();
        } else {
            return next(err);
        }
    });
}

function findStory(req, res , next) {
    res.setHeader('Access-Control-Allow-Origin','*');
    stories.findOne({_id:db.ObjectId(req.params.storyId)} , function(err , success) {
        //console.log('Response success ' , success);
        if (err) { console.log('Response error ' , err); }
        if(success) {
            res.send(200 , success);
            return next();
        }
        return next(err);
    });
}

function setStory(req , res , next) {
    var story = {};

    story.title = req.params.title;
    story.description = req.params.description;
    story.image = req.params.image;
    story.video = req.params.video;
    story.audio = req.params.audio;

    stories.update( { _id:db.ObjectId(req.params.storyId) }, story, function(err , success) {
        console.log('Response success ' , success);
        if (err) { console.log('Response error ' , err); }
        if(success) {
            res.send(201 , req.params);
            return next();
        } else {
            return next(err);
        }
    });
}

function addStory(req , res , next) {
    console.log ( req.params );

    stories.save( req.params , function(err , success) {
        console.log('Response success ' , success);
        if (err) { console.log('Response error ' , err); }
        if(success) {
            res.send(201 , req.params);
            return next();
        } else {
            return next(err);
        }
    });
}

function deleteStory(req , res , next) {
    res.setHeader('Access-Control-Allow-Origin','*');
    stories.remove({_id:db.ObjectId(req.params.storyId)} , function(err , success) {
        //console.log('Response success ' , success);
        if (err) { console.log('Response error ' , err); }
        if(success) {
            res.send(204);
            return next();
        } else {
            return next(err);
        }
    });
}