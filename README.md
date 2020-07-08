# Raycast

Raycast is a very simple Processing raycast implementation.

## Installation

To use the program, you first need to have Processing installed. Download it from the [official website](https://processing.org/download).

## Usage

To open the project:
1. Make sure all of the .pde files are inside of a directory named after one of them.
2. Open the project by double-clicking on one of the .pde files and select the installed Processing version to open it.
3. Compile and run the sketch by pressing the arrow button in the top left corner.

To use the program:
4. Start drawing a new line by left-clicking somewhere in the sketch window.
5. Complete the line by left-clicking again where you want the line to end. Pressing the escape-key cancels the currently drawing line and so does switching to cast mode.
6. Press the space-key to switch to cast mode (and back again).
7. In cast mode, you can now move the mouse around to see how the rays collide with the lines previously drawn

## Maths

DISCLAIMER: 
I did not search up any of the following maths on the internet because I wanted to figure it out myself, so it is possible that there are better ways to do this or some of the calculations / explanations are actually wrong.

### Line Equations

Checking whether two lines intersect is not very hard, but requires me to have the equations of both lines. So the first thing to do is to calculate the line equation using the starting and the end point.  
To do this, we first have to find which of the two points is farther away from the coordinate origin respectively to the x-Axis. Due to the fact that in processing the origin is in the top left center and increments to the right for the x-Axis and down for the y-Axis we can simply check which of the two points' x-Coordinate is greater.

With this knowledge we can now already calculate the slope of the line, which is defined as the ratio between the difference on the y-Axis and the difference on the x-Axis of the two points:
``` java
float deltaX = biggerPos.x - smallerPos.x;
float deltaY = biggerPos.y - smallerPos.y;
slope = deltaY / deltaX;
```

For the y-intercept of the line we can rearrange the general linear equation to solve for the intercept and substitute the coordinate with one of the known points:  
```f(x) = ax + b```  
```y = ax + b```  
```b = y − ax```  

Translated into code it looks like this:

``` java
intercept = smallerPos.y - slope * smallerPos.x;
``` 

The lines are not infinite like the equations would suggest though, so we need to define the interval in which we would like the line to intersect with others.  
The lower interval bound is set to the smaller point's x-Coordinate and the higher bound to the one of the bigger point. 

Also there is a special case, whose equation calculation would result in an error: if the line is vertical, the calculation of the slope would be a division by zero. And since continuous functions are not allowed to have multiple y-Values for one x-Value, a vertical line cannot be represented by an equation.  
Instead we create a variable which just holds a boolean that indicates whether the line is vertical. Now the interval bounds are set to the two points' vertical positions insted. Because the interval in now only relevant for height, we need to store the x-Coordinate of the vertical line in a seperate variable.

### Intersections

Now that we have the equations for both lines we can calculate if and where the two lines meet. For this step we can equate two general linear equations and rearrange them to solve for x:  
```y = ax + b```  
```y = cx + d```  

```ax + b = cx + d```  
```ax − cx = d − b```  
```x * (a − c) = d − b```  
```x = (d − b) / (a − c)```  

Which again in the code can be written as:

``` java
float x = (two.equation.intercept - one.equation.intercept) / (one.equation.slope - two.equation.slope);
```

Then, it is necessary to check whether the calculated intersection is inside the interval of both lines, because if it is not, there also is no "real" intersection as the lines do not extend to where they would meet.

Once again the situation is different if one of the two lines is vertical, because then it is not necessary (and actually wrong) to perform this calculation. Instead all that is needed to do is to calculate the vertical position of the non-vertical line at he position of the vertical one.  
This is easily done by inserting the x-Coordinate of the vertical line into the equation of the non-vertical one:
``` java
float y = nonvertical.equation.calculateYAt(vertical.equation.horizontalPosition)
```
All that is left to do now is once again to check whether this y-Coordinate is inside the interval of the vertical line and whether the x-Coordinate of the vertical line is inside the interval of the non-vertical line.

## Project Status

This project is still a work-in-progress and I will continue working on it until all of the following bullet points are either done or i grow tired of this project and move on to something else.

* There are still issues with the collision of non-vertical lines with vertical ones.
* It would be interesting to have the option to draw circles too, but I am still trying to figure out how this would have to be calculated.