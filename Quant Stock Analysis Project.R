# Install and load necessary packages
install.packages("quantmod")
install.packages("PerformanceAnalytics")
install.packages("ggplot2")
install.packages('reshape2')

library(quantmod)
library(PerformanceAnalytics)
library(ggplot2)
library(reshape2)

# Define the stock symbols for Tesla, Microsoft, and Apple
stocks <- c("TSLA", "MSFT", "AAPL")

# Load stock data from Yahoo Finance
getSymbols(stocks, from = "2020-01-01", to = Sys.Date())

# Extract adjusted closing prices
stock_data <- merge(Ad(TSLA), Ad(MSFT), Ad(AAPL))
colnames(stock_data) <- c("TSLA", "MSFT", "AAPL")

# Calculate daily returns
daily_returns <- na.omit(ROC(stock_data, type = "discrete"))

# Plot daily returns for each stock
plot(daily_returns, main = "Daily Returns of TSLA, MSFT, and AAPL", col = c("red", "blue", "green"), legend.loc = "topright")

# Calculate cumulative returns
cumulative_returns <- cumprod(1 + daily_returns) - 1

# Plot cumulative returns
plot(cumulative_returns, main = "Cumulative Returns of TSLA, MSFT, and AAPL", col = c("red", "blue", "green"), legend.loc = "topright")

# Using ggplot2 for better visualizations of cumulative returns
cumulative_returns_df <- data.frame(Date = index(cumulative_returns), coredata(cumulative_returns))
cumulative_returns_long <- reshape2::melt(cumulative_returns_df, id.vars = "Date")

ggplot(cumulative_returns_long, aes(x = Date, y = value, color = variable)) +
  geom_line() +
  labs(title = "Cumulative Returns of TSLA, MSFT, and AAPL", x = "Date", y = "Cumulative Return") +
  theme_minimal()

# Calculate Sharpe Ratio (assuming a risk-free rate of 0)
sharpe_ratios <- SharpeRatio(daily_returns, Rf = 0, FUN = "StdDev", annualize = TRUE)
print("Sharpe Ratios:")
print(sharpe_ratios)

# Calculate Maximum Drawdown
max_drawdowns <- maxDrawdown(daily_returns)
print("Maximum Drawdown:")
print(max_drawdowns)

# Visualize Sharpe Ratios
barplot(sharpe_ratios, main = "Sharpe Ratios of Tesla, Microsoft, and Apple", col = "blue", ylab = "Sharpe Ratio")

# Visualize Maximum Drawdown
barplot(max_drawdowns, main = "Maximum Drawdowns of Tesla, Microsoft, and Apple", col = "red", ylab = "Maximum Drawdown")

