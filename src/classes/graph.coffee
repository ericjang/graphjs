class GraphJS.Graph
  constructor: (data=null, attr={}) ->
    @.graph = {}
    @.node = {}
    @.adj = {}
    if data isnt null then convert.to_graphjs_graph data , @
    update @.graph, attr#we use our helper function
    @.edge = @.adj
    return @

  #I don't know how to implement len, iter, str methods... :(
  add_node : (n, attr_dict=null, attr={}) ->
    if attr_dict is null
      attr_dict = attr
    else
      try
        update attr_dict, attr
      catch error
        console.log "attr_dict argument must be a dictionary"
    if n not of @.node
      @.adj[n] = {}
      @.node[n] = attr_dict
    else
      update @.node[n], attr_dict

  add_nodes_from : (nodes, attr={}) ->
    ###
    adds multiple nodes
    Due to JavaScript's different comprehension style, I was forced to implement this differently
    than NetworkX

    Can take two formats:

    array of
    [[node,dict],[node,dict],[node,dict]] pairs (faking tuples)

    or

    {
      'node':dict,
      'node':dict,
      etc.
    }
    ###
    if typeIsArray nodes
      #presuming [[node,dict],[node,dict],[node,dict]] pairs
      for i, pair of nodes
        if pair[0] not of @.node
          @.adj[pair[0]] = {}
          newdict = clone attr
          update newdict, pair[1]
          @.node[pair[0]] = newdict
        else
          olddict = @.node[pair[0]]
          update olddict, attr
          update olddict, pair[1]
    else
      #presuming {'node':dict,'node':dict} style
      for nn, ndict of nodes
        if nn not of @.node
          @.adj[nn] = {}
          newdict = clone attr
          update newdict, ndict
          @.node[nn] = newdict
        else
          olddict = @.node[nn]
          update olddict, attr
          update olddict, ndict


  remove_node : (n) ->
      ###
      removes node n
      ###
      adj = @.adj
      try
        nbrs = (key for key of adj[n])
        delete @.node[n]
        for i,u of nbrs#removes all edges n->u in graph
          delete adj[u][n]
        delete adj[n]
      catch error
        console.log "The node %s is not in the graph.", n

  remove_nodes_from : (nodes) ->
      ###
      removes multiple nodes

      nodes is presumed to be an array
      ###
      adj = @.adj
      for i,n of nodes
        try
          delete @.node[n]
          for u of adj[n]
            delete adj[u][n]
          delete adj[n]
        catch error
          continue

  nodes : (data=false) ->
      #returns list of nodes in graph
      if data
        ([node,node_data] for node,node_data of @.node)
      else
        (node for node of @.node)

  number_of_nodes : () ->
      #returns number of nodes in graph
      #use our custom list function. Be careful!
      (_list @.node).length

  order : () ->
    #identical to number_of_nodes
    @.number_of_nodes @.node

  has_node : (n) ->
    #returns true if graph contains node n
    return n of @.node

  add_edge : (u, v, attr_dict=null, attr={}) ->
    ###
    adds edge between u, v
    ###
    if attr_dict is null
      attr_dict = attr
    else
      try
        update attr_dict attr
      catch error
        console.log "attr_dict argument must be a dictionary."
    #add nodes (if necessary)
    if u not of @.node
      @.adj[u] = {}
      @.node[u] = {}
    if v not of @.node
      @.adj[v] = {}
      @.node[v] = {}
    #add the edge
    datadict = @.adj[u][v] || {}#hack around the dict get function
    update datadict, attr_dict
    @.adj[u][v] = datadict
    @.adj[v][u] = datadict

  add_edges_from : (ebunch, attr_dict=null, attr={}) ->
    ###
    Add all edges in ebunch
    i.e. [['A','B'],[1,'2'],['node','foobar',{'key':'value'}]]
    ###
    if attr_dict is null
      attr_dict = attr
    else
      try
        update attr_dict attr
      catch error
        console.log "attr_dict argument must be a dictionary."
    #process ebunch
    for i,e of ebunch
      switch e.length
        when 3
          u = e[0]
          v = e[1]
          dd = e[2]
        when 2
          u = e[0]
          v = e[1]
          dd = {}
        else console.log "Edge tuple %s must be a 2-array or a 3-array", e
      if u not of @.node
        @.adj[u] = {}
        @.node[u] = {}
      if v not of @.node
        @.adj[v] = {}
        @.node[v] = {}
      datadict = @.adj[u][v] || {}
      update datadict, attr_dict
      update datadict, dd
      @.adj[u][v] = datadict
      @.adj[v][u] = datadict

  add_weighted_edges_from : (ebunch, weight='weight', attr={}) ->
    ###
    add all edges in ebunch as weighted edges with specified weights
    ###
    @.add_edges_from ([e[0],e[1],{weight:e[2]}] for i,e of ebunch), null, attr

  remove_edge : (u,v) ->
    if @.adj[u] and @.adj[u][v]
      delete @.adj[u][v]
      #self-loop only needs one entry removed
      if u is not v
        del @.adj[v][u]
    else
      console.log "The edge %s-%s is not in the graph", u, v

  has_edge : (u,v) ->
    return v of @.adj[u]

  neighbors : (n) ->
    ###
    returns list of nodes connected to node n
    ###
    try
      return (key for key of @.adj[n])
    catch error
      console.log "Then node %s is not in the graph", n

  edges : (nbunch=null, data=false) ->
    ###
    returns list of edges

    edges returns as arrays with optional data in order of [node, neighbor, data]
    nbunch = optional array of desired nodes. defaults to all nodes.

    the structure of node_nbrs in networkx's implementation again, poses
    weird problems with array comprehension.

    I will write a custom implementation.

    ###


    arr = []#this is the array we stick results in

    seen = {}
    if nbunch is null
      node_nbrs = _items @.adj
      #node_nbrs looks like [('foobar', {}), ('adventure', {})]
    else
      node_nbrs = ([n,@.adj[n]] for i,n of nbunch)
    console.log 'neigh!'
    console.log node_nbrs
    if data
      for i, a of node_nbrs
        n = a[0]
        nbrs = a[1]
        for j, b of _items nbrs
          nbr = b[0]
          data = b[1]
          if nbr not of seen
            arr.push [n,nbr,data]
        seen[n] = 1
    else
      for i,a of node_nbrs
        n = a[0]
        nbrs = a[1]
        for nbr of nbrs
          if nbr not of seen
            arr.push [n,nbr]
        seen[n] = 1
    arr

  degree : (nbunch=null, weight=null) ->
    ###
    return the degree of a node or nodes (number of edges adjacent to the node)
    nbunch default = all nodes

    because iterators not supported, returns array of node-degree array pairs
    ###
    arr= []
    if nbunch is null
      node_nbrs = _items @.adj
    else
      node_nbrs = ([n,@.adj[n]] for i,n of nbunch)

    if weight is null
      for i,a of node_nbrs
        n = a[0]
        nbrs = a[1]
        arr.push [n,len(nbrs) + (n of nbrs)]#1 + true == 2
    else
      #edge weighted graph - degree is sum of nbr edge weights
      for i,a of node_nbrs
        n=a[0]
        nbrs = a[1]
        #TODO: make sure this is working
        arr.push [n, _sum(nbrs[nbr][weight] || 1 for nbr of nbrs) + (n of nbrs and nbrs[n][weight] || 1)]

  clear : () ->
    #removes all nodes and edges from the graph
    #also removes name, and all node, graph, edge attributes
    @.name = ''
    @.adj = {}
    @.node = {}
    @.graph = {}

  copy : () ->
    #returns copy of graph
    clone @

  is_multigraph : () ->
    false

  is_directed : () ->
    false

  to_directed : () ->
    ###
    returns a directed representation of graph
    ###
    G = new GraphJS.DiGraph
    G.name = @.name
    g.add_nodes_from(@)
    G.add_edges_from ([u,v,clone data] for u,nbrs of (_items @.adj) for v,data of (_items nbrs))
    G.graph = clone @.graph
    G.node = clone @.node
    G

  to_undirected : () ->
    clone @

  subgraph : (nbunch) ->
    ###
    return subgraph induced on nodes in nbunch
    ###
    console.log 'TODO: implement this!'

  nodes_with_selfloops : () ->
    ###
    return list of nodes with self loops
    ###
    console.log 'TODO: implement this!'

  selfloop_edges : (data=false) ->
    ###
    return a list of selfloop edges
    ###
    console.log 'TODO: implement this!'

  number_of_selfloops : () ->
    #return number of selfloop edges
    console.log 'TODO: Implement this!'

  size : () ->
    #number of edges
    console.log 'TODO: implement this!'

  number_of_edges : (self, u=null, v=null) ->
    ###
    returns number of edges between u and v
    otherwise if not specified, returns total number of edges for all nodes

    ###
    console.log 'TODO: implement this!'

  add_star : (self, nodes, attr={}) ->
    ###
    adds a star. First node is middle of star. It is connected to all other nodes

    this function is currently un-tested
    ###
    console.log 'warning - this function has not been tested'
    nlist = _list(nodes)
    v = nlist[0]
    edges = ([v,n] for i,n in nlist[1..])
    @.add_edges_from(edges,attr)

  add_path : (nodes, attr={}) ->
    ###
    add a path.
    path constructed from nodes in order and added to the graph
    ###
    console.log 'TOOD: implement this!'

  add_cycle : (nodes, attr={}) ->
    ###
    add a cycle
    ###
    console.log 'TODO: implement this!'

