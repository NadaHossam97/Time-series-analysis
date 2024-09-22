# Load necessary libraries
library(readxl)
library(ggplot2)
library(forecast)
library(dplyr)

# Load the data
data <- read_excel(".\\Gold.xlsx")

# Convert Date column to Date type
data$Date <- as.Date(data$Date)

# Plot the time series
ggplot(data, aes(x = Date, y = Price)) +
  geom_line(color = "blue") +
  ggtitle("Gold Price Over Time") +
  xlab("Date") +
  ylab("Price")

# Calculate moving averages
data <- data %>%
  arrange(Date) %>%
  mutate(SMA_30 = zoo::rollmean(Price, 30, fill = NA))

# Plot the time series with moving average
ggplot(data, aes(x = Date)) +
  geom_line(aes(y = Price), color = "blue", size = 1) +
  geom_line(aes(y = SMA_30), color = "red", size = 1, linetype = "dashed") +
  ggtitle("Gold Price with 30-Day Moving Average") +
  xlab("Date") +
  ylab("Price")

# Convert data to time series object for forecasting
ts_data <- ts(data$Price, start = c(2019, 9), frequency = 365)

# Plot decomposed time series
decomposed <- decompose(ts_data)
plot(decomposed)

# Apply ARIMA model for forecasting
fit <- auto.arima(ts_data)
forecasted <- forecast(fit, h = 30) # Forecast for next 30 days

# Plot forecast
plot(forecasted)