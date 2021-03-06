% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_dissimilarity_heatmaps.R
\name{plot_dissimilarity_heatmaps}
\alias{plot_dissimilarity_heatmaps}
\title{Plots heatmaps of dissimilarity between two conditions}
\usage{
plot_dissimilarity_heatmaps(
  dissim_cond1_cond2,
  sorted_LRP_df,
  cond1_name,
  cond2_name,
  colors_lrp = c("green", "black"),
  show_legend = TRUE,
  row_names_fontsize = 5,
  colomn_names_fontsize = 5,
  show_column_names = TRUE,
  show_row_names = TRUE,
  width = unit(0.1, "cm"),
  legend_direction = "horizontal",
  legend_width = unit(5, "cm"),
  title_position = "lefttop",
  row_dend_side = "left",
  column_dend_side = "top",
  column_title_side = "top",
  heatmap_legend_side = "bottom",
  ...
)
}
\arguments{
\item{dissim_cond1_cond2}{Numeric matrix: pairwise dissimilarity between all ligand-receptor pairs in the two conditions (condition 1 in rows, condition 2 in columns).}

\item{sorted_LRP_df}{Data frame with columns:

\itemize{

\item "pair" (character string): names of ligand-receptor pairs in the same form as they are in ligand_receptor_pair_df$pair.
\item "presence" (character string): name of the condition in which the ligand-receptor pair is present or "shared" if present in both conditions.
\item "dissimilarity" (numeric): dissimilarity value between the topology of ligand-receptor pair graph in two conditions.

The smaller the dissimilarity value, the more similar is the graph topology between the two conditions.
If a ligand-receptor pair is present only in one of the conditions, the dissimilarity is equal to 1.
}}

\item{cond1_name}{Character string: sample name for condition 1.}

\item{cond2_name}{Character string: sample name for condition 2.}

\item{colors_lrp}{Character string vector: colours for ligand-receptor labels. Default: green for shared, black for unshared.}

\item{show_legend}{Logical: parameter of the \code{\link[HeatmapAnnotation:ComplexHeatmap]{HeatmapAnnotation}} function. Default is TRUE.}

\item{row_names_fontsize}{Numeric: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is 5.}

\item{colomn_names_fontsize}{Numeric: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is 5.}

\item{show_column_names}{Logical: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is TRUE.}

\item{show_row_names}{Logical: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default  is TRUE.}

\item{width}{Object of class "unit": parameter of the \code{\link[HeatmapAnnotation:ComplexHeatmap]{HeatmapAnnotation}} function. Default is unit(0.1, "cm").}

\item{legend_direction}{Character string: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is "horizontal".}

\item{legend_width}{Object of class "unit": parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is unit(5, "cm").}

\item{title_position}{Character string: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is "lefttop".}

\item{row_dend_side}{Character string: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is "left"}

\item{column_dend_side}{Character string: parameter of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function. Default is "top".}

\item{column_title_side}{Character string: parameter of the \code{\link[draw:ComplexHeatmap]{draw}} function. Default is "top".}

\item{heatmap_legend_side}{Character string: parameter of the \code{\link[draw:ComplexHeatmap]{draw}} function. Default is "bottom".}

\item{...}{Any other parameters of the \code{\link[Heatmap:ComplexHeatmap]{Heatmap}} function.}
}
\value{
Two heatmaps:

\itemize{
  \item{clustered heatmap}{

  A heatmap with ligand-receptor pairs clustered by their pairwise dissimilarity.
  }

  \item{sorted heatmap}{

  A heatmap with ligand-receptor pairs sorted by decreasing dissimilarity of shared ligand-receptor pairs.
  }
  }
}
\description{
Plots heatmaps of dissimilarity between two conditions.

In each heatmap, interacting partners from condition 1 are in the rows, and those from condition 2 are in the columns.
On the first heatmap, both rows and columns are clustered by the pairwise dissimilarity.
On the second heatmap, rows and columns are sorted by presence (shared or unshared) of interacting partners in both conditions
and by decreasing pairwise dissimilarity (in shared interacting partners).

Labels of interacting partners are colored by their presence in both conditions (shared or unshared).
The heatmap is colored by the values of the pairwise dissimilarity.

Please note that for simplicity, we address all interacting partners (including non-directional partners such as adhesion molecules) as "ligand-receptor pairs".
}
\examples{
# load comparative analysis
data("AML_comparative_analysis")

plot_dissimilarity_heatmaps(dissim_cond1_cond2 = AML_comparative_analysis$dissim_cond1_cond2,
                            sorted_LRP_df = AML_comparative_analysis$sorted_LRP_df,
                            cond1_name = "AML328-d0",
                            cond2_name = "AML328-d29")

}
\author{
Maria Solovey \email{maria.solovey@helmholtz-muenchen.de}
}
