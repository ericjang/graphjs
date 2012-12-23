class GraphJS.MultiGraph extends GraphJS.Graph
  add_edge : (u, v, key=null, attr_dict=null, attr={}) ->
    if attr_dict is null
      attr_dict = attr
    else
      try
        update attr_dict attr
      catch error
        console.log "The attr_dict argument must be a dictionary"
    #add nodes
    if u not of @.adj
      @.adj[u] = {}
      @.node[u] = {}
    if v not of @.adj
      @.adj[v] = {}
      @.node[v] = {}
    if v of @.adj[u]
      keydict = @.adj[u][v]
      if key is null
        #find a unique integer key
        #other methods might be better here?
        key = (_list keydict).length
        while key of keydict
          key += 1
      datadict = keydict[key] || {}
      update datadict, attr_dict
      keydict[key] = datadict
    else
      #selfloops work this way without special treatment
      if key is nul
        key=0
      datadict = {}
      update datadict, attr_dict
      keydict = {key: datadict}
      @.adj[u][v] = keydict
      @.adj[v][u] = keydict

  add_edges_from : (ebunch, attr_dict=null, attr={}) ->
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
        when 4
          u   = e[0]
          v   = e[1]
          key = e[2]
          dd  = e[3]
        when 3
          u = e[0]
          v = e[1]
          dd = e[2]
          key = null
        when 2
          u = e[0]
          v = e[1]
          dd = {}
          key=null
        else console.log "Edge tuple %s must be a 2-array or a 3-array or 4-array", e
      if u of @.adj
        keydict = @.adj[u][v] || {}
      else
        keydict = {}
      if key is null
        #find unique integer key
        key = (_list keydict).length
        while key of keydict
          key += 1
      datadict = keydict[key] || {}
      update datadict, attr_dict
      update datadict, dd
      @.add_edge(u,v,key=key,attr_dict=datadict)

  remove_edge : (u,v,key=null) ->

  remove_edges_from : (ebunch) ->

  has_edge : (u,v,key=null) ->

  edges : (nbunch=null, data=false, keys=false) ->

  edges_iter : (nbunch=null, data=false, keys=false) ->

  get_edge_data : (u,v,key=null,default=null) ->

  is_multigraph : () -> true

  is_directed : () -> false

  to_directed : () ->
    G = GraphJS.MultiDiGraph()
    G.add_nodes_from(@)
    G.add_edges_from([u,v,key,clone datadict] for u,nbrs of (_items @.adj) for v,keydict of (_items nbrs) for key,datadict of (_items keydict))
    G.graph = clone @.graph
    G.node = clone @.node
    G

  selfloop_edges : (data=false, keys=false) ->

  number_of_edges : (u=null, v=null) ->

  subgraph : (nbunch) ->
