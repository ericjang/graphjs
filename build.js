// compiles GraphJS for browser

var stitch  = require('stitch');
var fs      = require('fs');

var package = stitch.createPackage({
  paths: [__dirname + '/src']
});

package.compile(function (err, source){
  fs.writeFile('browser/GraphJS.js', source, function (err) {
    if (err) throw err;
    console.log('Compiled GraphJS.js');
  })
})