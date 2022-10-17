PRO atsc5010_afrifa_Lab1b, LWC_CDP, LWC_PVM, N_CDP, N_FSSP, WWIND
; written by Francis Osei Tutu Afrifa, 2022.

restore, 'atsc5010_Lab1.idlsav' 
;OPENR, 1, 'atsc5010_Lab1.idlsav'
;CLOSE, 1

h_10 = DINDGEN(1001, START=-500.0)/100
h_25 = DINDGEN(2501, START=-500.0)/250
;PRINT, h_10

plot1 = PLOT(h_10, LWC_PVM,'g', NAME='PVM',TITLE='Liquid water content (LWC)', YTITLE = 'LWC (g$m^{-3}$)',XTITLE='Distance from the center of the cloud (km)', layout=[1,3,1], Dimensions=[1200,900])
;Dimensions idea from Jeff Nivitanont, 2021.

plot2 = PLOT(h_10, LWC_CDP, /Overplot, 'r', NAME='CDP', yrange=[0,3], xrange=[-5,5]) ; color shortcut from T.A Katie
leg_1 = legend(TARGET=[plot1,plot2], position=[0.22,0.9])

plot3 = PLOT(h_10, N_FSSP,'c', NAME='FSSP',TITLE = 'Number Concentration', YTITLE = 'Number Concentration (cm$^{-3}$)',XTITLE='Distance from the center of the cloud (km)', layout=[1,3,2],/current)
plot4 = PLOT(h_10, N_CDP, /Overplot, 'r', NAME='CDP', xrange=[-5,5])
leg_2 = legend(TARGET=[plot3,plot4], position=[0.9,0.58], COLOR=['c','r'])

plot5 = PLOT(h_25,WWIND,'r', NAME='WWIND',TITLE='Vertical Velocity (VV)', YTITLE = 'Vertical Velocity (ms$^{-1}$)',XTITLE='Distance from the center of the cloud (km)', layout=[1,3,3],/current)
plot5.yrange =[-10.,20.]

VV_smoothed = smooth(WWIND, 25)
smoothed_GT_12 = where(VV_smoothed gt 12)
plot6 = PLOT(h_25,VV_smoothed,/Overplot,'b', NAME='WWIND-SMOOTHED', THICK=2 )

; create an array of len 2501 (same as len of smoothed data) filled with Nan values
m = make_array(2501, Value = !values.f_nan)

;Now let's replace Nan Values with values in excess of 12 m/s from the smoothed data and then plot as overplot
m[smoothed_GT_12] = VV_smoothed[smoothed_GT_12]    ;Idea from Jeff Nivitanont, 2021
plot7 = PLOT(h_25, m, /Overplot, 'g', Thick=3, NAME='VV>12')

;Finally we overplot a thin dashed lin that denotes 0 m/s
plot8 = PLOT([-1250, 1250],[0,0], /Overplot,'--', xrange = [-2,8])
leg_3 = legend(TARGET = [plot5,plot6,plot7], position = [0.27, 0.26], FONT_SIZE=7)

;save plot as .png file idea from Jeff Nivitanont, 2021.
plot1.save, 'afrifa_lab1b.png'

;LIQUID WATER CONTENT
;more plots (scatter, line of best fit and correlation coefficient
p_gt_0 = where((LWC_CDP GT 0.02) and (LWC_PVM GT 0.02))
plot9 = scatterplot(LWC_CDP[p_gt_0], LWC_PVM[p_gt_0], symbol='D',sym_color='r',/sym_filled, yrange=[0,2.5],NAME='LWC',TITLE='Liquid water content (g$m^{-3}$)',YTITLE = 'PVM',XTITLE='CDP', Dimensions=[600,600] )
x = [0,2.5]
plot10 = PLOT(x,x, /Overplot, Thick=2, NAME='Y=X')

;line of best fit
lin_fit = LINFIT(LWC_CDP[p_gt_0], LWC_PVM[p_gt_0])
;print, lin_fit
intercept = lin_fit[0]
gradient = lin_fit[1]

;from eqn of a straight line: y = mx + c
y = gradient*x + intercept                    ;Idea from Jeff Nivitanont, 2021
plot11 = plot(x, y, /Overplot, 'r', Thick=3, NAME='Lsq.')

;compute the correlation coefficient
corr_coeff = CORRELATE(LWC_CDP[p_gt_0],LWC_PVM[p_gt_0])
corr = text(0.2, 0.8, '$\rho$ ='+string(corr_coeff))
leg_4 = legend(TARGET = [plot10,plot11], position = [0.9, 0.26])

;save plot as .png file idea from Jeff Nivitanont, 2021.
plot9.save, 'afrifa_lab1b_lwc_pvm-cdp.png'

; NUMBER CONCENTRATION
p_gt_0 = where((N_CDP GT 1) and (N_FSSP GT 1))
plot12 = scatterplot(N_FSSP[p_gt_0],N_CDP[p_gt_0], symbol='D',sym_color='r',/sym_filled,NAME='NC',TITLE='Number Concentration (cm$^{-3}$)',YTITLE = 'CDP',XTITLE='FSSP', Dimensions=[600,600])
x = [0,400]
plot13 = PLOT(x,x, /Overplot, Thick=2, NAME='Y=X')

;line of best fit
lin_fit = LINFIT(N_FSSP[p_gt_0],N_CDP[p_gt_0])
intercept = lin_fit[0]
gradient = lin_fit[1]

;from eqn of a straight line: y = mx + c
y = gradient*x + intercept
plot14 = plot(x, y, /Overplot, 'r', Thick=3, NAME='Lsq.')

;compute the correlation coefficient
corr_coeff = CORRELATE(N_FSSP[p_gt_0], N_CDP[p_gt_0])
corr = text(0.15, 0.8, '$\rho$ ='+string(corr_coeff))
leg_5 = legend(TARGET = [plot13,plot14], position = [0.9, 0.26])

;save plot as .png file idea from Jeff Nivitanont, 2021.
plot12.save, 'afrifa_lab1b_n_fssp-cdp.png'

RETURN
END