#' @rdname comparative_analysis
#' @export
#'
#' @title
#' Performs comparative analysis between two conditions
#'
#' @description
#' Performs comparative analysis between two conditions (e.g. two samples).
#' Given the results of a cell-cell communication analysis of two datasets including the same cell types,
#' \code{comparative_analysis} estimates the differences in the cell-cell communication patterns between corresponding interacting partners in the two datasets.
#'
#' Please note that for simplicity, we address all interacting partners (including non-directional partners such as adhesion molecules) as "ligand-receptor pairs".
#'
#' @author
#' Maria Solovey \email{maria.solovey@helmholtz-muenchen.de}
#'
#' @param cond1_weight_array Numeric array: array of weighted adjacency matrices for condition 1.
#'
#' Note that the function filters out empty weight arrays and the corresponding ligand-receptor pairs.
#'
#' @param cond2_weight_array Numeric array: array of weighted adjacency matrices for condition 2.
#'
#' Note that the function filters out empty weight arrays and the corresponding ligand-receptor pairs.
#'
#' @param cond1_ligand_receptor_pair_df Character data frame: data frame with columns "pair", "ligand", "ligand_complex_composition", "receptor", "receptor_complex_composition" for condition 1.
#'
#' @param cond2_ligand_receptor_pair_df Character data frame: data frame with columns "pair", "ligand", "ligand_complex_composition", "receptor", "receptor_complex_composition" for condition 2.
#'
#' @param cond1_nodes Character string vector: a vector with all cell types in the data.
#'
#' Note that comparative_analysis expects nodes (i.e. cell types) to be the same in both conditions.
#'
#' @param cond2_nodes Character string vector: a vector with all cell types in the data. Default value: cond1_nodes.
#'
#' Note that comparative_analysis expects nodes (i.e. cell types) to be the same in both conditions.
#' @param cond1_name Character string: sample name for condition 1.
#'
#' @param cond2_name Character string: sample name for condition 2.
#'
#' @param dissimilarity Function: dissimilarity function. Default value is d_normWeightDiff.
#'
#' @return A list of:
#'
#' \itemize{
#'   \item{sorted_LRP_df}{
#'
#'   Data frame with columns:
#'   \itemize{
#'     \item "pair" (character string vector): names of ligand-receptor pairs in the same form as they are in ligand_receptor_pair_df$pair.
#'     \item "presence" (character string vector): whether the ligand-receptor pair is present in both conditions ("shared") or only in one of them.
#'     \item "dissimilarity" (numeric vector): dissimilarity value between the topology of ligand-receptor pair graph in two conditions.
#'     The smaller the dissimilarity value, the more similar is the graph topology between the two conditions.
#'     If a ligand-receptor pair is present only in one of the conditions, the dissimilarity is equal to 1.
#'
#'   }
#'   }
#'   \item{dissim_cond1_cond2}{
#'
#'   Numeric matrix:
#'    pairwise dissimilarity between all ligand-receptor pairs in the two conditions (condition 1 in rows, condition 2 in columns).
#'   }
#' }
#'
#' @examples
#' # load AML328_d0_interactions
#' data("AML328_d0_interactions")
#'
#' # load AML328_d29_interactions
#' data("AML328_d29_interactions")
#'
#' my_comparative_analysis <- comparative_analysis(cond1_weight_array = AML328_d0_interactions$weight_array
#'                                              ,cond2_weight_array = AML328_d29_interactions$weight_array
#'                                              ,cond1_ligand_receptor_pair_df = AML328_d0_interactions$ligand_receptor_pair_df
#'                                              ,cond2_ligand_receptor_pair_df = AML328_d29_interactions$ligand_receptor_pair_df
#'                                              ,cond1_nodes = AML328_d0_interactions$nodes
#'                                              ,cond2_nodes = AML328_d29_interactions$nodes
#'                                              ,cond1_name = "AML328_d0"
#'                                              ,cond2_name = "AML328_d29")
#' print(str(my_comparative_analysis))
#'
comparative_analysis <- function(cond1_weight_array
                                 ,cond2_weight_array
                                 ,cond1_ligand_receptor_pair_df
                                 ,cond2_ligand_receptor_pair_df
                                 ,cond1_nodes
                                 ,cond2_nodes = cond1_nodes
                                 ,cond1_name
                                 ,cond2_name
                                 ,dissimilarity = d_normWeightDiff
){

        # check if the nodes in both conditions are the same
        if(!identical(cond1_nodes, cond2_nodes)) stop("ERROR: one of the conditions might contain cell populations that are missing in the other. Please make sure both conditions contain same cell populations.")

        # stratify LRPs by shared or not shared
        all_LRPs <- union(cond1_ligand_receptor_pair_df$pair
                          ,cond2_ligand_receptor_pair_df$pair
        )

        shared_LRP <- intersect(cond1_ligand_receptor_pair_df$pair
                                ,cond2_ligand_receptor_pair_df$pair
        )

        only_cond1_LRPs <- setdiff(cond1_ligand_receptor_pair_df$pair
                                   ,cond2_ligand_receptor_pair_df$pair
        )

        only_cond2_LRPs <- setdiff(cond2_ligand_receptor_pair_df$pair
                                   ,cond1_ligand_receptor_pair_df$pair
        )

        # calculate dissimilarity
        dissim_cond1_cond2 <- calc_dissim_matrix(weight_array1 = cond1_weight_array
                                                 ,weight_array2 = cond2_weight_array
                                                 ,dissimilarity = dissimilarity
        )

        # make sorted LRP list
        sorted_LRP_df <- as.data.frame(t(cbind(sapply(all_LRPs
                                                      ,function(lrp){
                                                              if((length(shared_LRP) != 0) & (lrp %in% shared_LRP)){
                                                                      c(lrp
                                                                        ,"shared"
                                                                        ,unlist(dissim_cond1_cond2[lrp,lrp]))
                                                              } else if((length(only_cond1_LRPs) != 0) & (lrp %in% only_cond1_LRPs)) {
                                                                      c(lrp
                                                                        ,paste("only"
                                                                               ,cond1_name)
                                                                        ,1)
                                                              } else if((length(only_cond2_LRPs) != 0) & (lrp %in% only_cond2_LRPs)) {
                                                                      c(lrp
                                                                        ,paste("only"
                                                                               ,cond2_name)
                                                                        ,1)
                                                              }
                                                      })
        )))
        colnames(sorted_LRP_df) <- c("pair"
                                     ,"presence"
                                     ,"dissimilarity")
        rownames(sorted_LRP_df) <- sorted_LRP_df$pair

        # sort by accending dissimilarity
        sorted_LRP_df$dissimilarity <- as.numeric(sorted_LRP_df$dissimilarity)
        sorted_LRP_df <- sorted_LRP_df[order(sorted_LRP_df$dissimilarity
                                             ,decreasing = T),]

        # sort by presence
        sorted_LRP_df$presence <- factor(sorted_LRP_df$presence
                                         ,levels = c("shared"
                                                     ,paste("only"
                                                            ,cond1_name)
                                                     ,paste("only"
                                                            ,cond2_name)
                                         )
                                         ,labels = c("shared"
                                                     ,paste("only"
                                                            ,cond1_name)
                                                     ,paste("only"
                                                            ,cond2_name)
                                         )
                                         ,ordered = T)
        sorted_LRP_df <- sorted_LRP_df[order(sorted_LRP_df$presence
                                             ,decreasing = F),]

        return(list(sorted_LRP_df = sorted_LRP_df
                    ,dissim_cond1_cond2 = dissim_cond1_cond2)
        )

}
