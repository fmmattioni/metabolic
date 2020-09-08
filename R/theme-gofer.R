## this is the general theme applied to every graph in the GOfER diagram
## this function is internal only and will not be exported

theme_gofer <- function(strip_background = "#1f58b5", margins = c(0, 0, 0, 0), line_plot = FALSE) {
  if(line_plot) {
    ggplot2::theme_light() +
      ggplot2::theme(
        panel.grid.major = ggplot2::element_line(size = 0.5, linetype = 'solid', colour = "black"),
        panel.grid.minor = ggplot2::element_blank(),
        axis.text.y = ggplot2::element_text(size = 8),
        panel.background = ggplot2::element_blank(),
        panel.border = ggplot2::element_blank(),
        plot.background = ggplot2::element_blank(),
        plot.margin = ggplot2::unit(margins, "cm"),
        axis.title.y = ggplot2::element_blank(),
        strip.background = ggplot2::element_rect(fill = strip_background),
        strip.text = ggplot2::element_text(size = 15, colour = "white"),
        legend.position = "none"
      )
  } else {
    ggplot2::theme_light() +
      ggplot2::theme(
        panel.background = ggplot2::element_blank(),
        panel.border = ggplot2::element_blank(),
        panel.grid = ggplot2::element_blank(),
        plot.background = ggplot2::element_blank(),
        plot.margin = ggplot2::unit(margins, "cm"),
        axis.title = ggplot2::element_blank(),
        axis.text = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        strip.background = ggplot2::element_rect(fill = strip_background),
        strip.text = ggplot2::element_text(size = 15, colour = "white"),
        legend.position = "none"
      )
  }
}
