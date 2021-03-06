## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  dpi = 300
)

library(broomExtra)
library(margins)

## ----basic, out.width="100%"--------------------------------------------------
#Package preload
library(dotwhisker)
library(dplyr)

# run a regression compatible with tidy
m1 <- lm(mpg ~ wt + cyl + disp + gear, data = mtcars)

# draw a dot-and-whisker plot
dwplot(m1)

## ----ci, out.width="100%"-----------------------------------------------------
dwplot(m1, ci = .99)  # using 99% CI

## ----multipleModels, out.width="100%"-----------------------------------------
m2 <- update(m1, . ~ . + hp) # add another predictor
m3 <- update(m2, . ~ . + am) # and another 

dwplot(list(m1, m2, m3))

## ----intercept, out.width="100%"----------------------------------------------
dwplot(list(m1, m2, m3), show_intercept = TRUE)

## ----ggplot, fig.width=4------------------------------------------------------
dwplot(list(m1, m2, m3),
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2)) %>% # plot line at zero _behind_ coefs
    relabel_predictors(c(wt = "Weight",                       
                         cyl = "Cylinders", 
                         disp = "Displacement", 
                         hp = "Horsepower", 
                         gear = "Gears", 
                         am = "Manual")) +
     theme_bw() + xlab("Coefficient Estimate") + ylab("") +
     geom_vline(xintercept = 0, colour = "grey60", linetype = 2) +
     ggtitle("Predicting Gas Mileage") +
     theme(plot.title = element_text(face="bold"),
           legend.position = c(0.007, 0.01),
           legend.justification = c(0, 0), 
           legend.background = element_rect(colour="grey80"),
           legend.title = element_blank()) 

## ----tidyData, out.width="100%"-----------------------------------------------
# regression compatible with tidy
m1_df <- tidy(m1) # create data.frame of regression results
m1_df # a tidy data.frame available for dwplot
dwplot(m1_df) #same as dwplot(m1)

## ----tidy, out.width="100%"---------------------------------------------------
m1_df <- tidy(m1) %>% filter(term != "(Intercept)") %>% mutate(model = "Model 1")
m2_df <- tidy(m2) %>% filter(term != "(Intercept)") %>% mutate(model = "Model 2")

two_models <- rbind(m1_df, m2_df)

dwplot(two_models)

## ----regularExpression, out.width="100%"--------------------------------------
# Transform cyl to factor variable in the data
m_factor <- lm(mpg ~ wt + cyl + disp + gear, data = mtcars %>% mutate(cyl = factor(cyl)))

# Remove all model estimates that start with cyl*
m_factor_df <- tidy(m_factor) %>% 
  filter(!grepl('cyl*', term))

dwplot(m_factor_df)

## ----relabel, fig.width=4-----------------------------------------------------
# Run model on subsets of data, save results as tidy df, make a model variable, and relabel predictors
by_trans <- mtcars %>% 
    group_by(am) %>%                                         # group data by trans
    do(tidy(lm(mpg ~ wt + cyl + disp + gear, data = .))) %>% # run model on each grp
    rename(model=am) %>%                                     # make model variable
    relabel_predictors(c(wt = "Weight",                      # relabel predictors
                     cyl = "Cylinders",          
                     disp = "Displacement",
                     gear = "Gear"))

by_trans

dwplot(by_trans, 
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2)) + # plot line at zero _behind_ coefs
    theme_bw() + xlab("Coefficient Estimate") + ylab("") +
    ggtitle("Predicting Gas Mileage by Transmission Type") +
    theme(plot.title = element_text(face="bold"),
          legend.position = c(0.007, 0.01),
          legend.justification = c(0, 0),
          legend.background = element_rect(colour="grey80"),
          legend.title.align = .5) +
    scale_colour_grey(start = .3, end = .7,
                      name = "Transmission",
                      breaks = c(0, 1),
                      labels = c("Automatic", "Manual"))

## ----custom, fig.width=4------------------------------------------------------
dwplot(by_trans,
       vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2), # plot line at zero _behind_ coefs
       dot_args = list(aes(shape = model)),
       whisker_args = list(aes(linetype = model))) +
    theme_bw() + xlab("Coefficient Estimate") + ylab("") +
    ggtitle("Predicting Gas Mileage by Transmission Type") +
    theme(plot.title = element_text(face="bold"),
          legend.position = c(0.007, 0.01),
          legend.justification = c(0, 0),
          legend.background = element_rect(colour="grey80"),
          legend.title.align = .5) +
    scale_colour_grey(start = .1, end = .1, # if start and end same value, use same colour for all models 
                      name = "Model", 
                      breaks = c(0, 1),
                      labels = c("Automatic", "Manual")) +
    scale_shape_discrete(name = "Model",
                         breaks = c(0, 1),
                         labels = c("Automatic", "Manual"))

