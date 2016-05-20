public with sharing class DateUtils {

	public static DateTime addBusinessDays(DateTime startDateTime, Integer days) {
		Integer daysToAdd = 0;
		Datetime theDate = startDateTime;
		while (days > 0) {
			 theDate = theDate.addDays(1);
			 String day = theDate.format('E');
			 if (day != 'Sat' && day != 'Sun') {
			 	days = days - 1;
			 }
		}
		System.debug(theDate);
		return theDate;
	}

}