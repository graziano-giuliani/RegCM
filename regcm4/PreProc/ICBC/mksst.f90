      subroutine mksst(tsccm,sst1,sst2,topogm,xlandu,jx,iy,nyrp,nmop,wt)
      implicit none
!
! Dummy arguments
!
      integer :: iy , jx , nmop , nyrp
      real :: wt
      real , dimension(jx,iy) :: sst1 , sst2 , topogm , tsccm , xlandu
      intent (in) iy , jx , nmop , nyrp , topogm , xlandu
      intent (out) tsccm
      intent (inout) sst1 , sst2 , wt
!
! Local variables
!
      integer :: i , j , lat , lon , nday , nmo , nyear
!
!     ******           INITIALIZE SST1, SST2 (NEEDED FOR 82 JAN CASE)
!
      do lon = 1 , jx
        do lat = 1 , iy
          sst1(lon,lat) = 0.
          sst2(lon,lat) = 0.
        end do
      end do
 
      if ( nyrp==0 ) then
        wt = 1.
        go to 200
      end if
 
!     ******           READ IN RCM MONTHLY SST DATASET
 100  continue
      read (60,end=300) nday , nmo , nyear , ((sst1(i,j),j=1,iy),i=1,jx)
      if ( nyear<100 ) nyear = nyear + 1900
      if ( (nyear/=nyrp) .or. (nmo/=nmop) ) go to 100
!     PRINT *, 'READING RCM SST DATA:', NMO, NYEAR
 
!     ******           READ IN RCM MONTHLY SST DATASET
 200  continue
      read (60,end=300) nday , nmo , nyear , ((sst2(i,j),j=1,iy),i=1,jx)
      if ( nyear<100 ) nyear = nyear + 1900
!     PRINT *, 'READING RCM SST DATA:', NMO, NYEAR
      rewind (60)
 
      do i = 1 , jx
        do j = 1 , iy
          if ( (topogm(i,j)<=1.) .and.                                  &
             & (xlandu(i,j)>13.9 .and. xlandu(i,j)<15.1) .and.          &
             & (sst1(i,j)>-900.0 .and. sst2(i,j)>-900.0) ) tsccm(i,j)   &
             & = (1.-wt)*sst1(i,j) + wt*sst2(i,j)
        end do
      end do
 
      rewind (60)
 
      return
 300  continue
      print * , 'SST file is not the right one'
      stop 12
      end subroutine mksst