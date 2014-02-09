# entry point for GraphJS module

G = {}
extend = require('./helpers').extend
extend(G, require('./classes'))
#extend(G, require('algorihtms'))

module.exports = G
