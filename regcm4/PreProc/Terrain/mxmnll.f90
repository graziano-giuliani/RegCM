      subroutine mxmnll(iy,jx,clon,xlon,xlat,ntypec)
      use mod_aa
      implicit none
!
! Dummy arguments
!
      real(4) :: clon
      integer :: iy , jx , ntypec
      real(4) , dimension(iy,jx) :: xlat , xlon
      intent (in) clon , iy , jx , ntypec , xlat , xlon
!
! Local variables
!
      integer :: i , j
!
!
!
!     PURPOSE : FINDS THE MAXIMUM AND MINIMUM LATITUDE AND LONGITUDE
!
!
!
      xmaxlat = -90
      xminlat = 90
      xminlon = 999999.
      xmaxlon = -999999.
!
      do i = 1 , iy
        do j = 1 , jx
          xminlat = amin1(xminlat,xlat(i,j))
          xmaxlat = amax1(xmaxlat,xlat(i,j))
        end do
      end do
      do i = 1 , iy
        do j = 1 , jx
          if ( clon>=0.0 ) then
            if ( xlon(i,j)>=0.0 ) then
              xminlon = amin1(xminlon,xlon(i,j))
              xmaxlon = amax1(xmaxlon,xlon(i,j))
            else if ( abs(clon-xlon(i,j))<abs(clon-(xlon(i,j)+360.)) )  &
                    & then
              xminlon = amin1(xminlon,xlon(i,j))
              xmaxlon = amax1(xmaxlon,xlon(i,j))
            else
              xminlon = amin1(xminlon,xlon(i,j)+360.)
              xmaxlon = amax1(xmaxlon,xlon(i,j)+360.)
            end if
          else if ( xlon(i,j)<0.0 ) then
            xminlon = amin1(xminlon,xlon(i,j))
            xmaxlon = amax1(xmaxlon,xlon(i,j))
          else if ( abs(clon-xlon(i,j))<abs(clon-(xlon(i,j)-360.)) )    &
                  & then
            xminlon = amin1(xminlon,xlon(i,j))
            xmaxlon = amax1(xmaxlon,xlon(i,j))
          else
            xminlon = amin1(xminlon,xlon(i,j)-360.)
            xmaxlon = amax1(xmaxlon,xlon(i,j)-360.)
          end if
        end do
      end do
 
      print 99001 , xminlat , xmaxlat , xminlon , xmaxlon , ntypec
!--------initialize minimum lat and lon of data from tape
      grdltmn = xminlat + 5.
      grdlnmn = xminlon + 5.
99001 format (1x,'xminlat,xmaxlat,xminlon,xmaxlon,ntypec= ',4F10.2,i10)
!
      end subroutine mxmnll