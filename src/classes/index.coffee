Graph = require './graph'
#DiGraph = require './digraph'
# MultiGraph = require 'multigraph'
# MultiDiGraph = require 'multidigraph'

module.exports = 
	Graph : (data=null, attr={})-> new Graph(data, attr)
	DiGraph : (data=null, attr={})-> new DiGraph(data, attr)
	# MultiGraph : ()-> new MultiGraph(arguments)
	# MultiDiGraph : ()-> new MultiDiGraph(arguments)