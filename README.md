# GraphJS

GraphJS is a framework for representing mathematical graphs in JavaScript, inspired by the popular <a href='http://networkx.lanl.gov'>NetworkX</a> library for Python. 

## Features

- Nodes can represent anything (e.g. text, atoms, people)
- Edges can hold arbitrary data (e.g. weights, distances)
- Standard graph algorithms included
- API is similar to NetworkX, with support for core classes and algorithms.
- Works in Node.JS and Browser
- Open-source BSD License

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

## Usage

node.js:

```
npm install GraphJS
GraphJS = require('GraphJS');
```

browser:
```html
<script src='graphjs-browser.min.js'></script>
<script>
	var g = GraphJS.Graph();
</script>
```
No external dependencies are required.

### GraphJS.structures
Choose which type of graph is best suited for your application:

- `Graph`: undirected graph with self-loops (basic)
- `DiGraph`: directed graph with self-loops
- `MultiGraph`: undirected graphs with self loops and parallel edges
- `MultiDiGraph`: directed graph with self loops and parallel edges

### Inheriting Graphs
Modeling a social network is easy:

```JavaScript

var SocialNetworkClass = function() {
	// redefining nodes as people and edges as relationships
	this.people = this.node;
	this.relationships = this.adj;	
}
SocialNetwork.prototype = new GraphJS.classes.Graph();
SocialNetwork.prototype.constructor = SocialNetwork;
var exampleNetwork = new SocialNetwork();

```

## GraphJS-NetworkX Compatibility Chart

<!-- TODO!! -->

## How You Can Help

GraphJS is developed in my spare time, and usually out of necessity for a graph algorithm or two in some other project of mine. 
You can support this project in several ways:

1. File issues, bug reports, feature requests.
2. Contribute Code! 
	- Source code is written in CoffeeScript, which is syntactically similar to Python.
	- Read <a href='http://networkx.lanl.gov'>NetworkX documentation</a> to understand GraphJS's desired architecture. 
	- Implement a feature or two and submit a pull request.
3. You can buy me a coffee! Here is a bitcoin donation link:
<script src="http://coinwidget.com/widget/coin.js"></script>
<script>
CoinWidgetCom.go({
	wallet_address: "1MLX2kMhTSRiq3Uz7R2JsECreuQEmofQy6"
	, currency: "bitcoin"
	, counter: "hide"
	, alignment: "bl"
	, qrcode: true
	, auto_show: false
	, lbl_button: "Donate"
	, lbl_address: "My Bitcoin Address:"
	, lbl_count: "donations"
	, lbl_amount: "BTC"
});
</script>