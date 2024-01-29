# Fig 4. Survey results 1: Model performance across different modeling targets

# Set up ----

# Load libraries
## uncomment the lines below to install the packages
# install.packages("dplyr") 
# install.packages("ggplot2")
# install.packages("tidyquant")

library(readr)
library(dplyr)
library(ggplot2)
library(tidyquant)

# Load data
basedir = '/Users/donghee/Documents/project' # set a path to local project directory
figdir = paste(basedir, '/figures', sep="")


# Fig 4a. Binary Classification ----
rm(list=setdiff(ls(), c("basedir","figdir")))
survey_model_classi <- read_csv(paste(basedir, '/data/survey_result_cls_model.csv', sep=""))
survey_test_classi <- read_csv(paste(basedir, '/data/survey_result_cls_test.csv', sep=""))

survey_model_classi$target <- reorder(survey_model_classi$target,survey_model_classi$acc,max)
survey_test_classi <- subset(survey_test_classi, target!="non-pain conditions")
survey_test_classi$target <- reorder(survey_test_classi$target,survey_test_classi$acc,max)
neworders <- levels(reorder(survey_model_classi$target,survey_model_classi$acc,max))

survey_model_classi$group <- "trainmodel"
survey_test_classi$group <- "indeptest"

survey_classi <- rbind(survey_test_classi,survey_model_classi)
survey_classi$target <- factor(survey_classi$target, levels = neworders)
survey_classi$group <- factor(survey_classi$group, levels = c("trainmodel","indeptest"))

survey_classi %>%
  ggplot(aes(x = target, y = acc, fill = target)) + 
  facet_wrap(~group) +
  geom_boxplot(
    width = .2, 
    outlier.shape = NA,
    alpha = 0.4
  ) +
  ggdist::stat_dots(
    side = "left", 
    dotsize= 1,
    justification=1.2, 
    binwidth = 1,
    alpha = .5
  ) +
  coord_cartesian(xlim = c(1.2, NA), clip = "off") +
  scale_fill_tq() +
  theme_tq() +
  coord_flip() +
  # theme(legend.position = "none",
  #       axis.title.x = element_blank(),
  #       axis.title.y = element_blank(),
  #       axis.text.x = element_blank(),
  #       axis.text.y = element_blank(),
  #       strip.background = element_blank())+
  scale_y_continuous(limits = c(50, 100))

# file save
# ggsave(paste(figdir,"/fig4a.pdf", sep=""), width  = 4.96,height = 4.79,units = "in") % uncomment this line to save the figure


# Fig 4b. Regression ----
rm(list=setdiff(ls(), c("basedir","figdir")))
survey_model_reg <- read_csv(paste(basedir, '/data/survey_result_reg_model.csv', sep=""))
survey_test_reg <- read_csv(paste(basedir, '/data/survey_result_reg_test.csv', sep=""))

survey_model_reg$target <- reorder(survey_model_reg$target,survey_model_reg$corr,max)

survey_test_reg <- subset(survey_test_reg, target!="non-pain conditions")
survey_test_reg$target <- reorder(survey_test_reg$target,survey_test_reg$corr,max)

neworders <- levels(reorder(survey_model_reg$target,survey_model_reg$corr,max))

survey_model_reg$group <- "trainmodel"
survey_test_reg$group <- "indeptest"

survey_reg <- rbind(survey_test_reg,survey_model_reg)
survey_reg$target <- factor(survey_reg$target, levels = neworders)
survey_reg$group <- factor(survey_reg$group, levels = c("trainmodel","indeptest"))


survey_reg %>%
  ggplot(aes(x = target, y = corr, fill = target)) + 
  facet_wrap(~group) +
  geom_boxplot(
    width = .2, 
    outlier.shape = NA,
    alpha = 0.4
  ) +
  ggdist::stat_dots(
    side = "left", 
    dotsize= 2, 
    justification=1.2, 
    binwidth = .01,
    alpha = .5 
  ) +
  coord_cartesian(xlim = c(1.2, NA), clip = "off") +
  scale_fill_tq() +
  theme_tq() +
  # theme(legend.position = "none",
  #       axis.title.x = element_blank(),
  #       axis.title.y = element_blank(),
  #       axis.text.x = element_blank(),
  #       axis.text.y = element_blank(),
  #       strip.background = element_blank())+
  coord_flip() +
  scale_y_continuous(limits = c(0, 1))

# file save
# ggsave(paste(figdir,"/fig4b_1.pdf", sep=""), width  = 4.96,height = 4.79,units = "in") % uncomment this line to save the figure


## biomodal density function for "Pain rating" in training model
df <- survey_model_reg %>% filter(target == "Pain rating") %>% select(corr)

ggplot(df, aes(x = X, color = "grey40", fill = "tomato1")) + 
  geom_density(alpha = 0.5) + 
  coord_cartesian(clip = "off") +
  theme_void() +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        strip.background = element_blank())

# file save
# ggsave(paste(figdir,"/fig4b_2.pdf", sep=""), width  = 4.96,height = 4.79,units = "in") % uncomment this line to save the figure