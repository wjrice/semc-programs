#!/usr/bin/env python

# makes an array of circles suitable for use as Helios streaming file
# wjr 2017
# outpits to screen
# no pi allowed!

def circlePoints( cx, cy,  x,  y, ):
    
   act = 255
   if (x == 0): 
      raster.append([act, cx, cy + y])
      raster.append([act, cx, cy - y])
      raster.append([act, cx + y, cy])
      raster.append([act, cx - y, cy])
   elif (x == y): 
      raster.append([act, cx + x, cy + y])
      raster.append([act, cx - x, cy + y])
      raster.append([act, cx + x, cy - y])
      raster.append([act, cx - x, cy - y])
   elif (x < y): 
      raster.append([act, cx + x, cy + y])
      raster.append([act, cx - x, cy + y])
      raster.append([act, cx + x, cy - y])
      raster.append([act, cx - x, cy - y])
      raster.append([act, cx + y, cy + x])
      raster.append([act, cx - y, cy + x])
      raster.append([act, cx + y, cy - x])
      raster.append([act, cx - y, cy - x])
        
    

def circleMidpoint(xCenter, yCenter, radius,):
   x = 0
   y = radius
   p = (5 - radius*4)/4
   decimate=2   #skip every 2nd point

   circlePoints(xCenter, yCenter, x, y, )
   while (x < y):
      x+=1
      if (p < 0):
         p += 2*x+1
      else:
         y -=1
         p += 2*(x-y)+1
      if (x % decimate ==0 and y % decimate ==0): 
         circlePoints(xCenter, yCenter, x, y, )
      
    
def concentric(outer,inner,step,xcen,ycen):
   for rad in range(outer,inner,step):
      circleMidpoint(xcen,ycen,rad)

def printraster():
   for tuple in raster:
       print "%i %i %i" %(tuple[0],tuple[1],tuple[2])



raster=[]
bigrad=54
smallrad=3
mystep=-6
xcen=537
ycen=537
i=0
for xcen in range (550,52000,1000):
   for ycen in range (550,32000,1000):
      concentric(bigrad,smallrad,mystep,xcen,ycen)
#concentric(bigrad,smallrad,mystep,xcen,ycen)
#write str header
i=len(raster)
print "s16"
print "1"
print "%d" %i
printraster()

