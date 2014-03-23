Graph = require('graph')

class DiGraph extends Graph
	# Base class for directed graphs
	# DiGraphs hold directed edges.  Self loops are allowed but multiple
    # (parallel) edges are not.
   	
    constructor: (data=null, attr={}) ->
	    @graph = {}
	    @node = {}
	    @adj = {}
	    @pred = {}
	    @succ = @adj
	    if data isnt null
	   		# this isn't implemented yet
	      convert.to_graphjs_graph(data , @) 
	    helpers.update @graph, attr
	    @.edge = @adj

	add_node : (n, attr_dict=null, attr={})->
	    # add a single node n and update node attributes
	    if actr_dict is null 
	      attr_dict = attr
	    else 
	      try
	        helpers.update attr_dict, attr  
	      catch
	        console.log 'attr_dict must be a dictionary!'
	    if n not of @node
	      @succ[n] = {}
	      @pred[n] = {}
	      @node[n] = attr_dict
	    else
	      helpers.update @node[n], attr_dict


	add_nodes_from : (nodes, attr={})->
	    # add multiple nodes
	    # nodes : either a list of nodes [1,2,3,4]
	    # 			OR a list of [node, attr_dict] tuples [[1,{}],[2,{}],[3,'bar']]
	    for n in nodes
	    	if helpers.typeIsArray n
	    		[nn, ndict] = n
	    		if nn not in @succ
	    			@succ[nn] = {}
	    			@pred[nn] = {}
	    			newdict = attr
	    			helpers.update newdict, ndict
	    			@node[nn] = newdict
	    		else
	    			helpers.update @node[nn], attr
	    			helpers.update @node[nn], ndict
	    		helpers.update @node[n], attr
	    	else
	    		newnode = n not in @succ
		    	if newnode
		    		@succ[n] = {}
		    		@pred[n] = {}
		    		@node[n] = attr
		    	else
		    		helpers.update @node[n], attr

	remove_node : (n) ->
	    # removes node n and all adjacent edges
	    try
	    	nbrs = @succ[n]
	    	delete @node[n]
	    catch
	    	console.log('The node is not in the digraph')
	    for u in nbrs
	    	delete @pred[u][n]
	    delete @succ[n]
	    for u in @pred[n]
	    	delete @succ[u][n]
	    delete @pred[n]

	remove_nodes_from : (nbunch) ->
	    # removes multiple nodes
	    for n in nbunch
	    	try
	    		succs = @succ[n]
	    		delete @node[n]
	    		for u in succs
	    			delete @pred[u][n]
	    		delete @succ[n]
	    		for u in @pred[n]
	    			delete @succ[u][n]
	    		delete @pred[n]
	    	catch e
	    		console.log 'dlkfalkd!!'
	    	
	add_edge : (u,v,attr_dict=null, attr={}) ->
	    # add an edge between nodes u and v
	    # u and v will automatically be added
	    # if they are not already in the graph
	    # edge attributes can be specified with attrs
	    # G.add_edge(1,2,weight=3)
	    # G.add_edge(1,2,{'foo':1})

	    # set up attribute dictionary
	    if attr_dict is null
	      attr_dict = attr
	    else
	      try
	        helpers.update attr_dict attr
	      catch e
	        console.log "The attr_dict argument must be a dictionary."
	    # add nodes
	    if u not of @succ
	    	@succ[u] = {}
	    	@pred[u] = {}
	    	@node[u] = {}
	    if v not of @succ
	    	@succ[v] = {}
	    	@pred[v] = {}
	    	@node[v] = {}
	    # add the edge
	    datadict = helpers.get @adj[u], v, {}
	    helpers.update datadict, attr_dict
	    @succ[u][v] = datadict
	    @pred[v][u] = datadict

	add_edges_from : (ebunch, attr_dict=null, attr={}) ->
	    if attr_dict is null
	      attr_dict = attr
	    else
	      try
	        helpers.update attr_dict attr
	      catch e
	        console.log "The attr_dict argument must be a dictionary."
	    # process ebunch
	    for e in ebunch
	      ne = e.length
	      switch ne
	        when 3 then [u,v,dd] = e
	        when 2 then [u,v,dd] = [e[0],e[1],{}]
	        else
	          console.log "each edge must be a 2-array or 3-array"
	      if u not of @node
	        @adj[u] = {}
	        @node[u] = {}
	      if v not of @node
	        @adj[v] = {}
	        @node[v] = {}
	      datadict = helpers.get @adj[u], v, {}
	      helpers.update datadict, attr_dict
	      helpers.update datadict, dd
	      @adj[u][v] = datadict
	      @adj[v][u] = datadict
