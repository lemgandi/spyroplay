--[[
   Spirograph simulator

   Charles Shapiro 18 Dec 2023

   This file is part of SpiroPlay
    SpiroPlay is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    SpiroPlay is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with SpiroPlay.  If not, see <http://www.gnu.org/licenses/>.
]]

import 'CoreLibs/strict.lua'
import 'CoreLibs/graphics.lua'

gfx=playdate.graphics
geom=playdate.geometry

firstUpdate=true
OuterCircle=nil
Resolution=0.5

OuterCircleRadius=120
InnerCircleRadius=80
Theta = Resolution
Offset=0
CurrentX=(OuterCircleRadius - InnerCircleRadius)
CurrentY=0
GearCircleCenter=geom.point.new(CurrentX,CurrentY)
InnerCircle=nil


function drawCircle(circle)
   for kk,vv in ipairs(circle) do
      gfx.drawPixel(vv)
   end
end

function drawNextPatternPoint(point,radius,theta,offset)
  
   local drawPoint = geom.point.new( (point.x + (radius * math.cos(theta)) + math.cos(offset)),
      (point.y + (radius * math.sin(theta)) + math.sin(offset )) )
   gfx.drawPixel(drawPoint)
   -- gfx.drawCircleAtPoint(drawPoint,2)   
end


function drawEpicycle(circle)
   for kk=1,359,60 do
      gfx.drawCircleAtPoint(circle[kk],InnerCircleRadius)
   end
end


function makeCircle(radius,center)
   local circle={}
   for ii=Resolution,359,Resolution do
      circle[ii] = findNextCirclePoint(ii,radius,center)
   end
   return circle
end


function findNextCirclePoint(angle,radius,center)
   local radian = (angle * math.pi)/180
   
   local ptx,pty = center.x + (radius * math.cos(radian)), center.y + (radius * math.sin(radian))
   local nextPoint=geom.point.new(ptx,pty)
   return nextPoint
end


function initialize()
   print("Initialize")
   gfx.setDrawOffset(0,0)
   gfx.setColor(gfx.kColorWhite)
   gfx.fillRect(0,0,400,240)
   gfx.setColor(gfx.kColorBlack)
   gfx.setDrawOffset(200,120)
   gfx.drawCircleAtPoint(0,0,OuterCircleRadius)
   gfx.drawCircleAtPoint(GearCircleCenter,InnerCircleRadius) 
   InnerCircle=makeCircle(OuterCircleRadius - InnerCircleRadius,geom.point.new(0,0)) 
--   drawEpicycle(InnerCircle)
end

function playdate.update()
   if firstUpdate then
      initialize()
      firstUpdate=false
   end
   
   if playdate.buttonIsPressed(playdate.kButtonA) then
      initialize()
   end   

   
   local newX=nil
   local newY=nil
   local radius=(OuterCircleRadius / InnerCircleRadius ) * 15
   
   local change,acChange=playdate.getCrankChange()   
   if change ~= 0 then
      
      Theta = Theta + Resolution
      if Theta >= 359 then
	 Theta = Resolution
--	 Offset = Offset+2
      end
      
      drawNextPatternPoint(InnerCircle[Theta],radius,Theta,Offset)
   end
end
