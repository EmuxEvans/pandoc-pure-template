#!/usr/bin/env Rscript

# Load packages
library(ggplot2) 
library(Cairo) 
library(showtext) 
require(grid) 
require(scales) 
require(knitr) 

# Global settings for knitr
## Theme
theme_pandoc <- function(base_size = 12) {
  background_color="#FCFCFC"
  font_color="#0077AA"
  asis_color="#708090"
  theme(plot.background = element_rect(fill=background_color, colour=background_color),
          title = element_text(colour = font_color, size = 25),
          axis.text = element_text(colour = asis_color, size = 25),
          axis.text.x = element_text(size = 18, colour = font_color),
          axis.title = element_blank(),
          axis.line = element_line(colour = font_color),
          axis.ticks = element_line(colour = font_color),
          panel.margin = unit(0, "cm"),
          panel.background = element_rect(fill = background_color, colour = background_color),
          panel.grid.major.x = element_line(colour = font_color, linetype = "dashed"),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.x = element_line(colour = font_color, linetype = "dashed"),
          panel.grid.minor.y = element_blank()
  )
}

## Figure prefix as 'fig-'
opts_knit$set(unnamed.chunk.label = 'fig')

## Do not show the code and result on the page
opts_chunk$set(echo = FALSE, results = 'hide', fig.cap = '')

## Create utf8 hook to produce figure including UTF-8 encoding
## Powered by Cairo and showtext 
knit_hooks$set(utf8 = function(before, options, envir){
  if(before)
  {
    figure_name <<- fig_path('', options)
    CairoPNG(paste(figure_name, sep = ""), width=1400)
    showtext.begin()
  }
  else
  { 
    #dev.off(); #Not work, so I move it back to the end of chunk code in Rmd file
    ext = options$fig.ext
    cmd_rename = paste("mv ", figure_name, " ",  figure_name, ".", ext, sep = "")
    system(cmd_rename)
  }
})

# Generate HTML document
knit("analysis.Rmd")
system("pandoc analysis.md -o analysis.html --template template/pandoc --self-contained --toc")
