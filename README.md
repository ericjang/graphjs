# GraphJS


GraphJS is a framework for representing Mathematical Graphs in JavaScript. It provides lightweight graph classes can be extended for applications like representing Chemical Structures, Social Networks, Condensed Matter Physics, and just about anything and everything that can be represented as an abstract group of interconnected nodes.

<table>
	<tr>
		<td>
			<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/6n-graf.svg/250px-6n-graf.svg.png">
			<p>This is a graph</p>
		</td>
		<td>
			<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Multigraph.svg/125px-Multigraph.svg.png">
			<p>This is a Multigraph</p>
		</td>
	</tr>

</table>

GraphJS is designed to be as lightweight as possible. It can be extended easily to provide visualization/drawing capabilities.

## Documentation:

Proper documentation coming soon.

### GraphJS.structures
Choose between 1 of 4 Graph types:

- `Graph`: undirected graph with self-loops (basic)
- `DiGraph`: directed graph with self-loops
- `MultiGraph`: undirected graphs with self loops and parallel edges
- `MultiDiGraph`: directed graph with self loops and parallel edges


### Inheriting Graphs
Suppose you wanted to represent a social network by superclassing GraphJS (or more precisely, prototype-chaining). Social Networks connect people (nodes) through relationships (edges). Here is one way you can extend GraphJS.

```JavaScript

function SocialNetwork() {
	this.people = this.node;
	this.relationships = this.adj;
};
SocialNetwork.prototype = new GraphJS.classes.Graph();
SocialNetwork.prototype.constructor = SocialNetwork;//remember to reset the constructor so you don't call the GraphJS constructor

var exampleNetwork = new SocialNetwork();

```

### Missing Features

- Stuff hasn't really been tested yet.
- No iterables

### Developers

1. fork my repo
2. Read <a href='http://networkx.lanl.gov'>NetworkX documentation</a> to understand GraphJS's desired architecture
3. Implement whatever Graph Algorithm interests you
4. Submit a pull request with a test case.
5. I love you.


