

Data Science Captone:  Yelp Data Analysis
========================================================
author: Jaehyun Shin
date: 21 Nov 2015


The purpose of this Study
========================================================
- <span style="font-size:40px;font-weight:bold">Find the correlation between a variety of attribution and rating including additional service which business provides.</span>
<br/><br/>
- <span style="font-size:40px;font-weight:bold">Build rating prediction model based on attribute data.</span>


Business Attributes And Category
========================================================

- Category (783 categories exist.)

```
[1] "Doctors"          "Health & Medical" "Nightlife"       
[4] "Active Life"      "Mini Golf"        "Golf"            
[7] "Shopping"         "Home Services"   
```
- Attributes (78 attributes exist.)

```
[1] "By.Appointment.Only"  "Happy.Hour"           "Accepts.Credit.Cards"
[4] "Good.For.Groups"      "Outdoor.Seating"      "Price.Range"         
[7] "Good.for.Kids"        "Alcohol"             
```


Methodology
========================================================
Model an prediction algorithm through the relevant data.
Since the relevant data is to measure the correlation between attributes and stars, "classification modeling" will be used, and "rpart", a type of the algorithm, will be adopted.

```
      RMSE   Rsquared 
0.70710678 0.03560378 
```
The error level is comparatively high when using `postResample` to measure. But while considering the fact that the relevant value is rating, the difference between the estimation and the actual measured value is examined.

Final Analysis
========================================================

![plot of chunk unnamed-chunk-5](slide-figure/unnamed-chunk-5-1.png) 

Cases in which the error range of the ratings is below 0.5 is 72.1830986% of all data.

As shown on the graph, the difference between the estimation and actual measured value is mostly concentrated between -0.5 ~ 0.5, and since the median value and average value are very close to 0, the data is reliable.
