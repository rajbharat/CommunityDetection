library(sna)
library(readxl)
library(igraph)

setwd("C:\\Users\\")

df <- readxl::read_excel("route.xlsx", sheet = "community1")
#W <- data.frame(df)
W <- as.matrix(df)
W <- graph_from_adjacency_matrix(W)

# Traditional statistics
degree(W)
closeness(W)
betweenness(W)

# another way by applying the KEYPLAYER package
library(keyplayer)
df <- readxl::read_excel("route.xlsx", sheet = "community1")
W <- data.frame(df)
W <- as.matrix(df)

## In terms of indegree.
kpset(W, size = 2, type = "degree", cmode = "indegree", method = "max")
## In terms of indegree in the binarized network.
kpset(W, size = 2, type = "degree", cmode = "indegree", binary = TRUE, method = "max")
## In terms of mreach.degree.
kpset(W, size = 2, type = "mreach.degree", cmode = "indegree", M = 1, binary = TRUE)
## In terms of mreach.closeness.
kpset(W, size = 2, type = "mreach.closeness", cmode = "indegree", M = 1)
## In terms of indegree via parallel computation using 2 CPU cores.
kpset(W, size = 2, type = "degree", cmode = "indegree", parallel = TRUE, cluster = 2)