## ----clm, out.width="100%"----------------------------------------------------
# the ordinal regression model is not supported by tidy
m4 <- ordinal::clm(factor(gear) ~ wt + cyl + disp, data = mtcars)
m4_df <- coef(summary(m4)) %>% 
  data.frame() %>% 
  tibble::rownames_to_column("term") %>%
  rename(estimate = Estimate, std.error = Std..Error)
m4_df
dwplot(m4_df)

## ----by2sd, out.width="100%"--------------------------------------------------
# Customize the input data frame
m1_df_mod <- m1_df %>%                 # the original tidy data.frame
    by_2sd(mtcars) %>%                 # rescale the coefficients
    arrange(term)                      # alphabetize the variables

m1_df_mod  # rescaled, with variables reordered alphabetically
dwplot(m1_df_mod)

## ----margins, out.width="100%"------------------------------------------------
# Create a data.frame of marginal effects
m5 <- glm(am ~ wt + cyl + mpg, data = mtcars, family = binomial)
m5_margin <- margins::margins(m5) %>%
  summary() %>%
  dplyr::rename(
    term = factor,
    estimate = AME,
    std.error = SE,
    conf.low = lower,
    conf.high = upper,
    statistic = z,
    p.value = p
  )
m5_margin

dwplot(m5_margin)

## ----marginsShort, out.width="100%"-------------------------------------------
dwplot(m5, margins = TRUE)
dwplot(m5, margins = TRUE, ci = .8)

## ----brackets, fig.width=4.5--------------------------------------------------
# Create list of brackets (label, topmost included predictor, bottommost included predictor)
three_brackets <- list(c("Overall", "Weight", "Weight"), 
                       c("Engine", "Cylinders", "Horsepower"),
                       c("Transmission", "Gears", "Manual"))

{dwplot(list(m1, m2, m3), 
        vline = geom_vline(xintercept = 0, colour = "grey60", linetype = 2)) %>% # plot line at zero _behind_ coefs
    relabel_predictors(c(wt = "Weight",                       # relabel predictors
                         cyl = "Cylinders",
                         disp = "Displacement", 
                         hp = "Horsepower", 
                         gear = "Gears", 
                         am = "Manual")) +
    theme_bw() + xlab("Coefficient Estimate") + ylab("") +
    ggtitle("Predicting Gas Mileage") +
    theme(plot.title = element_text(face="bold"),
          legend.position = c(0.993, 0.99),
          legend.justification=c(1, 1),
          legend.background = element_rect(colour="grey80"),
          legend.title = element_blank())} %>% 
    add_brackets(three_brackets)

## ----distribution, fig.height=5, fig.width=5----------------------------------

by_transmission_brackets <- list(c("Overall", "Weight", "Weight"), 
                       c("Engine", "Cylinders", "Horsepower"),
                       c("Transmission", "Gears", "Gears"))
        
{mtcars %>%
    split(.$am) %>%
    purrr::map(~ lm(mpg ~ wt + cyl + gear + qsec, data = .x)) %>%
    dwplot(style = "distribution") %>%
    relabel_predictors(wt = "Weight",
                         cyl = "Cylinders",
                         disp = "Displacement",
                         hp = "Horsepower",
                         gear = "Gears") +
    theme_bw() + xlab("Coefficient") + ylab("") +
    geom_vline(xintercept = 0, colour = "grey60", linetype = 2) +
    theme(legend.position = c(.995, .99),
          legend.justification = c(1, 1),
          legend.background = element_rect(colour="grey80"),
          legend.title.align = .5) +
    scale_colour_grey(start = .8, end = .4,
                      name = "Transmission",
                      breaks = c("Model 0", "Model 1"),
                      labels = c("Automatic", "Manual")) +
    scale_fill_grey(start = .8, end = .4,
                    name = "Transmission",
                    breaks = c("Model 0", "Model 1"),
                    labels = c("Automatic", "Manual"))} %>%
    add_brackets(by_transmission_brackets) +
    ggtitle("Predicting Gas Mileage by Transmission Type") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5))


