class GraphJS.DiGraph extends GraphJS.Graph
  constructor : (data=null, attr={}) ->
    @.graph = {}
    @.node = {}
    # We store two adjacency lists:
    # the  predecessors of node n are stored in the dict self.pred
    # the successors of node n are stored in the dict self.succ=self.adj
    @.adj = {}  # empty adjacency dictionary
    @.pred = {}  # predecessor
    @.succ = @.adj  # successor
    if data is not null
      convert.to_graphjs_graph data, @
    update @.graph, attr
    @.edge = @.adj

  add_node : (n, attr_dict=null, attr={}) ->
    if attr_dict is null
      attr_dict = attr
    else
      try
        update attr_dict, attr
      catch error
        console.log "attr_dict argument must be a dictionary"
    if n not of @.node
      @.succ[n] = {}
      @.pred[n] = {}
      @.node[n] = attr_dict
    else
      update @.node[n], attr_dict

  add_nodes_from : (nodes, attr={}) ->
    #this is my annoying custom implementation
    #something doesn't feel right about the Array case implementation...
    #what if array tuples contained specific node data?
    if typeIsArray nodes
      #presuming [[node,dict],[node,dict],[node,dict]] pairs
      for i, pair of nodes
        n = pair[0]
        if n not of @.succ
          @.succ[n] = {}
          @.pred[n] = {}
          @.node[n] = clone attr
        else
          update @.node[n], attr
    else
      #presuming {'node':dict,'node':dict} style
      for nn, ndict of nodes
        if nn not of @.succ
          @.succ[nn] = {}
          @.pred[nn] = {}
          newdict = clone attr
          update newdict, ndict
          @.node[nn] = newdict
        else
          olddict = @.node[nn]
          update olddict, attr
          update olddict, ndict


  #THIS FUNCTION STILL HAS TO BE TESTED
  remove_node : (n) ->
    if n of self.succ
      delete @.succ[n]
      delete @.node[n]
    else
      console.log 'The node %s is not in the digraph', n
    for i,u of nbrs
      delete @.pred[u][n]
    delete @.succ[n]
    for i,u in @.pred[n]
      delete @.succ[u][n]
    delete @.pred[n]

  remove_nodes_from : (nbunch) ->
    for i,n of nbunch
      succs = @.succ[n]
      delete @.node[n]
      for u of succs
        delete @.pred[u][n]
      delete @.succ[n]
      for u of @.pred[n]
        delete @.succ[u][n]
      delete @.pred[n]

  add_edge : (u,v,attr_dict=null,attr={}) ->
    if attr_dict is null
      attr_dict = attr
    else
      try
        update attr_dict attr
      catch error
        console.log "The attr_dict argument must be a dictionary"
    #add nodes
    if u not of @.succ
      @.succ[u] = {}
      @.pred[u] = {}
      @.node[u] = {}
    if v not of @.succ
      @.succ[v] = {}
      @.pred[v] = {}
      @.node[v] = {}
    #add the edge
    datadict = @.adj[u][v] || {}
    update datadict attr_dict
    @.succ[u][v] = datadict
    @.pred[v][u] = datadict

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
      if u not of @.succ
        @.succ[u] = {}
        @.pred[u] = {}
        @.node[u] = {}
      if v not of @.succ
        @.succ[v] = {}
        @.pred[v] = {}
        @.node[v] = {}
      datadict = @.adj[u][v] || {}
      update datadict, attr_dict
      update datadict, dd
      @.succ[u][v] = datadict
      @.pred[v][u] = datadict

  remove_edge : (u,v) ->
    if @.succ[u][v]
      delete @.succ[u][v]
      delete @.pred[v][i]
    else
      console.log "The edge %s-%s is not in the graph", u, v

  remove_edges_from : (ebunch) ->
    for i, e of ebunch
      u = e[0]
      v = e[1]
      if u of @.succ and v of @.succ[u]
        delete @.succ[u][v]
        delete @.pred[v][u]

  has_successor : (u,v) ->
    #return true if node u has successor v
    #this is true if graph has edge u->v
    return (u of self.succ and v of self.succ[u])

  has_predecessor : (u, v) ->
    #return true if node u has predecessor v
    return (u of self.pred and v of self.pred[u])

  successors: (n) ->
    _list @.succ[n]

  def predecessors: (n) ->
    _list @.pred[n]

  #digraph definitions
  neighbors : @.successors
  neighbors_iter : @.successors_iter

  ###MORE STUFF TO IMPLEMENT DOWN HERE
