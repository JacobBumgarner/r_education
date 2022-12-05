library(plotly) 

fig1 <- plot_ly(y = c(2, 3, 1), type = 'bar') 

data <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/school_earnings.csv") 
fig2 <- plot_ly(data, x = ~Women, y = ~Men, text = ~School, type = 'scatter', mode = 'markers', color = ~Gap, colors = 'Reds', 
                marker = list(size = ~Gap, opacity = 0.5))%>%  
  layout(xaxis = list(showgrid = FALSE), 
         yaxis = list(showgrid = FALSE)) 
fig2 <- hide_colorbar(fig2) 

fig3<- plot_ly(z = ~volcano, type = "contour") 
fig3 <- hide_colorbar(fig3) 

density <- density(diamonds$carat) 
fig4 <- plot_ly(x = ~density$x, y = ~density$y, type = 'scatter', mode = 'lines', fill = 'tozeroy') 
fig4 <- fig4 %>% layout(xaxis = list(title = 'Carat'), 
                      yaxis = list(title = 'Density'), showlegend=FALSE) 

fig <- subplot(fig1, fig2, fig3, fig4, nrows = 2, margin = 0.05)

fig





a <- plot_ly(values = c(1:10), type = "pie", name = "A", domain = list(row = 0, column = 0), title = "A")
a <- a %>% add_trace(
    values = c(1:5), type = "pie", name = "B", domain = list(row = 0, column = 1), title = "BV"
)
a <- a %>% layout(grid = list(rows = 1, columns = 2))
a