# everything below here needs to be fixed

	remove_edge : (u,v) ->
	    # removes the edge between u and v
	    try
	      helpers.del @adj[u][v]
	      if u isnt v
	        # self-loop only needs one entry removed
	        helpers.del adj[v][u]
	    catch e
	      console.log "edge %s-%s is not in graph", u,v

	remove_edges_from : (ebunch) ->
	    # removes all edges specified in ebunch
	    for e in ebunch
	      [u,v] = e[0...2] # ignore edge data if present
	      if u of @adj and v of @adj[u]
	        helpers.del @adj[u], v
	        if u isnt v # self-loops only need one entry removed
	          helpers.del @adj[v], u

	has_successor : (u,v) ->
		# This is true if graph has the edge u->v.
		u in @succ and v in @succ[u]

	has_predecessor : (u,v) ->
		# This is true if graph has the edge u<-v.
		u in @pred and v in @pred[u]

	successors : (n) ->
		helpers.keys(@succ[n])

	predecessors : (n) ->
		helpers.keys(@pred[n])

	neighbors : (n) ->
		@successors n

	in_edges : (nbunch=null, data=false) ->
		l = []
		if nbunch is null
			nodes_nbrs = helpers.items @pred
		else
			nodes_nbrs = ([n,@pred[n]] for n in nbunch)
		if data
			for [n,nbrs] in nodes_nbrs
				for [nbr,data] in helpers.items(nbrs)
					l.push([nbr,n,data])
		else
			for [n,nbrs] in nodes_nbrs
				for nbr in nbrs
					l.push([nbr,n])

	out_edges = ->
		@edges n

	in_degree : (nbunch=null, weight=null) ->
		l = []
		if nbunch is null
			node_nbrs = helpers.items @pred
		else
			nodes_nbrs = ([n,@pred[n]] for n in nbunch)
		if weight is null
			for [n,nbrs] in node_nbrs
				l.push([n,nbrs.length])
		else
			# edge-weighted graph. degree = sum of edge
			# weights
			for [n,nbrs] in node_nbrs
				l.push([n, helpers.get(data, weight, 1)] for data in helpers.values)

	out_degree : (nbunch=null, weight=null) ->
		l = []
		if nbunch is null
			node_nbrs = helpers.items @succ
		else
			node_nbrs = ([n,@succ[n]] for n in nbunch)
		if weight is null
			for [n,nbrs] in nodes_nbrs
				l.push([n,nbrs.length])
		else
			for [n,nbrs] in node_nbrs
				l.push([n, helpers.get(data, weight, 1)] for data in helpers.values)

	clear : ->
		# removes all nodes and edges from graph
		@graph = {}
		@succ = {}
		@node = {}
		@pred=  {}

	is_multigraph : ->
		false

	is_directed : ->
		true

	to_directed : ->
		helpers.deepcopy @

	to_undirected : ->
		# TODO - not implemented yet

	reverse : (copy=true) ->
		# returns the reverse of this graph
		if copy
			# not sure if this implementation is correct...
			H.add_nodes_from(@)
			H.add_edges_from([v,u,helpers.deepcopy(d)] for [u,v,d] in @edges(true))
			H.graph = helpers.deepcopy @graph
			H.node = helpers.deepcopy @node
		else
			[@pred, @succ] = [@succ, @pred]
			@adj = @succ
			@

	subgraph : (nbunch) ->
		# TODO - how to create new instance of self?



