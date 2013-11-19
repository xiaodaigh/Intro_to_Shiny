d <- parse("j:/haha.R")
dc <- as.character(d)

reactives <- NULL
# find reactive sources
for(t in dc) {
  if( grepl("reactive(.*)$",t)) { #if it is reactive
    g <- gregexpr("^[A-Za-z0-9._]*",t)
    p <- as.numeric(g[[1]])
    l <- attr(g[[1]],"match.length")
    endpoint <-substr(t,p,p+l-1)
    reactives <- c(reactives,endpoint)
  }
}
reactives <- paste(unique(reactives),"\\(\\)",sep="")

# parse each expression
maps <- NULL
i <- 0
for(t in dc) {
  i <- i + 1
  # determine if the expression is reactive() or render
  if( grepl("reactive(.*)$",t)) { #if it is reactive
    g <- gregexpr("^[A-Za-z0-9\\._]*",t)
    p <- as.numeric(g[[1]])
    l <- attr(g[[1]],"match.length")
    endpoint <-substr(t,p,p+l-1)
    endpoint <- paste(unique(endpoint),"\\(\\)",sep="")
  } else if( grepl("^output\\$",t)) { #if it is output
    g <- gregexpr("^output\\$[A-Za-z0-9\\._]*",t)	
    p <- as.numeric(g[[1]])
    l <- attr(g[[1]],"match.length")
    endpoint <-substr(t,p,p+l-1)
  }
  # find input sources
  input.sources <- NULL
  g <- gregexpr("input\\$[A-Za-z0-9\\._]*",t)
  p <- as.numeric(g[[1]])
  l <- attr(g[[1]],"match.length")
  input.sources <- substr(rep(t,2),p,p+l-1)
  
  # find reactive sources
  a <- NULL
  a <- sapply(reactives,grepl,t)
  input.sources <- c(input.sources,names(a)[a])
  
  input.sources <- input.sources[input.sources != ""]
  
  map <- expand.grid(input.sources,endpoint)
  map$i <- rep(i,length(input.sources))
  
  maps <- rbind(maps,map)	
}

maps <- unique(maps)
graphviz.code <- paste("digraph {",
                       paste(
                         paste('"',maps$Var1,'"',sep=""),
                         paste('"',maps$Var2,'"',sep=""),sep="->",collapse=";"),"}");

write(graphviz.code,"c:/temp/g.txt")

intersected <- function(x,y) {
  length(intersect(x,y)) > 0
}

absorb <- function (x,y) {
  if(intersected(x,y)) {
    union(x,setdiff(y,x))
  } else {
    x
  }
}

#determine clusters
ui <- unique(maps$Var1)
ic <- sapply(ui,function(x) {maps$Var1[maps$Var1==x]})
uo <- unique(maps$Var2)
oc <- sapply(uo,function(x) {maps$Var1[maps$Var2==x]})

for(i in 1:length(ic)) {
  x = unique(ic[[i]])
  for(y in oc) {
    x <- absorb(x,y)	
  }
  ic[[i]] <- sort(x)
  #oc <- oc[which(sapply(oc,intersected,x)==FALSE)]
}
ic <- unique(ic)

ic2 <- ic 
for(i in 1:length(ic)) {
  x = ic[[i]]
  for(y in ic2) {
    x <- absorb(x,y)
  }
  ic[[i]] <- sort(x)
  #oc <- oc[which(sapply(oc,intersected,x)==FALSE)]
}
#ic
ic <- unique(ic)
length(unique(ic))

# these are all the clusters we want
ic

#write the clusters back to the map
clusters <- rep(-1,length(maps$i))
for(i in 1:length(ic)) {
  clusters[maps$Var1 %in% ic[[i]]] <- i
}
maps$clusters <- clusters

graphviz.cl.code  <- ""
for(i in 1:length(ic)) {
  graphviz.cl.code <- paste(graphviz.cl.code,paste("subgraph cluster",i,' { label = "cluster #',i,'";',
                                                   paste(
                                                     paste('"',maps$Var1[maps$clusters==i],'"',sep=""),
                                                     paste('"',maps$Var2[maps$clusters==i],'"',sep=""),sep="->",collapse=";"),"}",sep=""));
  
}
graphviz.cl.code <- paste('digraph { graph[rankdir="LR"] ',graphviz.cl.code,"}")

###The unclustered version was written above
###write(graphviz.code,"c:/temp/g.txt")
#The clustered version 
write(graphviz.cl.code,"c:/temp/g.txt")