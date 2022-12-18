## Evocco after export 
edgelistSept26 <- read.csv("~/Desktop/Personal/Portfolio/edgelist.csv", sep=";")
clean_details_followers_round1 <- read.csv("~/Desktop/Personal/Portfolio/details_followers.csv", sep=";")

# so now we have the edgelist and the details cleaned down 
# only have userID in the edgelist that are also in the clean_detail_followers_round1

imp_users <- as.character(clean_details_followers_round1$user_id)

# filter down 
edgelist2 <- edgelistSept26[edgelistSept26$target %in% imp_users, ]

#
clean_details_followers_round1$user_id <- as.numeric(clean_details_followers_round1$user_id)

# then replace their code with their handle 
for (i in 1:length(edgelist2$target)) {
  # find handle
  handle <- clean_details_followers_round1$screen_name[clean_details_followers_round1$user_id == edgelist2$target[i]]
  edgelist2$target[i] <- handle
}

# replace source methods
edgelist2$source[edgelist2$source == "705725394"] <- "cipiopartners"
edgelist2$source[edgelist2$source == "3198733163"] <- "auctusgroupinc"
edgelist2$source[edgelist2$source == "411240061"] <- "apolloglobal"

# network 
library(visNetwork)
nodes <- as.data.frame(c(unique(edgelist2$source), unique(edgelist2$target)))
nodes <- as.data.frame(cbind(nodes,nodes))
colnames(nodes) <- c("id", "label")

edges <- as.data.frame(edgelist2[ ,2:3])
colnames(edges) <- c("to", "from")
visNetwork(nodes, edges)

# after here export nodes and edges
write.csv2(edges, "edges.csv")
write.csv2(nodes, "nodes.csv")


## work on visuals 














