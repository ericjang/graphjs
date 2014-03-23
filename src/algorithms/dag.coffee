# algorithms for direct acyclic graphs

shortest_path_length = require('./shortest_paths').shortest_path_length

exports.descendants = (G,source) ->
	# returns the set of all nodes reachable from source in G
	s = {}
	if not G.has_node(source)
		console.log('Error: Node is not in the graph')
	helpers.update s, helpers.keys(shortest_path_length(G, source))
	delete s[source]
	helpers.keys s

exports.ancestors = (G,source) ->

exports.is_directed_acyclic_graph = (G) ->

exports.topological_sort = (G,nbunch=null) ->

exports.topological_sort_recursive = (G,nbunch=null) ->

exports.is_aperiodic = (G) ->

