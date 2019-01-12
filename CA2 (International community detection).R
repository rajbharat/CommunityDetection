library(readxl)
library(igraph)

setwd("C:\\Users\\")

df <- readxl::read_excel("route.xlsx", sheet = "flight pairs")
df_dataFrame <- data.frame(df)

g <- graph_from_data_frame(df_dataFrame)
g <- as.undirected(g)

plot(g, vertex.size = 8, vertex.color="SkyBlue2", vertex.frame.color = "NA")

#maximal.cliques finds all maximal cliques in the input graph.
maximal.cliques(g, min = 3)
clique.number(g)

# graph. A clique is largest if there is no other clique including more vertices.
largest.cliques(g)
a <- largest.cliques(g)

# Top 3 cliques
clique1 <- a[[1]]; clique2 <- a[[2]]; clique3 <- a[[3]]

g2_1 <- induced.subgraph(graph=g,vids=clique1)
g2_2 <- induced.subgraph(graph=g,vids=clique2)
g2_3 <- induced.subgraph(graph=g,vids=clique3)
# plot the top 3 cliques
plot(g2_1, vertex.size = 30, vertex.color="SkyBlue2", vertex.frame.color = "NA", vertex.label.cex = 2)
plot(g2_2, vertex.size = 30, vertex.color="SkyBlue2", vertex.frame.color = "NA", vertex.label.cex = 2)
plot(g2_3, vertex.size = 30, vertex.color="SkyBlue2", vertex.frame.color = "NA", vertex.label.cex = 2)

# walktrap.community, a community finding algorithm, 
wc <- walktrap.community(g)

# calculate the modularity
modularity(wc)
# show the membership
membership(wc)
plot(wc, g)

# leading.eigenvector.community
lec <- leading.eigenvector.community(g)
lec
leading.eigenvector.community(g, start=membership(lec))
modularity(lec)
membership(lec)

plot(lec, g)
dendPlot(lec)

# fastgreedy.community 
fc <- fastgreedy.community(g)
fc
modularity(fc)
membership(fc)
dendPlot(fc)
rm(list = ls())
graphics.off()