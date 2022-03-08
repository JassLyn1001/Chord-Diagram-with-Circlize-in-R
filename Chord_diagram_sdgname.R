# =====================================================================
# Chord Diagram with Circlize in R Programming Language
# ---------------------------------------------------------------------
# This script contains some codes to visualize circular layout 
# connected by links in order to represent relations between elements. 
# The name of such plot is sometimes called Chord Diagram.
# =====================================================================

# install "circlize" package from CRAN
library("circlize")

# Import all data from your local file system
mypath <- ('D:/Data/Backup_akun_apps/DPIS_2021/Chord_R_SR2021/All_activity.txt') 
dataset <- read.table(mypath, header = FALSE)
datamatrix <- data.matrix(dataset)

# define SDG's colors in basic order
col <- c("#E5243B","#DDA63A","#4C9F38","#C5192D","#FF3A21","#26BDE2","#FCC30B","#A21942",
         "#FD6925","#DD1367","#FD9D24","#BF8B2E","#3F7E44","#0A97D9","#56C02B","#00689D","#19486A")

#define SDG's names for rows and columns (reversed of rownames)
goalnames <- c("No Poverty", "Zero Hunger", "Good Health and Well-being", "Quality Education", "Gender Equality", 
               "Clean Water and Sanitation", "Affordable and Clean Energy", "Decent Work and Economic Growth",
               "Industry, Innovation and Infrastructure", "Reduce Inequalities", "Sustainable Cities and Communities", 
               "Responsible Consumtion and Production", "Climate Action", "Life Below Water", "Life on Land", 
               "Piece, Justice and Strong Instituion", "Partnerships for The Goals")

# Set the rows and columns name.
# Let’s assume that data_m matrix in which rows correspond to starting states 
# (primary option) and columns correspond to ending states (secondary option).
namarow <- goalnames
namacol <- paste0(" ", namarow)
namacol <- rev(namacol)            # reverse the order, start from SDG17: Partenerships for The Goals
rownames(datamatrix) <- namarow
colnames(datamatrix) <- namacol

# colors for raws and columns
rawcol <- col
names(rawcol) <- namarow 
#set columns color to grey in order to represent the secondary option
columncol <- "grey"
columncol <- rep(columncol,17)
names(columncol) <- namacol
grid_col <- append(rawcol, columncol, after = length(rawcol))


#create a chord diagram but without labeling 
circos.par(start.degree = 90)
chordDiagram(datamatrix, grid.col = grid_col,
             annotationTrack = "grid",
             annotationTrackHeight = 0.02,
             preAllocateTracks = 2,
             big.gap = 65, 
             small.gap = 3,
             transparency = 0,
             order = c(rev(colnames(datamatrix)), rev(rownames(datamatrix))))

circos.trackPlotRegion(track.index = 2, panel.fun = function(x, y) {
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  sector.name = get.cell.meta.data("sector.index")
  
  #print labels 
  circos.text(mean(xlim), ylim[1] + 0.1, sector.name, 
              facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5), cex=0.6)
}, bg.border = NA)

title("All Activity", cex = 0.9) # write the title of the plot

#saving the plot (high definition)
dev.copy(jpeg,'plot_allactivity_withlabels.png', width=10, height=7, units="in", res=500)
dev.off()

circos.clear()
