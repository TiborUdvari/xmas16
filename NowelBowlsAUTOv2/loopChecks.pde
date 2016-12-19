void checkServiceBrush() {

  if (serviceBrush() == false)

    if (millis() > NextMoveTime)
    {

      boolean actionItem = false;
      int intTemp = -1;


      if ((ToDoList.length > (indexDone + 1))   && (Paused == false))
      {
        actionItem = true;
        intTemp = ToDoList[1 + indexDone];  

        indexDone++;
      }
      


      if (actionItem)
      {  // Perform next action from ToDoList::

        if (segmentQueued)
          drawQueuedSegment();  // Draw path segment to screen

        if (intTemp >= 0)
        { // Move the carriage to paint a path segment!  ("This is where the magic happens....")

          int x2 = floor(intTemp / 10000);
          int y2 = intTemp - 10000 * x2;

          int x1 = round( float(x2 - MousePaperLeft) * MotorStepsPerPixel + xMotorPaperOffset);
          int y1 = round( float(y2 - MousePaperTop) * MotorStepsPerPixel); 

          MoveToXY(x1, y1);

          if (BrushDown == true) { 
            if (lastPosition == -1)
              lastPosition = intTemp; 
            queueSegmentToDraw(lastPosition, intTemp);  
            lastPosition = intTemp;
          }

          /*
           IF next item in ToDoList is ALSO a move, then calculate the next move and queue it to the EBB at this time.
           Save the duration of THAT move as "SubsequentWaitTime."
           
           When the first (pre-existing) move completes, we will check to see if SubsequentWaitTime is defined (i.e., >= 0).
           If SubsequentWaitTime is defined, then (1) we add that value to the NextMoveTime:
         
           NextMoveTime = millis() + SubsequentWaitTime; 
           SubsequentWaitTime = -1;
           
           We also (2) queue up that segment to be drawn.
           
           We also (3) queue up the next move, if there is one that could be queued.  We do 
           
           */
           
           
           
           
           
           
           
           
           
        }
        else
        {
          lastPosition = -1;  // For drawing 

          intTemp = -1 * intTemp;

          /*if ((intTemp > 9) && (intTemp < 20)) 
          {  // Change paint color  
            intTemp -= 10; 
            getPaint(intTemp);
          }
          else if ((intTemp >= 20) && (intTemp < 30)) 
          {  // Get water from dish  
            intTemp -= 20;
            getWater(intTemp, false);
          }  
          else if (intTemp == 40) 
          { 
            cleanBrush();
          }*/
          if (intTemp == 30) 
          {
            raiseBrush();
          }
          else if (intTemp == 31) 
          {  
            lowerBrush();
          }
          else if (intTemp == 35) 
          {  
            MoveToXY(0, 0);
          }
        }
      }
    }
}

boolean serviceBrush()
{
  // Manage processes of getting paint, water, and cleaning the brush,
  // as well as general lifts and moves.  Ensure that we allow time for the
  // brush to move, and wait respectfully, without local wait loops, to
  // ensure good performance for the artist.

  // Returns true if servicing is still taking place, and false if idle.

  boolean serviceStatus = false;

  int waitTime = NextMoveTime - millis();
  if (waitTime >= 0)
  {
    serviceStatus = true;
    // We still need to wait for *something* to finish!
  }
  else {
    if (raiseBrushStatus >= 0)
    {
      raiseBrush();
      serviceStatus = true;
    }
    else if (lowerBrushStatus >= 0)
    {
      lowerBrush();
      serviceStatus = true;
    } 
    else if (moveStatus >= 0) {
      MoveToXY(); // Perform next move, if one is pending.
      serviceStatus = true;
    }
    /*
    else if (getWaterStatus >= 0) {
      getWater(); // Advance to next step of getting water
      serviceStatus = true;
    }
    else if (CleaningStatus >= 0) {
      cleanBrush(); // Advance to next cleaning step
      serviceStatus = true;
    }
    else if (getPaintStatus >= 0)
    {
      getPaint(); // Advance to next paint-getting step
      serviceStatus = true;
    }*/
  }
  return serviceStatus;
}


void queueSegmentToDraw(int prevPoint, int newPoint)
{
  segmentQueued = true;
  queuePt1 = prevPoint;
  queuePt2 = newPoint;
}


void drawQueuedSegment()
{    // Draw new "done" segment, on the off-screen buffer.

  int x1, x2, y1, y2;  
  color interA;
  float brightness;

  if (segmentQueued)
  {
    segmentQueued = false;

    offScreen.beginDraw();     // Ready the offscreen buffer for drawing
    offScreen.image(imgMain, 0, 0);
    offScreen.strokeWeight(11); 

    interA = paintset[brushColor];

    if (interA != Water) {
      brightness = 0.25;
      color white = color(255, 255, 255);
      interA = lerpColor(interA, white, brightness);
    }

    offScreen.stroke(interA);

    x1 = floor(queuePt1 / 10000);
    y1 = queuePt1 - 10000 * x1;

    x2 = floor(queuePt2 / 10000);
    y2 = queuePt2 - 10000 * x2;  

    offScreen.line(x1, y1, x2, y2); 

    offScreen.endDraw();

    imgMain = offScreen.get(0, 0, offScreen.width, offScreen.height);
  }
}