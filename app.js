require('coffee-script');

var app = require('./application');
var server = app.startup();
console.log('created app');

console.log('launching Module: quiquimange');
require('./quiquimange/main');

//console.log('>>>>>>>>>>', process.env);
server.listen(process.env.VMC_APP_PORT || 3000, process.env.VCAP_APP_HOST );

console.log("Express server listening on port %d in %s mode",
            server.address().port,
            server.settings.env);