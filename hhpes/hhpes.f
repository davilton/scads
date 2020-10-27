c234567
      implicit none
c
      real*8 x, y
      real*8 u, umax, ushift
      real*8 xmin, xmax, ymin, ymax, delta, epsilon
      integer ix, iy, nx, ny
c
c  Change delta to adjust point spacing, which is the same for x and y.
c
      delta = 0.025d0         ! Step width along x and y
c
      umax = 1.d0/6.d0       ! Barrier height of potential rel. to 0
c
c  Change the vertical shift by adjusting the coefficient just below.
c
      ushift = 0.1d0*umax    ! V-shift in potential = 0.1*barrier
c
      xmin = -1.5d0          ! Lower limit of x
      xmax =  1.5d0          ! Upper limit of x
      ymin = -1.0d0          ! Lower limit of y
      ymax =  1.6d0          ! Upper limit of y
      write(1,11)xmin,xmax
      write(1,12)ymin,ymax
 11   format('# Limits of x: ',2(2x,f12.8))
 12   format('# Limits of y: ',2(2x,f12.8))
c
      epsilon = 0.000001d0   ! A small number, insurance for 'int' below
      nx = 1 + int(epsilon+(xmax-xmin)/delta)  ! Loop limit for x
      ny = 1 + int(epsilon+(ymax-ymin)/delta)  ! Loop limit for y
c     write(1,13)nx, ny, nx*ny
c13   format('# Points along x and y, and total points: ',3(2x,i8))
c
      write(1,14)umax+4.d0*ushift
 14   format('# Bounding box limits for printed U:    0.0  ',2x,f12.8)
      write(1,15)
c15   format('#  x            y            Shifted U    Raw U')
 15   format('#  x            y            Shifted U')
c
      x=xmin
      do 10 ix = 1, nx       ! Loop over x
         y=ymin
         do 20 iy = 1, ny    ! Loop over y
            u = 0.5d0*(x*x + y*y) + x*x*y - y*y*y/3.d0
            if((u.ge.(-ushift)).and.(u.le.(umax+3.d0*ushift)))then
               write(1,1)x,y,u+ushift
            endif
c           write(1,1)x,y,u+ushift,u
            y = y + delta    ! Increment y
 20      continue
         x = x + delta       ! Increment x
 10   continue
c
  1   format(4(1x,f12.8))
c
      stop
      end
