require('coffee-script');

var app = require('./app');
var server = app.startup();
console.log('created app');

console.log('launching Module: onmangeou');
require('./quiquimange/main');

server.listen(process.env.PORT || 3000);

console.log("Express server listening on port %d in %s mode",
            server.address().port,
            server.settings.env);