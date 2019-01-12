setwd("D:\\NUS Masters\\Lecture Notes\\Web Analytics\\Assignment\\Web Analytics Assign 2 - Xiaoli")

library(pacman)
pacman::p_load(sqldf, igraph, sna)

df = read.csv("routes.csv")
col = c("Airline","Airline_ID","Source_Airport","Source_Airport_ID","Des_Airport","Des_Airport_ID","Codeshare","Stops","Equipment")
#df1 = cbind(rownames(df), df) - if rownames is null
colnames(df) = col 
head(df)
names(df)

# df2 = read.csv("airline.csv")
# col2 = c("Airline_ID","Name","Alias","IATA","ICAO","Callsign","Country","Active")
# colnames(df2) = col2

df3 = read.csv("airport.csv")
col3 = c("Airline_ID","Name","City","Country","IATA","ICAO","Latitude","Longitude","Altitude","Timezone","DST","TZ","Type","Source")
colnames(df3) = col3
head(df3)
names(df3)

# joint_airline = sqldf("select a.airline_id, a.airline_id, a.source_airport, a.source_airport_id, a.des_airport, 
#         a.des_airport_id, a.codeshare, a.stops, a.equipment, 
#         b.name, b.alias, b.iata, b.icao, b.callsign, b.callsign, b.country, b.active
#         from df as a inner join df2 as b
#         on a.airline_id = b.airline_id")

joint_airport = sqldf("select a.airline_id, a.airline_id, a.source_airport, a.source_airport_id, a.des_airport, 
        a.des_airport_id, a.codeshare, a.stops, a.equipment, 
        b.name as name_source, b.city as city_source, b.country, b.iata, b.icao,
        c.name as name_des, c.city as city_des
        from df as a inner join df3 as b
        on a.source_airport = b.iata
        inner join df3 as c
        on a.des_airport = c.iata")

sel_japan = sqldf("select city_source, city_des from joint_airport
                    where country in ('Japan')")

sel_japan_city = sqldf("select city_source, city_des from joint_airport
                        where country in ('Japan') 
                        and name_des in ('Haneda Airport','Narita International Airport',
                       'Kansai International Airport','Fukuoka Airport','New Chitose Airport')")

# sel_source = sqldf("select source_airport, name_source, count(*) from joint_airport group by source_airport, name_source 
#                     having country in ('Japan') order by count(*)")
# sel_des = sqldf("select des_airport, name_des, count(*) from joint_airport group by des_airport, name_des 
#                     having country in ('Japan') order by count(*)")

g = graph_from_data_frame(sel_japan)
g1 = as.undirected(g)

g_city = graph_from_data_frame(sel_japan_city)
g1_city = as.undirected(g_city)

#centralization.degree(g, normalized = TRUE)
#centralization.degree(g_city, normalized = TRUE)

wt = walktrap.community(g1)
le = leading.eigenvector.community(g1)
eb = cluster_edge_betweenness(g1)

plot(wt, g1)
plot(le, g1)
plot(eb, g1)

wt_city = walktrap.community(g1_city)
le_city = leading.eigenvector.community(g1_city)
eb_city = cluster_edge_betweenness(g1_city)

######undirected
plot(wt_city, g1_city)
plot(le_city, g1_city)
plot(eb_city, g1_city)

#####directed
plot(wt_city, g_city)
plot(le_city, g_city)
plot(eb_city, g_city)

maximal.cliques(g1_city)
largest.cliques(g1_city)
cliques(g1_city, min=1)

membership(eb) #highest membership to how many communities
modularity(eb) #division of network into cluster

# df = setNames(cbind(rownames(df), df, row.names = NULL), 
#          c("Airline","Airline ID","Source Airport","Source Airport ID","Des Airport","Des Airport ID","Codeshare","Stops", "Equipment"))