## ----secretWeapon, fig.width=5------------------------------------------------
data(diamonds)

# Estimate models for many subsets of data, put results in a tidy data.frame
by_clarity <- diamonds %>% 
    group_by(clarity) %>%
    do(tidy(lm(price ~ carat + cut + color, data = .), conf.int = .99)) %>%
    ungroup %>% rename(model = clarity)

# Deploy the secret weapon
secret_weapon(by_clarity, var = "carat") + 
    xlab("Estimated Coefficient (Dollars)") + ylab("Diamond Clarity") +
    ggtitle("Estimated Coefficients for Diamond Size Across Clarity Grades") +
    theme(plot.title = element_text(face="bold"))

## ----smallMultiple, fig.height=7----------------------------------------------
# Generate a tidy data frame of regression results from six models
m <- list()
ordered_vars <- c("wt", "cyl", "disp", "hp", "gear", "am")
m[[1]] <- lm(mpg ~ wt, data = mtcars) 
m123456_df <- m[[1]] %>% 
    tidy() %>%
    by_2sd(mtcars) %>%
    mutate(model = "Model 1")
for (i in 2:6) {
    m[[i]] <- update(m[[i-1]], paste(". ~ . +", ordered_vars[i]))
    m123456_df <- rbind(m123456_df, m[[i]] %>%
                            tidy() %>%
                            by_2sd(mtcars) %>%
                            mutate(model = paste("Model", i)))
}

# Relabel predictors (they will appear as facet labels)
m123456_df <- m123456_df %>% 
  relabel_predictors(c("(Intercept)" = "Intercept",
                     wt = "Weight",
                     cyl = "Cylinders",
                     disp = "Displacement",
                     hp = "Horsepower",
                     gear = "Gears",
                     am = "Manual"))
 
# Generate a 'small multiple' plot
small_multiple(m123456_df) +
  theme_bw() + ylab("Coefficient Estimate") +
  geom_hline(yintercept = 0, colour = "grey60", linetype = 2) +
  ggtitle("Predicting Mileage") +
  theme(plot.title = element_text(face = "bold"), 
        legend.position = "none",
        axis.text.x = element_text(angle = 60, hjust = 1)) 

## ----smallMultiple2, fig.width=4, fig.height=6--------------------------------
# Generate a tidy data frame of regression results from five models on
# the mtcars data subset by transmission type
ordered_vars <- c("wt", "cyl", "disp", "hp", "gear")
mod <- "mpg ~ wt"

by_trans2 <- mtcars %>%
    group_by(am) %>%                        # group data by transmission
    do(tidy(lm(mod, data = .))) %>%         # run model on each group
    rename(submodel = am) %>%               # make submodel variable
    mutate(model = "Model 1") %>%           # make model variable
    ungroup()

for (i in 2:5) {
    mod <- paste(mod, "+", ordered_vars[i])
    by_trans2 <- rbind(by_trans2, mtcars %>% 
                           group_by(am) %>%
                           do(tidy(lm(mod, data = .))) %>%
                           rename(submodel = am) %>%
                           mutate(model = paste("Model", i)) %>% 
                           ungroup())
}

# Relabel predictors (they will appear as facet labels)
by_trans2 <- by_trans2 %>%
    select(-submodel, everything(), submodel) %>% 
    relabel_predictors(c("(Intercept)" = "Intercept",
                         wt = "Weight",
                         cyl = "Cylinders",
                         disp = "Displacement",
                         hp = "Horsepower",
                         gear = "Gears"))

by_trans2

small_multiple(by_trans2) +
    theme_bw() + 
    ylab("Coefficient Estimate") +
    geom_hline(yintercept = 0, colour = "grey60", linetype = 2) +
    theme(axis.text.x  = element_text(angle = 45, hjust = 1),
          legend.position = c(0.02, 0.008), 
          legend.justification=c(0, 0),
          legend.title = element_text(size=8),
          legend.background = element_rect(color="gray90"),
          legend.spacing = unit(-4, "pt"),
          legend.key.size = unit(10, "pt")) +
    scale_colour_hue(name = "Transmission",
                     breaks = c(0, 1),
                     labels = c("Automatic", "Manual")) +
    ggtitle("Predicting Gas Mileage\nby Transmission Type")

