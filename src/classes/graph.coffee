# Base class for undirected graphs.
# The Graph class allows any hashable object as a node
# and can associate key/value attribute pairs with each undirected edge.
# Self-loops are allowed but multiple edges are not (see MultiGraph).
# For directed graphs see DiGraph and MultiDiGraph.

#    Copyright (C) 2013-2014 by
#    Eric Jang <eric_jang@brown.edu>
#    All rights reserved.
#    BSD license.

convert = require('../convert')
helpers = require('../helpers')

class Graph
  # Base class for undirected graphs.
  #   A Graph stores nodes and edges with optional data, or attributes.
  #   Graphs hold undirected edges.  Self loops are allowed but multiple
  #   (parallel) edges are not.

  #   Nodes can be arbitrary (hashable) Python objects with optional
  #   key/value attributes.

  #   Edges are represented as links between nodes with optional
  #   key/value attributes.

  #   Parameters
  #   ----------
  #   data : input graph
  #       Data to initialize graph.  If data=None (default) an empty
  #       graph is created.  The data can be an edge list, or any
  #       NetworkX graph object.  If the corresponding optional Python
  #       packages are installed the data can also be a NumPy matrix
  #       or 2d ndarray, a SciPy sparse matrix, or a PyGraphviz graph.
  #   attr : keyword arguments, optional (default= no attributes)
  #       Attributes to add to graph as key=value pairs.
  constructor: (data=null, attr={}) ->
    @graph = {}
    @node = {}
    @adj = {}
    if data isnt null
      convert.to_graphjs_graph(data , @)  # this isn't implemented quite yet
    helpers.update @graph, attr
    @edge = @adj

  name : (s) ->
    if s is undefined
      @graph.name
    else
      @graph.name = out

  add_node : (n, attr_dict=null, attr={})->
    # add a single node n and update node attributes
    if attr_dict is null 
      attr_dict = attr
    else 
      try
        helpers.update attr_dict, attr  
      catch
        console.log 'attr_dict must be a dictionary!'
    if n not of @node
      @adj[n] = {}
      @node[n] = attr_dict
    else
      helpers.update @node[n], attr_dict


  add_nodes_from : (nodes, attr={})->
    # add multiple nodes
    for n in nodes
      @add_node(n, attr)

  remove_node : (n) ->
    # removes node n and all adjacent edges
    try
      helpers.del @node, n
      console.log @adj[n]
      for u in helpers.keys(@adj[n])
        console.log u
        helpers.del @adj[u][n]
      helpers.del @adj[n]
    catch error
      console.log error

  remove_nodes_from : (nodes) ->
    # removes multiple nodes
    for n of @nodes
      @remove_node(n)

  nodes : (data=false) ->
    # returns list of nodes in graph
    # if data is true, then 
    if data
      arr = helpers.keys @nodes
    else
      arr = helpers.items @nodes


  number_of_nodes : ->
    helpers.keys(@node).length

  order : ->
    number_of_nodes()

  has_node : (n) ->
    # returns true if n is a node
    # false otherwise
    n of @node

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
    if u not of @node
      @adj[u] = {}
      @node[u] = {}
    if v not of @node
      @adj[v] = {}
      @node[v] = {}
    # add the edge
    datadict = helpers.get @adj[u], v, {}
    helpers.update datadict, attr_dict
    @adj[u][v] = datadict
    @adj[v][u] = datadict

  add_edges_from : (ebunch, attr_dict=null, attr={}) ->
    # add the edges in ebunch
    # ebunch : container of edges
    #         Each edge given in the container will be added to the
    #         graph. The edges must be given as as 2-tuples (u,v) or
    #         3-tuples (u,v,d) where d is a dictionary containing edge
    #         data.
    #     attr_dict : dictionary, optional (default= no attributes)
    #         Dictionary of edge attributes.  Key/value pairs will
    #         update existing data associated with each edge.
    #     attr : keyword arguments, optional
    #         Edge data (or labels or objects) can be assigned using
    #         keyword arguments.

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

  add_weighted_edges_from : (ebunch, weight='weight', attr={}) ->
    # adds all the edges in ebunch as weighted edges with specified weights
    @add_edges_from ([u,v,{weight:d}] for [u,v,d] in ebunch), attr

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

  has_edge : (u,v) ->
    # returns true if edge u,v is in graph
    v of @adj[u]

  neighbors : (n) ->
    # returns list of nodes connected to n
    helpers.keys @adj[n]

  edges : (nbunch=null, data=false) ->
    # returns list of edges
    # edges returned as arrays with optional data
    # in the order [node, neighbor, data]
    seen = {} # helper dict to keep track of multiply stored edges
    if nbunch is null
      nodes_nbrs = helpers.items @adj
    else
      nodes_nbrs = ([n,@adj[n]] for n in helpers.keys(nbunch))
    for [n,nbrs] in nodes_nbrs
        for own nbr, data of nbrs
          if nbr not of seen
            if data
              seen[n] = [n,nbr,data]
            else
              seen[n] = [n,nbr]
    helpers.items seen

  get_edge_data : (u,v,_default=null) ->
    # returns attribute dictionary associated with edge u-v
    try
      @adj[u][v]
    catch e
      _default
  
  adjacency_list : ->
    # returns adjacency list representation of the graph
    # returned in order of @nodes()
    (helpers.keys(edgedict) for edgedict in helpers.values(@adj))

  degree : (nbunch=null, weight=null) ->
    # return degree of a node or nodes
    # nbunch = iterable list of nodes. default = all nodes
    if nbunch is null
      node_nbrs = helpers.items @adj
    else
      node_nbrs = ([n, @adj[n]] for n in helpers.keys(nbunch))
    if weight is null
      degrees = ([n, helpers.len(nbr) + (n of nbrs)] for own n,nbrs of node_nbrs)
    else
      # edge-weighted graph - degree is sum of nbr edge weights
      degrees = []
      for own n, nbrs of node_nbrs
        sum = 0
        for own nbr, edgedata of nbrs
          sum += helpers.get edgedata, weight, 1
        degrees.push [n, sum]
      degrees

  clear : ->
    # removes all nodes and edges from the graph
    @name = ''
    @adj = {}
    @node = {}
    @graph = {}
  
  copy : ->
    # returns a copy of the graph
    helpers.deepcopy @

  is_multigraph : ->
    false

  is_directed : ->
    false

  to_directed : ->
  #   # return a directed representation of the graph
  #   # TODO, not implemented yet. 

  to_undirected : ->
    helpers.deepcopy @

  subgraph : (nbunch) ->
    # returns subgraph induced on nodes in nbunch
    # the induced subgraph contains the nodes in nbunch
    # and the edges between those nodes
    H = @constructor() # create new graph
    for n in nbunch
      H.node[n] = @node[n]
    H_adj = H.adj
    self_adj = @adj
    # add nodes and edges (undirected method)
    for n in H.node
      Hnbrs = {}
      H_adj[n] = Hnbrs
      for own nbr, d of self_adj[n]
        if nbr of H_adj
          # add both representations of edge, n-nbr and nbr-n
          Hnbrs[nbr] = d
          H_adj[nbr][n] = d
      H.graph = @graph
      return H


  nodes_with_selfloops : ->
    # returns list of nodes with self loops
    # TODO

  selfloop_edges : (data=false) ->
    # TODO

  nuber_of_selfloops : ->
    return @selfloop_edges().length

  size : (weight=null) ->
    # returns the number of edges
    # weight - edge attribute that holds numerical
    # value as weight. If null, then each edge has weight = 1
    sum = 0
    degrees = @degree(null, weight)
    for [n,val] in degrees
      s += val
    sum /=2

  number_of_edges : (u=null, v=null) ->
    # if u,v are specified, returns number of edges between
    # the two nodes. Otherwise return total number of all edges.
    if u is null
      @size()
    if v in @adj[u]
      1
    else
      0

  add_star : (nodes, attr) ->
    # add a star
    # first node in nodes is the middle of the star and is connected
    # to all other nodes
    v = nodes[0]
    edges = ([v,n] for n in nodes[1..])
    @add_edges_from(edges, attr)

  add_path : (nodes, attr) ->
    # add a path
    edges = helpers.zip nodes[...-1], nodes[1..]
    @add_edges_from(edges, attr)

  add_cycle : (nodes) ->
    edges = helpers.zip nodes, nodes[1..].concat(nodes[0])
    @add_edges_from(edges, attr)

module.exports = Graph