; No dependencies

class DateTime {

   static Date {
      get => FormatTime(, "yy.MM.dd")
   }

   static Time {
      get => FormatTime(, "HH:mm")
   }

   static WeekDay {
      get => FormatTime(, "dddd")
   }

   /**
    * YYYY - 4
    * MM - 2
    * DD - 2
    * HH - 2
    * 24 - just means there's no AM/PM
    * MI - 2
    * SS - 2
    * 14 characters total in the YYYYMMDDHH24MISS timestamp
    * @type {Integer}
    */
   static CorrectTimestampLength := 14

   /**
    * If you use "1" as a timestamp, it will mean "1000 years".
    * You would probably expect "1" to be "1 second".
    * This method converts your timestamp to match this expectation.
    * @param timestamp *Integer* A number you intend to use as a YYYYMMDDHH24MISS timestamp
    * @returns {Integer} A correctly formatted YYYYMMDDHH24MISS timestamp
    */
   static CorrectTimestamp(timestamp) {
      while StrLen(timestamp) < DateTime.CorrectTimestampLength {
         timestamp := 0 timestamp
      }
      return timestamp
   }

   /**
    * The YYYYMMDDHH24MISS timestamp is really annoying to work with,
    * use this method to convert it to an object.
    * The time in properties will have leading zeros if necessary.
    * @param timeStamp *YYYYMMDDHH24MISS* timestamp.
    * Accepts an incomplete one, where "10000" would mean 1 hour:
    * the leading zeros required for a correct timestamp are added automatically.
    * @returns {Object} Available properties: years, months, days, hours, minutes, seconds.
    */
   static ParseTimestamp(timeStamp := A_Now) {
      timeStamp := this.CorrectTimestamp(timeStamp) ;if there are no leading zeros in the timestamp, "10000" would be considered "the year 1000" rather than "1 hour"

      years   := SubStr(timeStamp, 1, 4)
      months  := SubStr(timeStamp, 5, 2)
      days    := SubStr(timeStamp, 7, 2)
      hours   := SubStr(timeStamp, 9, 2)
      minutes := SubStr(timeStamp, 11, 2)
      seconds := SubStr(timeStamp, 13, 2)

      return {
         years:   years,
         months:  months,
         days:    days,
         hours:   hours,
         minutes: minutes,
         seconds: seconds
      }
   }

   /**
    * Convert a YYYYMMDDHH24MISS timestamp into the amount of seconds it is.
    * Years and months are ignored because months are of different lengths.
    * This is useful for specifying the amount of time to pass in the format of the timestamp, rather than having to do math.
    * @param timeStamp *YYYYMMDDHH24MISS*
    * @returns {Integer}
    */
   static ConvertToSeconds(timeStamp) {
      timeObj := this.ParseTimestamp(timeStamp)

      daysMs    := timeObj.days * 86400
      hoursMs   := timeObj.hours * 3600
      minutesMs := timeObj.minutes * 60

      return daysMs + hoursMs + minutesMs + timeObj.seconds
   }

   /**
    * Add a timestamp to a timestamp.
    * Months and years are completely ignored on toAdd, so use base as the number you want to add to
    * and toAdd as the date you're adding to it
    * @param base *YYYYMMDDHH24MISS*
    * @param toAdd *YYYYMMDDHH24MISS*
    * @returns {YYYYMMDDHH24MISS}
    */
   static AddTimestamp(base, toAdd) {
      base := this.CorrectTimestamp(base)
      toAddObj := this.ParseTimestamp(toAdd)
      base := DateAdd(base, toAddObj.seconds, "seconds")
      base := DateAdd(base, toAddObj.minutes, "minutes")
      base := DateAdd(base, toAddObj.hours, "hours")
      base := DateAdd(base, toAddObj.days, "days")
      base := this.DateAddBig(base, toAddObj.years toAddObj.months)
      return base
   }

   /**
    * DateAdd doesn't let you add months or days.
    * Do so using this method.
    * @param dateTime *YYYYMMDDHH24MISS*
    * @param dateTimeToAdd *YYYYMMDDHH24MISS* 100 is one year. 10 is ten months.
    * @returns {YYYYMMDDHH24MISS}
    */
   static DateAddBig(dateTime, dateTimeToAdd) {

      static TimestampHasYears := () => StrLen(dateTimeToAdd) > 2
      static GetYearAmount     := () => SubStr(dateTimeToAdd, 1, -2)
      static GetMonthAmount    := () => SubStr(dateTimeToAdd, -2)

      static CalculateFullYearsToAdd  := () => addYears + (months + addMonths) // 12
      static CalculateRemainingMonths := () => Mod(months + addMonths, 12)

      timeObj := this.ParseTimestamp(dateTime)

      years  := timeObj.years
      months := timeObj.months
      rest   := timeObj.days timeObj.hours timeObj.minutes timeObj.seconds

      addYears  := TimestampHasYears() ? GetYearAmount() : 0

      addMonths := GetMonthAmount()

      if months + addMonths > 12 {
         addYears := CalculateFullYearsToAdd()
         months := CalculateRemainingMonths()
      } else {
         months := months + addMonths
      }

      if StrLen(months) < 2 {
         months := 0 months
      }

      years := years + addYears

      return years months rest
   }
}