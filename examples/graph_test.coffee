GraphJS = require '../src'
#console.log GraphJS
g = GraphJS.Graph()
g.add_node(1)
g.add_node(2)
g.add_node(3)
g.remove_node(3)
console.log(g.node)
g.add_node("foo",{"data":100})
more_nodes = ["one","two","three"]
g.add_nodes_from(more_nodes, {"fff" : 1.2})
g.add_edge(1, 2)
edges = [["one",1],["two",2]]
g.add_edges_from(edges)
g.remove_nodes_from(["two",2])
console.log(g.adj)