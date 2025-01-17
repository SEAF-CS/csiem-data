function mdate = calc_dates(sdata);

theyr = 2013;

themonth = floor(sdata);

thefract = sdata - themonth;

theday_part = eomday(theyr,themonth) .* thefract;

theday = floor(theday_part);

thehours = theday_part - theday;

mdate = datenum(theyr,themonth,theday) + thehours;

