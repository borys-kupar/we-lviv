/**
 * This is the RESTful API - make it so when you have more time:
 * http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api#snake-vs-camel
 * Be nice to your fellow programmers!
 */

// @todo: export databse and other environment settings to a separate config

var restify       = require('restify')
,   sessions      = require('client-sessions')
,   fs            = require('fs')
,   databaseUrl   = 'welviv' // "username:password@example.com/mydb"
,   collections   = ['stories']
,   db            = require('mongojs').connect(databaseUrl, collections)
,   stories       = db.collection('stories')
;

var ip_addr = 'localhost';
var port    =  '8000';

var server = restify.createServer({
    name : "welviv"
});

server.use(restify.queryParser());
server.use(restify.bodyParser());
server.use(restify.CORS());
server.use(sessions({
        cookieName: 'login',
        requestKey: 'session',
        secret: 'abcdef',
        duration: 24 * 60 * 60 * 1000,
        activeDuration: 1000 * 60 * 5,
        cookie: {
            path: '/',
            secure: false,
            httpOnly: false
        }
}));

server.use(function(req,res,next){
    res.setHeader('Access-Control-Allow-Credentials', 'true');
    next();
});

function corsHandler(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:9000');
    res.setHeader('Access-Control-Allow-Headers', 'Origin, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version, X-Response-Time, X-PINGOTHER, X-CSRF-Token, Cache-Control, X-Requested-With');
    res.setHeader('Access-Control-Allow-Methods', 'PUT, DELETE, POST');
    res.setHeader('Access-Control-Allow-Credentials', 'true');
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
server.post( {path: '/logout', version: '0.0.1'} , logout );
server.get ( {path: PATH, version: '0.0.1'} , findAllStories);
server.get ( {path: PATH +'/:storyId', version: '0.0.1'} , findStory);
server.post( {path: PATH, version: '0.0.1'} , addStory );
server.put( {path: PATH +'/:storyId', version: '0.0.1'} , updateStory );
server.del ( {path: PATH +'/:storyId', version: '0.0.1'} , deleteStory );


var publicProjection = {
  "$project" : {
    "en" : 1,
    "ua" : 1
  }
};

function login(req, res, next) {
    var post = req.params;

    if (post.username == 'admin' && post.password == 'admin') {
        req.session.logged_in = true;
        res.send(200);
    } else {
        res.send(404, 'Bad user/pass');
    }

    return next();
}

function logout(req, res, next) {
    delete req.session.logged_in;

    res.send(200);

    return next();
}

function checkAccess(req, res, next) {

    if(!req.session.logged_in) {
        res.send(401);
        return next();
    }
}

function findAllStories(req, res , next) {
    res.setHeader('Access-Control-Allow-Origin','*');
    stories.aggregate([publicProjection] , function(err , success) {
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

function updateStory(req, res, next) {
    checkAccess(req, res, next);

    var story = {};
    story.en = req.params.en;
    story.ua = req.params.ua;

    stories.update( { _id:db.ObjectId(req.params.storyId) }, story, function(err , success) {
        // console.log('Response success ' , success);
        if (err) { console.log('Response error ' , err); }
        if(success) {
            res.send(200, req.params);
            return next();
        } else {
            return next(err);
        }
    });
}

function addStory(req , res , next) {
    checkAccess(req, res, next);

    stories.save( req.params , function(err , success) {
        // console.log('Response success ' , success);
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
    checkAccess(req, res, next);

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