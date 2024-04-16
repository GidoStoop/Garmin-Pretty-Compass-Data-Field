import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Math;
import Toybox.Position;

class PrettyCompassWidgetView extends WatchUi.View {

    

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        var myTimer = new Timer.Timer();
        myTimer.start(method(:requestUpdate), 2000, true);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        requestUpdate();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var centerX = Math.round( screenWidth / 2 );
        var centerY = Math.round( screenHeight / 2 );
        var developerWidth = 215.0;
        var DevUserRatio = screenWidth / developerWidth;

        var arrayX = [-106,-107,-5,-4,7,-5,-4,-3,6,7,-4,-3,-2,6,7,-4,-3,-2,6,7,-4,-3,-2,-1,6,7,-4,-1,
                        0,6,7,-4,0,1,6,7,-4,0,1,6,7,-4,1,2,6,7,-4,2,3,6,7,-4,3,4,6,7,-4,3,4,5,6,7,-4,4,5,6,7,-4,5,6,7,-4,6,7,-4,-77,64,65,66,67,68,69,70,71,72,73,-78,-77,-57,-56,64,65,72,73,-77,-76,-57,64,65,-77,-76,-67,-66,-58,-57,64,65,-76,-75,-67,-66,-58,64,65,-76,-75,-68,-67,-66,-59,-58,64,65,-75,-68,-67,-66,-59,-58,64,65,-75,-74,-68,-67,-66,-65,-59,64,65,66,68,-75,-74,-69,-68,-66,-65,-60,-59,64,65,66,67,68,69,-74,-69,-68,-65,-64,-60,-59,64,65,-74,-73,-70,-69,-65,-64,-60,64,65,-73,-70,-69,-64,-61,-60,64,65,-73,-72,-71,-70,-64,-63,-62,-61,64,65,-73,-72,-71,-70,-64,-63,-62,-61,64,65,-72,-71,-70,-63,-62,-61,64,65,66,67,68,69,70,71,72,73,74,-72,-71,-63,-62,65,66,67,68,
                        69,70,71,72,73,-71,-62,-1,0,1,2,3,4,-2,-1,0,3,4,5,6,-3,-2,5,6,-3,-3,-2,-3,-2,-2,-1,0,0,1,2,3,2,3,4,5,4,5,6,6,7,7,7,-4,-3,6,7,-3,-2,-1,5,6,-2,-1,0,1,2,3,4,5];
        var arrayY = [-89,-88,-74,-74,-74,-73,-73,-73,-73,-73,-72,-72,-72,-72,-72,-71,-71,-71,-71,-71,-70,-70,-70,-70,-70,-70,-69,-69,-69,-69,-69,-68,-68,-68,-68,-68,-67,-67,-67,-67,-67,-66,-66,-66,-66,-66,-65,-65,-65,-65,-65,-64,-64,-64,-64,-64,-63,-63,-63,-63,-63,-63,-62,-62,
                        -62,-62,-62,-61,-61,-61,-61,-60,-60,-60,-59,-6,-6,-6,-6,
                        -6,-6,-6,-6,-6,-6,-6,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,
                        3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,
                        9,9,10,10,63,63,63,63,63,63,64,64,64,64,64,64,64,65,65,65,65,66,67,67,68,68,69,69,69,70,70,70,70,71,71,71,
                        71,72,72,72,73,73,74,75,76,76,76,76,77,77,77,77,77,78,78,78,78,78,78,78,78];

        var heading = Activity.getActivityInfo().currentHeading;
        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        for( var i = 0; i < arrayX.size(); i++) {
            var radius = Math.sqrt(Math.pow(arrayX[i],2) + Math.pow(arrayY[i],2));
            var arctan2 = Math.atan2( (arrayY[i]), (arrayX[i]));
            var x = centerX + radius * Math.cos(heading + arctan2) * DevUserRatio;
            var y = centerY + radius * Math.sin(heading + arctan2) * DevUserRatio;
            dc.drawPoint(x, y);
            }
        var compassCircleRadius = 89 * DevUserRatio;
        var compassTickRadius = 82 * DevUserRatio;
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(centerX, centerY, compassCircleRadius);
        var tickDegrees = [0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,225,240,255,270,285,300,315,330,345];
        for( var i = 0; i < tickDegrees.size(); i++) {
            var tickMarkX = compassCircleRadius*(Math.cos(heading - Math.PI * tickDegrees[i] / 180)) + centerX;
            var tickMarkY = compassCircleRadius*(Math.sin(heading - Math.PI * tickDegrees[i] / 180)) + centerY;
            var tickMarkInnerX = compassTickRadius*(Math.cos(heading - Math.PI * tickDegrees[i] / 180)) + centerX;
            var tickMarkInnerY = compassTickRadius*(Math.sin(heading - Math.PI * tickDegrees[i] / 180)) + centerY;
            dc.drawLine(tickMarkX, tickMarkY, tickMarkInnerX, tickMarkInnerY);
        }

        // Value 1 refers to red part of compass needle
        var arrowRed = createArrow(centerX, centerY, heading, 1, DevUserRatio);
        // Value 2 refers to white part of compass needle
        var arrowWhite = createArrow(centerX, centerY, heading, 2, DevUserRatio);
        dc.fillPolygon(arrowWhite);
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(arrowRed);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, 9 * DevUserRatio);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, 5 * DevUserRatio);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawPoint(centerX, centerY);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        requestUpdate();
    }

    function createArrow(centerX, centerY, heading, colour, DevUserRatio) {
        var angle1 = heading;
        var angle2 = heading - ( Math.PI*0.5 );
        var angle3 = heading + ( Math.PI*0.5 );
        var angle4 = heading + Math.PI;
        var radius14 = 60 * DevUserRatio;
        var radius23 = 8 * DevUserRatio;
        if (colour == 1) {
            var xy1 = calculateXYOnCircle(angle1, radius14, centerX, centerY);
            var xy2 = calculateXYOnCircle(angle2, radius23, centerX, centerY);
            var xy3 = calculateXYOnCircle(angle3, radius23, centerX, centerY);
            return [xy1,xy2,xy3];
        }
        else if (colour == 2) {
            var xy2 = calculateXYOnCircle(angle2, radius23, centerX, centerY);
            var xy3 = calculateXYOnCircle(angle3, radius23, centerX, centerY);
            var xy4 = calculateXYOnCircle(angle4, radius14, centerX, centerY);
            return [xy2,xy3,xy4];
        }
        else {
            return [];
        }
    }
    
    function requestUpdate() as Void {
        WatchUi.requestUpdate();
    }

    function calculateXYOnCircle(angle, radius, centerX, centerY) {
        var x = radius * Math.cos(angle - (Math.PI*0.5)) + centerX;
        var y = radius * Math.sin(angle - (Math.PI*0.5)) + centerY;
        return [x,y];
    }
}