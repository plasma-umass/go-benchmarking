require(ggplot2)
require(scales)
require(extrafont)
loadfonts()

my_theme <- function(p) {
    return(p + 
        theme_bw() + 
        theme(
            text = element_text(family = "CMU Serif", size=10),
            legend.title = element_blank(),
            legend.position = "top"
        ) +
        # theme(legend.position = "top") +
        scale_fill_manual(values=c("#ff9966", "#6699ff")) +
        scale_color_manual(values=c("#ff9966", "#6699ff"))
    )
}

my_save <- function(name, p) {
    ggsave(name, width=3.5, height=2.5)
    embed_fonts(name)
}