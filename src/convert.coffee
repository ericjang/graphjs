# Functions to convert NetworkX graphs to and from other formats.

# The preferred way of converting data to a NetworkX graph is through the
# graph constuctor.  The constructor calls the to_networkx_graph() function
# which attempts to guess the input type and convert it automatically.

# Examples
# --------
# Create a graph with a single edge from a dictionary of dictionaries

# >>> d={0: {1: 1}} # dict-of-dicts single edge (0,1)
# >>> G=nx.Graph(d)


to_graphjs_graph = (data, create_using=null, multigraph_input=false) ->
	# create a graphjs graph from a known data structure
	# preferred way to call this is straight from the class 
	# constructor
	# d={0: {1: {'weight':1}}} # dict-of-dicts single edge (0,1)
	# g = gx.Graph(d)
	# Parameters
	# ----------
	# data : a object to be converted
	#    Current known types are:
	#      any NetworkX graph
	#      dict-of-dicts
	#      dist-of-lists
	#      list of edges
	#      numpy matrix
	#      numpy ndarray
	#      scipy sparse matrix
	#      pygraphviz agraph

	# create_using : NetworkX graph
	#    Use specified graph for result.  Otherwise a new graph is created.

	# multigraph_input : bool (default False)
	#   If True and  data is a dict_of_dicts,
	#   try to create a multigraph assuming dict_of_dict_of_lists.
	#   If data and create_using are both multigraphs then create
	#   a multigraph from a multigraph.
	console.log 'Not implemented yet!'
		

from_dict_of_dicts = (d, create_using=null)->
	# TODO

module.exports = 
	to_graphjs_graph : to_graphjs_graph
