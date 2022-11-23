library(DropletUtils)
library(scuttle)
library(scater)

# Load the data in
sce <- read10xCounts(samples = (
    "/Users/jacobbumgarner/Desktop/mouse_data/counts_unfiltered/cellranger"
))
sce

# Calculate:
# https://hbctraining.github.io/scRNA-seq/lessons/02_SC_generation_of_count_matrix.html
# `sum` - the total UMI per barcode, aka number of reads per cell
# `detected` - number of reads per transcript in the genome
sce <- addPerCellQC(sce)

plotColData(object = sce, y = "sum") + scale_y_log10()
plotColData(object = sce, y = "detected") + scale_y_log10()

# Numeric visualization of the sum
head(table(sce$sum))

# Visualize the relationship between the sum and detected
plotColData(sce, x = "detected", y = "sum")

# Make a knee plot to identify the cutoff for 'good' and 'bad' cells
# We will quantify the number of UMI per barcode,
# and will plot them in sorted (ranked) order
# ranking seems to be an argsort plus some type of normalization, see here
# https://www.illumina.com/content/dam/illumina-marketing/documents/products/technotes/technote-ranking-snvs.pdf
br <- barcodeRanks(sce)

plot(br$rank, br$total, log = "xy", xlab = "Rank", ylab = "Total")
o <- order(br$rank)
lines(br$rank[o], br$fitted[o], col = "red")

# add the knee and inflection lines
abline(h = metadata(br)$knee, col = "dodgerblue", lty = 2)
abline(h = metadata(br)$inflection, col = "forestgreen", lty = 2)
legend(
    "bottomleft",
    lty = 2,
    col = c("dodgerblue", "forestgreen"),
    legend = c("knee", "inflection")
)

# get the inflection point to find the empty droplets
threshold <- metadata(br)$inflection

empty_droplets <- emptyDrops(sce, lower = 186)
keep_droplets <- empty_droplets$FDR <= 0.01

# now compare the number of original droplets to the 'good' cells
sprintf("Droplets: %i --- Cells: %i", ncol(sce), sum(keep_droplets, na.rm = TRUE))

# Add the 'good' or 'bad' cell features to our experiment
sce$empty <- factor(ifelse(empty_droplets$FDR <= 0.01, "ok", "empty"))
sce$empty[is.na(sce$empty)] <- "empty"

# plot and visualize the differences in cells per barcode based on 'good'/'bad'
plotColData(object = sce, y = "sum", x = "empty", colour_by = "empty")

