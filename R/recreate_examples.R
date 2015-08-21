# see if we can use WebCola in R with V8

library(V8)
library(jsonlite)
library(igraph)
library(scales)

ctx = new_context(global="window")

ctx$source("./WebCola/cola.js")

align_json <- fromJSON("./WebCola/examples/graphdata/alignmentconstraints.json")
ctx$assign( "graph", align_json )

js_fun <- '
// console.assert does not exists
console = {}
console.assert = function(){};

var mycola = new cola.Layout()
        .linkDistance(120)
        .avoidOverlaps(true)
        .size([800, 400]);

graph.nodes.forEach(function (v) { v.x = 400, v.y = 50 });
mycola
   .nodes(graph.nodes)
   .links(graph.links)
   .constraints(graph.constraints)
   .start(10,10,10);
'


ctx$eval(js_fun)


igf <- graph.data.frame(
  align_json$links + 1
  ,vertices =  data.frame(id = 1:nrow(align_json$nodes),align_json$nodes)
)

igf_layout <- ctx$get('
  graph.nodes.map(function(d){
    return [d.x,-d.y]
  })                    
')

plot(igf, layout = igf_layout   )



### small grouped example
group_json <- fromJSON( "./WebCola/examples/graphdata/smallgrouped.json")
#ctx$assign( "graph", group_json )

# need to get forEach polyfill
ctx$source("https://cdnjs.cloudflare.com/ajax/libs/es5-shim/4.1.10/es5-shim.min.js")

js_group <- '
// console.assert does not exists
console = {}
console.assert = function(){};

var width = 960,
    height = 500

graph = {
    "nodes":[
{"name":"a","width":60,"height":40},
{"name":"b","width":60,"height":40},
{"name":"c","width":60,"height":40},
{"name":"d","width":60,"height":40},
{"name":"e","width":60,"height":40},
{"name":"f","width":60,"height":40},
{"name":"g","width":60,"height":40}
],
"links":[
{"source":1,"target":2},
{"source":2,"target":3},
{"source":3,"target":4},
{"source":0,"target":1},
{"source":2,"target":0},
{"source":3,"target":5},
{"source":0,"target":5}
],
"groups":[
{"leaves":[0], "groups":[1]},
{"leaves":[1,2]},
{"leaves":[3,4]}
]
}

var g_cola = new cola.Layout()
    .linkDistance(100)
    .avoidOverlaps(true)
    .handleDisconnected(false)
    .size([width, height]);

g_cola
    .nodes(graph.nodes)
    .links(graph.links)
    .groups(graph.groups)
    .start()

'


ctx$eval(js_group)

igf <- graph.data.frame(
  group_json$links + 1
  ,vertices =  data.frame(id = 1:nrow(group_json$nodes),group_json$nodes)
)

igf_layout <- ctx$get('
  graph.nodes.map(function(d){
    return [d.x,-d.y]
  })                    
')

plot(igf, layout = igf_layout, mark.groups = lapply(group_json$groups$leaves,function(x)x+1)  )

rects <- ctx$get('graph.groups.map(function(d){return d.bounds})')

apply(
  ctx$get('graph.groups.map(function(d){return d.bounds})')
  ,MARGIN = 1
  ,function(coords){
      rect(
        xleft = rescale(coords[["x"]], c(-1,1), from = range(igf_layout[,1]))
        ,ybottom = rescale(-coords[["Y"]], c(-1,1), range(igf_layout[,2]))
        ,xright = rescale(coords[["X"]], c(-1,1), from = range(igf_layout[,1]))
        ,ytop = rescale(-coords[["y"]], c(-1,1), range(igf_layout[,2]))
        ,col = rgb( 0.9, 0.9, 0.9, alpha = 0.5 )
      )
  }
)

