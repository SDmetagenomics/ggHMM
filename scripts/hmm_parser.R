
### FOR TESTING
#setwd("~/Dropbox/Informatics/Scripts/ggHMM/Example_Output2/hmm_hit_tables/")

### Read in Hit Tables and Scaff2Bin
hits <- read.table("all_hits.txt", stringsAsFactors = F)


### Remove e-values <= 1e-4
hits <- subset(hits, V5 <= 1e-4)


### Order hits by e-value and take best e-value hit for each protein
hits <- hits[order(hits$V5, decreasing = F),]


### Select best hit for every protein by lowest e-value
hits_filt <- hits[!duplicated(hits$V1),]


### Subset filtered hit columns, name, and output result
hits_out <- data.frame(hmm_id = gsub(".gCluster.*", "", hits_filt$V3),
                        gene_name = gsub("[|].*$", "", hits_filt$V1),
                        bin_name = gsub("^.*[|]", "", hits_filt$V1),
                        bit_score = hits_filt$V6, 
                        e_value = hits_filt$V5,
                        other_stats = hits_filt$V3)

write.table(hits_out, "Hits_Filtered_Out.txt", quote = F, sep = "\t", row.names = F, col.names = T)


### Internal testing to make sure we are not removing genes if they are hit twice 
#length(unique(hits$V1))
#length(unique(hits_filt$V1))
#identical(unique(hits$V1), unique(hits_filt$V1))
