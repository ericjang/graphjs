var GraphJS = require('../lib/GraphJS')

var g = new GraphJS.Graph()

/*
Round one tests work!
*/

console.log('ROUND ONE TESTS: ADDING NODES')

var data1 = {
  '1' : {'size':10},
  'foobar' : {'height':5},
  'shuren' : {'width':1}
}

var data2 = [['node4',{'gobble':10}]]

g.add_nodes_from(data1)

g.add_nodes_from(data2)

g.remove_node('1')

console.log(g.node)

console.log('no data')
console.log(g.nodes(data=false))

console.log('with data')
console.log(g.nodes(data=true))

console.log(g.order())

console.log(g.has_node('foobar'))

console.log('deleting node4...')
g.remove_nodes_from(['node4'])


console.log(g.node)


/*

Round two tests: Edge Business
*/

console.log('ROUND TWO TESTS: EDGE STUFF')

g.add_edge('shuren','foobar')
g.add_edge('new kid on block','foobar')

g.add_edges_from([['A','B'],[1,'2'],['node','foobar',{'key':'value'}]], null, {'kansas':'toupee'})

g.remove_edge(1,'2')
g.remove_edge('2',1)

console.log(g.adj)

console.log('no data')
console.log(g.edges(nbunch=null,data=false))

console.log('with data')
console.log(g.edges(nbunch=null,data=true))

/*
Round 3: misc stuff
*/

console.log('attempting conversion to DiGraph...')
dg = g.to_directed()


