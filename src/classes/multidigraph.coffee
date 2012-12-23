class GraphJS.MultiDiGraph extends GraphJS.MultiGraph
  #also needs to use mixin to get some stuff from digraph!
  mix @ GraphJS.DiGraph

  add_edge : (u,v,key=null, attr_dict=null, attr={}) ->

  remove_edge : (u,v,key=null) ->

  edges_iter : (nbunch=null,data=false,keys=false) ->

  out_edges : (nbunch=null,keys=false,data=false) ->

  in_edges : (nbunch=null,keys=false,data=false) ->

  is_multigraph : ()->true
  is_directed : ()->true
  to_directed : () ->
    clone @
  to_undirected : (reciprocal=false) ->
  ###
  returns undirected representation of graph

  reciprocal : bool (optional) - if true only keeps edges that appear in both directions in original digraph
  ###

  subgraph : (nbunch) ->

  reverse : (copy=true) ->

