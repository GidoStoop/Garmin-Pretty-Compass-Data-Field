
using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Math;

class PrettyCompassView extends Ui.DataField
{   
    hidden var timer;
		
	function initialize() {
		DataField.initialize();
	}
    
	function compute(info) {
		timer = info.timerTime;
	}
    
    function onLayout(dc) {
		}
    
	function onUpdate(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var centerX = Math.round( screenWidth / 2 );
        var centerY = Math.round( screenHeight / 2 );
        var developerWidth = 215.0;
        var DevUserRatio = screenWidth / developerWidth;

        var NarrayX = [-5,-5,6,6];
        var WarrayX = [-77,-71,-66,-61,-55];
        var NarrayY = [-61,-75,-61,-75];
        var WarrayY = [-6,9,-4,9,-6];
        var SarrayX = [-4,-2,5,7,7,2,-3,-3,-1,4,6];
        var SarrayY = [75,77,77,74,72,69,67,64,62,62,64];
        var EarrayX = [72,64,64,69,64,64,73];
        var EarrayY = [-7,-7,0,0,0,7,7];

        var heading = Activity.getActivityInfo().currentHeading;
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);

        writeCardinality(centerX, centerY, dc, heading, NarrayX, NarrayY, DevUserRatio);
        writeCardinality(centerX, centerY, dc, heading, WarrayX, WarrayY, DevUserRatio);
        writeCardinality(centerX, centerY, dc, heading, SarrayX, SarrayY, DevUserRatio);
        writeCardinality(centerX, centerY, dc, heading, EarrayX, EarrayY, DevUserRatio);

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

    function calculateXYOnCircle(angle, radius, centerX, centerY) {
        var x = radius * Math.cos(angle - (Math.PI*0.5)) + centerX;
        var y = radius * Math.sin(angle - (Math.PI*0.5)) + centerY;
        return [x,y];
    }

    function writeCardinality(centerX, centerY, dc, heading, arrayX, arrayY, DevUserRatio) {
        for( var i = 0; i < (arrayX.size()-1); i++) {

            var radius = Math.sqrt(Math.pow(arrayX[i],2) + Math.pow(arrayY[i],2));
            var arctan2 = Math.atan2( (arrayY[i]), (arrayX[i]));
            var x1 = centerX + radius * Math.cos(heading + arctan2) * DevUserRatio;
            var y1 = centerY + radius * Math.sin(heading + arctan2) * DevUserRatio;

            var radius2 = Math.sqrt(Math.pow(arrayX[i+1],2) + Math.pow(arrayY[i+1],2));
            var arctan22 = Math.atan2( (arrayY[i+1]), (arrayX[i+1]));
            var x2 = centerX + radius2 * Math.cos(heading + arctan22) * DevUserRatio;
            var y2 = centerY + radius2 * Math.sin(heading + arctan22) * DevUserRatio;
            dc.drawLine(x1, y1, x2, y2);
            dc.drawLine(x1+1, y1+1, x2+1, y2+1);
            }
    }
}
