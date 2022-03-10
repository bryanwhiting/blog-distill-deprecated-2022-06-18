Notes


Blogs:

  1. how to create the calendar plot
2. How to analyze strava + peloton data
3. peloton KJ conversion chart (name it the same as the
                                other blog for SEO)
4. Set up a self-updating dash

Dashboard:

  - Calendar + two best/last tables + goal-setting table
(kj/duration)
- Combine all lower-level plots into a grid

TODO:

  - [x] Add weekly stats below the calendar
- [x] Update run data so it's by date (not by activity)
- [x] fix peloton date time
- [x] put months on top
- [x] color months
- [x] Refactor the code
- [x]
- [x]
- [x]
* Set up daily workflow
* make last 10 runs table
* put tables side by side (as images?)

* Build a cycling calendar view for durations
* Build a run calendar for miles on a day

Ideas: \* time spent on bike \* leaderboard %

Formatting:
* fix dates in tables (match the "%a" format)
* date break plots by quarter
* Fix the pace for > 60 minutes (use an HMS format...)
* Calendar plot:
  * Reverse direction of the days (Top = Sun, bot = Sat)
  * Add duration as an alpha fill overlay (1, 1.5, 2, 3, 4.5, 6) for records
  * Add month's count in name?
  * Round the corners of the tiles: <https://rud.is/b/2019/09/27/100-stacked-chicklets/>

  Deprecated:

  * plot avg watts over last
10 rides (so I can know how I'm trending recently). Doesn't do much good
          to see plot of avg watts over time. That's just novelty. And I already
have my table of "last ride", so I know where I'm trending. Maybe add to
          table last 3 rides? Not useful.

          [Peloton R package](https://lgellis.github.io/pelotonR/)

          -   can get all workouts quickly
          -   can get metadata on workout (total difficulty)

          Other R package (limits to 100 workouts), but offers: \* can't get
leaderboard rank (need other R package for that) \* can't get miles
          ridden








# Read from raw data
library(tidyverse)
df_raw <- read_csv("data/bwheazy_workouts.csv")
glimpse(df_raw)
n


# SCRATCH


# Ideas:
#   * time spent on bike
#   * leaderboard %

# ```{r}
# devtools::install_github("bweiher/pelotonR")
# library(pelotonR)
# Sys.setenv(
#   PELOTON_LOGIN = 'bryan.g.whiting@gmail.com',
#   PELOTON_PASSWORD = 'Silvermin3!peloton'
# )
# peloton_auth()
#
# x <- get_my_info()
#
# workouts <- get_all_workouts(x$id, n=200)
# workout_ids <- workouts$id
# wd <- get_workouts_data(workout_ids = workout_ids)
# ```

# ```{r}
# df <- wd %>%
#   mutate(
#     date = as.Date(end_time),
#     time_spent = end_time - created_at,
#     rank = leaderboard_rank/total_leaderboard_users,
#     kj_output = total_work / 1000
#     )
# glimpse(df)
#
# df %>%
#   count(fitness_discipline, sort=T)
#
#
# df %>%
#   filter(fitness_discipline == 'cycling') %>%
#   select(date, kj_output) %>%
#   ggplot(aes(x = date, y = kj_output)) +
#   geom_point()
# ```



