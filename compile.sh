# compile coffeescript
# then use browserify to compile javascript
browserify -t coffeeify --extension=".coffee" src/index.coffee > graph.min.js