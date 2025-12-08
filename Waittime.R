library(tidyverse)
library(janitor)
library(dplyr)
library(ggplot2)

# read in and clean wait metrics #
wait_time <- read_csv("C:/Users/brian/FINAL BLOG/MTA_Subway_Customer_Journey-Focused_Metrics__2020-2024_20251201.csv") %>% 
  clean_names(.) %>%
  rename(JTime = customer_journey_time_performance)

# isolate wait percentage as numeric by route #
wait_time_sum <- wait_time %>% 
  mutate(JTime = str_remove(JTime, "%"),
         JTime = as.numeric(JTime)) %>%
  group_by(line, period) %>%
  summarise(avg_on_timep = mean(JTime, na.rm = TRUE))

# graph as dumbbell chart #
ggplot(wait_time_sum, aes(x = avg_on_timep, y = line)) +
  geom_line(aes(group = line), linewidth = 1, color = "#808080") +
  geom_point(aes(color = period), size = 3) +
  scale_color_manual(
    values = c("peak" = "#F55A73", "offpeak" = "#19AD81"),
    labels = c("peak" = "Peak Hours","offpeak" = "Off-Peak Hours")) +
  scale_y_discrete(labels = c("JZ" = "J & Z")) +
  labs(
    title = "Average On-Time Performance by Subway Line",
    subtitle = "Peak vs Off-Peak (2020–Present)",
    x = "Average On-Time Performance %",
    y = "Subway Line",
    color = "Time of Day" ) +
  theme_minimal(base_size = 14)+
  theme(plot.title = element_text(size = 20, face = "bold"), plot.subtitle = element_text(size = 16))

# pull in run time, number of station stops, total trips #
run_time <- read_csv("C:/Users/brian/FINAL BLOG/MTA_Subway_RunTime.csv") %>%
  clean_names(.) %>%
  mutate( month = as.Date(month, format = "%m/%d/%Y"),  
    period = case_when(
      time_period %in% c("AM peak", "PM peak") ~ "peak",
      TRUE ~ "offpeak" )) %>%
  
  # use only 2025 data #
  filter(month >= as.Date("2025-01-01")) %>% 
  group_by(line, period) %>%
  summarise(avg_runtime = round(mean(average_actual_runtime, na.rm = TRUE), 2), stops = round(mean(number_of_stops,na.rm = TRUE), 1))

# pull in route lengths #
MTA_length_final <- read_csv("C:/Users/brian/FINAL BLOG/MTA_Length_Final.csv") %>%
  clean_names(.) %>% 
  rename(line = route_id) 

wait_run_join2 <- MTA_length_final %>%
  left_join(run_time, by = "line") %>%
  left_join(wait_time_sum, by = c("line", "period"))

overall_wait <- wait_time_sum %>%
  group_by(period) %>%
  summarise(avg_wait_all_routes = mean(avg_on_timep, na.rm = TRUE))

wait_avg_ranked <- wait_time_sum %>%
  group_by(line) %>%
  summarise( avg_wait = mean(avg_on_timep, na.rm = TRUE)) %>% 
  mutate(rank_wait = rank(avg_wait)) %>% 
  mutate(MTA_priority = line %in% c("N", "R", "Q", "W", "A", "S Rock", "J", "Z"))

# check significance #
model_stops <- lm(
  avg_on_timep ~ length_mile + avg_runtime + stops,
  data = wait_run_join2)

summary(model_stops)
confint(model_stops, level = 0.80)



