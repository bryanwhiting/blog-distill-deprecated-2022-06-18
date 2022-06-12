#' Peloton and Strava Functions
#'

#' Date function
#'
mutate_dates <- function(df){
  # take last 12 months only
  mutate(df,
         week = as.Date(lubridate::floor_date(date, unit='week')),
         wday = lubridate::wday(date),
         mday = lubridate::mday(date),
         month = month(date),
  ) %>%
    filter(date > floor_date(Sys.Date() - 364))
}


#' Average watts calculator:
#' https://www.reddit.com/r/pelotoncycle/comments/ei4s9e/comment/fcrpdm6/?utm_source=share&utm_medium=web2x&context=3
#' other chart: https://www.brygs.com/peloton-watts-kj/
#' 1 (W)att = 1 (J)oule / second
#' 500 kj = 500,000 J
#' (500,000 J) / (30 minutes x 60 seconds/minute) = 277 W average
calc_watt_average <- function(kj_output, duration){
  (kj_output * 1000) / (duration * 60)
}


#' Load Peloton data
#'
#'
load_peloton_workouts <- function(){
  workouts <- get_workouts_df()

  df <- workouts %>%
    mutate(
      # dates
      datetime = as_datetime(created_at, tz = "US/Pacific"),
      date = as.Date(datetime, tz = "US/Pacific"),
      # ride calculations
      avg_watts = calc_watt_average(total_work/1000, peloton.ride.duration/60),
      duration = as.factor(peloton.ride.duration/60),
      kj = total_work/1000,
      pace_kj_min = kj/peloton.ride.duration
    ) %>%
    mutate_dates() %>%
    arrange(datetime) %>%
    group_by(duration) %>%
    mutate(
      rank = row_number(),
      pr_local = kj == cummax(kj),
      pr_global = kj == max(kj)
    ) %>%
    select(date, datetime, everything()) %>%
    ungroup()

  return(df)
}


#' Extract Strava Data
#'
extract_strava_data <- function(x) {
  tibble(
    type = x$type,
    distance_meters = x$distance,
    distance_miles = x$distance/1609.34,
    elapsed_time_sec = x$elapsed_time,
    moving_time_sec = x$moving_time,
    datetime = as_datetime(x$start_date_local),
    date = as_date(x$start_date_local),
    elevation_gain = x$total_elevation_gain,
    elevation_high = x$elev_high,
    elevation_low = x$elev_low,
    start_latitude = x$start_latitude,
    start_longitude = x$start_longitude,
    average_speed = x$average_speed,
  )
}

#' Strava Data
#'
load_strava_data <- function(stoken){
  # myinfo <- get_athlete(stoken, id = my_strava_id)
  ls_runs <- get_activity_list(stoken)

  df_runs <- map_df(ls_runs, extract_strava_data) %>%
    # Since I sometimes had multiple runs in day,
    # I just care about how much I ran on a date.
    # I'll consider this just "one" run
    group_by(date, type) %>%
    summarize(
      distance_miles = sum(distance_miles),
      elapsed_time_sec = sum(elapsed_time_sec),
      moving_time_sec = sum(moving_time_sec),
      datetime = min(datetime),
      n_runs = n(), #
    ) %>%
    filter(distance_miles > 0.5) %>%
    mutate_dates() %>%
    mutate(
      pace = elapsed_time_sec/distance_miles/60,
      pace_str = paste0(
        floor(pace),
        ":",
        str_pad(floor((pace %% 1) * 60), width=2, side='right', pad='0')),
      duration = floor(distance_miles),
      minutes = elapsed_time_sec/60,
      minutes_str = paste0(
        floor(minutes),
        ":",
        str_pad(floor((minutes %% 1) * 60), width=2, side='right', pad='0')),
    )  %>%
    arrange(date) %>%
    group_by(duration, type) %>%
    mutate(
      pr_local = pace == cummin(pace),
      pr_global = pace == min(pace)
    ) %>%
    ungroup()

  return(df_runs)
}
