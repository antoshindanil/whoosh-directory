/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { padNumber } from '@lib/number';


export var formatDayTime = (hours, minutes) => padNumber(hours) + ':' + padNumber(minutes);


export var formatDate = (month, day) => padNumber(month + 1) + '-' + padNumber(day + 1);


const MONTH_DAYS = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

const MONTH_OFFSET = [0];
for (let i = 0; i <= 10; i++) { MONTH_OFFSET[i + 1] = MONTH_OFFSET[i] + MONTH_DAYS[i]; }

const PLAIN_CALENDAR = [];

const fillMonth = month_number => __range__(0, MONTH_DAYS[month_number] - 1, true).map((day_number) => (PLAIN_CALENDAR[MONTH_OFFSET[month_number] + day_number] = formatDate(month_number, day_number)));

for (let month_number = 0; month_number <= 11; month_number++) { fillMonth(month_number); }


export var currentTime = function() {
  const now = new Date();
  return formatDayTime(now.getHours(), now.getMinutes());
};


export var todayDay = function() {
  const now = new Date();
  return (MONTH_OFFSET[now.getMonth()] + now.getDate()) - 1;
};


export var todayDate = () => dateByDayNumber(todayDay());


const correctDayNumber = function(day_number) {
  if (day_number < 0) {
    return 366 + day_number;
  } else if (day_number >= 366) {
    return day_number - 366;
  } else {
    return day_number;
  }
};


export var dateByDayNumber = day_number => PLAIN_CALENDAR[correctDayNumber(day_number)];


export var dayNumberByDate = date => PLAIN_CALENDAR.indexOf(date);

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}