      subroutine nrot2rot(lam,phi,pollon,pollat,lams,phis)
      implicit none
!
! Dummy arguments
!
      real(4) :: lam , lams , phi , phis , pollat , pollon
      intent (in) lam , phi , pollat , pollon
      intent (out) lams
      intent (inout) phis
!
! Local variables
!
      real(4) :: d2r , plam , pphi , r2d , zarg , zarg1 , zarg2 ,       &
               & zcospol , zlam , zlampol , zphi , zsinpol
!
! ----------------------------------------------------------------------
!     Purpose:
!     Adaption of the DWD-Functions to convert real geographical
!     coordinates (PHI,LAM) into coordinates in the roteted system
!     (PHIS,LAMS). The rotated pole is passed trough POLLON and POLLAT.
!     POLLON and POLLAT give the origin of the new rotated grid. The
!     first four arguments are input, the second two are output. All
!     angles are in degrees (north>0, east>0)
!     History:
!     05/90   D.MAJEWSKI (DWD), G. DE MORSIER (SMA)
!     03/93   D.BRESCH (ETHZ)
!     11/97   D.LUETHI (ETHZ)
 
      r2d = 45./atan(1.)
      d2r = atan(1.)/45.
 
      plam = pollon + 180.
      pphi = 90. - pollat
 
      if ( plam>180. ) plam = plam - 360.
 
      zsinpol = sin(d2r*pphi)
      zcospol = cos(d2r*pphi)
      zlampol = d2r*plam
 
!     first, the conversion of PHI to PHIS:
      zphi = d2r*phi
      zlam = lam
      if ( zlam>180.0 ) zlam = zlam - 360.0
      zlam = d2r*zlam
      zarg = zcospol*cos(zphi)*cos(zlam-zlampol) + zsinpol*sin(zphi)
      phis = asin(zarg)
      phis = log(tan(phis/2.+atan(1.)))*r2d
 
!     now, the conversion for LAMS follws:
      zphi = d2r*phi
      zlam = lam
      if ( zlam>180.0 ) zlam = zlam - 360.0
      zlam = d2r*zlam
      zarg1 = -sin(zlam-zlampol)*cos(zphi)
      zarg2 = -zsinpol*cos(zphi)*cos(zlam-zlampol) + zcospol*sin(zphi)
      if ( abs(zarg2)>=1.E-30 ) then
        lams = r2d*atan2(zarg1,zarg2)
      else if ( abs(zarg1)<1.E-30 ) then
        lams = 0.0
      else if ( zarg1>0. ) then
        lams = 90.0
      else
        lams = -90.0
      end if
 
      end subroutine nrot2rot