## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----triangle_drawing, echo=FALSE, fig.width=5, fig.height=4-------------
plot(c(-1,5), c(0,4), type = "n", xlab = "x", ylab = "f(x)", axes = FALSE)
lines(c(0,1), c(0,3), col = "red")
lines(c(1,4), c(3,0), col = "red")
axis(2, at = c(0,3), labels = c("0","h"), las = 2)
axis(1, at = c(0,1,4), labels = c("a", "c", "b"))
box()

