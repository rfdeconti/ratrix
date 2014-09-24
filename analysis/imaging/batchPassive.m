clear all
close all
dbstop if error
%pathname = 'I:\compiled behavior\';
pathname = 'D:\Widefield (12-10-12+)\data 62713+\';
datapathname = 'D:\Widefield (12-10-12+)\data 62713+\';  
outpathname = 'I:\compiled behavior\behavior topos\';



n=1;
files(n).subj = 'g6ckr6lt';
files(n).expt = '091014';
files(n).topox =  '';
files(n).topoxdata = '091014 G6CKR6-LT with dox but WT\G6CKR6-LT_run2_topoX_F_5.6_50ms\G6CKR6-LT_run2_topoX_F_5.6';
files(n).topoy = '';
files(n).topoydata = '091014 G6CKR6-LT with dox but WT\G6CKR6-LT_run3_topoY_F_5.6_50ms\G6CKR6-LT_run3_topoY_F_5.6';
files(n).topoxreverse =  '';
files(n).topoxreversedata = '';
files(n).behav = '';
files(n).behavdata = '';
files(n).grating = '';
files(n).gratingdata = '';
files(n).stepbinary = '';
files(n).stepbinarydata = '091014 G6CKR6-LT with dox but WT\G6CKR6-LT_run1_step_binary_F_5.6_50ms\G6CKR6-LT_run1_step_binary_F_5.6';
files(n).auditory = '';
files(n).auditorydata = '';
files(n).darkness = '';
files(n).darknessdata = '';
files(n).loom = '';
files(n).loomdata = '';
files(n).monitor = 'vert';
files(n).task = '';
files(n).spatialfreq = '';
files(n).label = 'camk2-cre gc6'; %w/dox
files(n).notes = 'good imaging session'; 


n=n+1;
files(n).subj = 'ctta21lt';
files(n).expt = '091014';
files(n).topox =  '';
files(n).topoxdata = '091014 CTTA22-LT Wild Type\CTTA22-LT_run2_topoX_F_4_50ms\CTTA22-LT_run2_topoX_F_4';
files(n).topoy = '';
files(n).topoydata = '091014 CTTA22-LT Wild Type\CTTA22-LT_run3_topoY_F_4_50ms\CTTA22-LT_run3_topoY_F_4';
files(n).topoxreverse =  '';
files(n).topoxreversedata = '';
files(n).behav = '';
files(n).behavdata = '';
files(n).grating = '';
files(n).gratingdata = '';
files(n).stepbinary = '';
files(n).stepbinarydata = '091014 CTTA22-LT Wild Type\CTTA22-LT_run1_step_binary_F_4_50ms\CTTA22-LT_run1_step_binary_F_4';
files(n).auditory = '';
files(n).auditorydata = '';
files(n).darkness = '';
files(n).darknessdata = '';
files(n).loom = '';
files(n).loomdata = '';
files(n).monitor = 'vert';
files(n).task = '';
files(n).spatialfreq = '';
files(n).label = 'WT';
files(n).notes = 'good imaging session'; 


n=n+1;
files(n).subj = 'ctta21lt';
files(n).expt = '091014';
files(n).topox =  '';
files(n).topoxdata = '091014 CTTA21-LT Wild Type\CTTA21-LT_run2_TopoX_Fstop4_50ms\CTTA21-LT_run2_TopoX_Fstop4';
files(n).topoy = '';
files(n).topoydata = '091014 CTTA21-LT Wild Type\CTTA21-LT_run23_TopoY_Fstop4_50ms\CTTA21-LT_run23_TopoY_Fstop4';
files(n).topoxreverse =  '';
files(n).topoxreversedata = '';
files(n).behav = '';
files(n).behavdata = '';
files(n).grating = '';
files(n).gratingdata = '';
files(n).stepbinary = '';
files(n).stepbinarydata = '091014 CTTA21-LT Wild Type\CTTA21-LT_run1_step_binary_Fstop4_50ms\091014 CTA22-LT Wild Type';
files(n).auditory = '';
files(n).auditorydata = '';
files(n).darkness = '';
files(n).darknessdata = '';
files(n).loom = '';
files(n).loomdata = '';
files(n).monitor = 'vert';
files(n).task = '';
files(n).spatialfreq = '';
files(n).label = 'WT';
files(n).notes = 'good imaging session'; 



n=n+1;
files(n).subj = 'g62j6rt';
files(n).expt = '091014';
files(n).topox =  '';
files(n).topoxdata = 'no craniotoimy windows\091014 G62J6RT passive\G62j6rt_run2_topoX_Fstop8_50ms\G62j6rt_run2_topoX_Fstop8';
files(n).topoy = '';
files(n).topoydata = 'no craniotoimy windows\091014 G62J6RT passive\G62j6rt_run3_topoY_Fstop8_50ms\G62j6rt_run3_topoY_Fstop8';
files(n).topoxreverse =  '';
files(n).topoxreversedata = '';
files(n).behav = '';
files(n).behavdata = '';
files(n).grating = '';
files(n).gratingdata = '';
files(n).stepbinary = '';
files(n).stepbinarydata = 'no craniotoimy windows\091014 G62J6RT passive\G62j6rt_run1_step_binary_Fstop8_50ms\G62j6rt_run1_step_binary_Fstop8';
files(n).auditory = '';
files(n).auditorydata = '';
files(n).darkness = '';
files(n).darknessdata = '';
files(n).loom = '';
files(n).loomdata = '';
files(n).monitor = 'vert';
files(n).task = '';
files(n).spatialfreq = '';
files(n).label = 'camk2 gc6';
files(n).notes = 'good imaging session'; %no craniotomy


% n=n+1;
% files(n).subj = 'pvg61tt';
% files(n).expt = '082814';
% files(n).topox =  '';
% files(n).topoxdata = '082814 PV-G61TT\PV-G61TT_run1_topoX_Landscape_50ms_Fstop_4\PV-G61TT_run1_topoX_Landscape_50ms_Fstop_4';
% files(n).topoy = '';
% files(n).topoydata = '082814 PV-G61TT\PV-G61TT_run2_topoX_Portrait_50ms_Fstop_4\PV-G61TT_run2_topoX_Portrait_50ms_Fstop_4';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '082814 PV-G61TT\PV-G61TT_run4_widefield_gratintgs_Portrait_50ms_Fstop_4\PV-G61TT_run4_widefield_gratintgs_Portrait_50ms_Fstop_4';
% files(n).stepbinary = '';
% files(n).stepbinarydata = '082814 PV-G61TT\PV-G61TT_run3_step_binary_Portrait_50ms_Fstop_4\PV-G61TT_run3_step_binary_Portrait_50ms_Fstop_4';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'pv-cre gc6';
% files(n).notes = 'good imaging session'; %no craniotomy
% 
% n=n+1;
% files(n).subj = 'g6ckr1tt';
% files(n).expt = '082514';
% files(n).topox =  '';
% files(n).topoxdata = 'no craniotoimy windows\082514 G6.CKR1-TT\G6-CKR1-TT_run1_topoX_landscape_F-4_50ms\G6-CKR1-TT_run1_topoX_landscape_F-4';
% files(n).topoy = '';
% files(n).topoydata = 'no craniotoimy windows\082514 G6.CKR1-TT\G6-CKR1-TT_run2_topoX_portrait_F-4_50ms\G6-CKR1-TT_run2_topoX_portrait_F-4';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'no craniotoimy windows\082514 G6.CKR1-TT\G6-CKR1-TT_run3_step_binary_portrait_F-4_50ms\G6-CKR1-TT_run3_step_binary_portrait_F-4';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2-cre gc6';
% files(n).notes = 'good imaging session'; %no craniotomy
% 
% 
% n=n+1;
% files(n).subj = 'g62j6rt';
% files(n).expt = '082514';
% files(n).topox =  '';
% files(n).topoxdata = 'no craniotoimy windows\082514 G62J6-RT\G62J6-RT_run3_TopoX_landscape_potrait_F_8_50ms\G62J6-RT_run3_TopoX_landscape_potrait_F_8';
% files(n).topoy = '';
% files(n).topoydata = 'no craniotoimy windows\082514 G62J6-RT\G62J6-RT_run1_topoX_potrait_F_8_50ms\G62J6-RT_run1_topoX_potrait_F_8';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'no craniotoimy windows\082514 G62J6-RT\G62J6-RT_run2_step_binary_potrait_F_8_50ms\G62J6-RT_run2_step_binary_potrait_F_8';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no craniotomy
% 
% n=n+1;
% files(n).subj = 'g62k3rt';
% files(n).expt = '082114';
% files(n).topox =  '';
% files(n).topoxdata = 'no craniotoimy windows\082114 G62K2-RT\G62K3-rt_run1_topoX_landscape_F_8\G62K3-rt_run1_topoX_landscape_F_8';
% files(n).topoy = '';
% files(n).topoydata = 'no craniotoimy windows\082114 G62K2-RT\G62K3-rt_run4_TopoX_portrait_F_8\G62K3-rt_run4_TopoX_portrait_F_8';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'no craniotoimy windows\082114 G62K2-RT\G62K3-rt_run5_step_binary_portrait_F_8\G62K3-rt_run5_step_binary_portrait_F_8';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).patchx =  '';
% files(n).patchxdata = 'no craniotoimy windows\082114 G62K2-RT\G62K3-rt_run2_PatchX_10frame_landscape_F_8\G62K3-rt_run2_PatchX_10frame_landscape_F_8';
% files(n).patchy = '';
% files(n).patchydata = 'no craniotoimy windows\082114 G62K2-RT\G62K3-rt_run3_PatchX_10frame_portrait_F_8\G62K3-rt_run3_PatchX_10frame_portrait_F_8';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no craniotomy 5mm window
% 
% n=n+1;
% files(n).subj = 'g6j4rt';
% files(n).expt = '082014';
% files(n).topox =  '';
% files(n).topoxdata = 'headplateclaritytests\082014 g62j4rt passive\g62j4rt_run4_topoxlandscape\g62j4rt_run4_topoxlandscape';
% files(n).topoy = '';
% files(n).topoydata = 'headplateclaritytests\082014 g62j4rt passive\g62j4rt_run3_topox\g62j4rt_run3_topox';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'headplateclaritytests\082014 g62j4rt passive\g62j4rt_run2_stepbinary\g62j4rt_run2_stepbinary';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %testing window clarity
% 
% n=n+1;
% files(n).subj = 'g62b5lt';
% files(n).expt = '082014';
% files(n).topox =  '';
% files(n).topoxdata = 'headplateclaritytests\082014 g62b5lt passive\g62b5lt_run1_topoxlandscape_fstop11_exp50ms\g62b5lt_run1_topoxlandscape_fstop11_exp50ms';
% files(n).topoy = '';
% files(n).topoydata = 'headplateclaritytests\082014 g62b5lt passive\g62b5lt_run1_topox_fstop11_exp50ms\g62b5lt_run1_topox_fstop11_exp50ms';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'headplateclaritytests\082014 g62b5lt passive\g62b5lt_run3_stepbinary_fstop11_exp50ms\g62b5lt_run3_stepbinary_fstop11_exp50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %testing window clarity
% 
% n=n+1;
% files(n).subj = 'g62b8tt';
% files(n).expt = '081914';
% files(n).topox =  '';
% files(n).topoxdata = 'headplateclaritytests\081914 g62b8tt passive\g62b8tt_run3_topoxlandscape_fstop11_exp50ms\g62b8tt_run3_topoxlandscape_fstop11_exp50ms(greenlightlow)';
% files(n).topoy = '';
% files(n).topoydata = 'headplateclaritytests\081914 g62b8tt passive\g62b8tt_run1_topox_fstop11_exp50ms\g62b8tt_run1_topox_fstop11_exp50ms';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'headplateclaritytests\081914 g62b8tt passive\g62b8tt_run2_stepbinary_fstop11_exp50ms\g62b8tt_run2_stepbinary_fstop11_exp50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %testing window clarity

% n=n+1;
% files(n).subj = 'g62c2rt';
% files(n).expt = '081814';
% files(n).topox =  '';
% files(n).topoxdata = 'headplateclaritytests\081814 G62c2.rt_passive\g62c.2rt_run3_topoxlandscape_fstop11_exp50ms\g62c.2rt_run3_topoxlandscape_fstop11_exp50ms';
% files(n).topoy = '';
% files(n).topoydata = 'headplateclaritytests\081814 G62c2.rt_passive\g62c.2rt_run2_topox_fstop11_exp50ms\g62c.2rt_run2_topox_fstop11_exp50ms';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'headplateclaritytests\081814 G62c2.rt_passive\g62c.2rt_run1_stepbinary_fstop11_exp50ms\g62c.2rt_run1_stepbinary_fstop11_exp50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %testing window clarity
% 
% n=n+1;
% files(n).subj = 'g62e12rt';
% files(n).expt = '081814';
% files(n).topox =  '';
% files(n).topoxdata = 'headplateclaritytests\081814 g62e12rt passive\g62e12rt_run1_topoxlandscape_fstop11_exp50ms\g62e12rt_run1_topoxlandscape_fstop11_exp50ms';
% files(n).topoy = '';
% files(n).topoydata = 'headplateclaritytests\081814 g62e12rt passive\g62e12rt_run2_topox_fstop11_exp50ms\g62e12rt_run2_topox_fstop11_exp50ms';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'headplateclaritytests\081814 g62e12rt passive\g62e12rt_run3_stepbinary_fstop11_exp50ms\g62e12rt_run3_stepbinary_fstop11_exp50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %testing window clarity
% 
% n=n+1;
% files(n).subj = 'g62k2rt';
% files(n).expt = '081814';
% files(n).topox =  '';
% files(n).topoxdata = 'headplateclaritytests\081814 g62k2rt passive\g62k2rt_run3_topoxlandscape_fstop11_exp50ms\g62k2rt_run3_topoxlandscape_fstop11_exp50ms';
% files(n).topoy = '';
% files(n).topoydata = 'headplateclaritytests\081814 g62k2rt passive\g62k2rt_run1_topox_fstop11_exp50ms\g62k2rt_run1_topox_fstop11_exp50ms';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'headplateclaritytests\081814 g62k2rt passive\g62k2rt_run2_stepbinary_fstop11_exp50ms\g62k2rt_run2_stepbinary_fstop11_exp50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %testing window clarity
% 
% n=n+1;
% files(n).subj = 'g62b1lt';
% files(n).expt = '081814';
% files(n).topox =  '';
% files(n).topoxdata = 'headplateclaritytests\081814_g62b.1lt_passive\g62b.1lt_run1_topoxreverse_fstop11_exp50ms\g62b.1lt_run1_topoxreverse_fstop11_exp50ms';
% files(n).topoy = '';
% files(n).topoydata = 'headplateclaritytests\081814_g62b.1lt_passive\g62b.1lt_run2_topox_fstop11_exp50ms\g62b.1lt_run2_topox_fstop11_exp50ms';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'headplateclaritytests\081814_g62b.1lt_passive\g62b.1lt_run3_stepbinary_fstop11_exp50ms\g62b.1lt_run3_stepbinary_fstop11_exp50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %testing window clarity
% 
% 

% n=n+1;
% files(n).subj = 'g62k3rt';
% files(n).expt = '081514';
% files(n).topox =  '';
% files(n).topoxdata = 'no craniotoimy windows\081514 G62K3-RT 5mm\G62K3-RT_run3_topoX_land_50ms_F5.6\G62K3-RT_run3_topoX_land_50ms';
% files(n).topoy = '';
% files(n).topoydata = 'no craniotoimy windows\081514 G62K3-RT 5mm\G62K3-RT_run2_topoX_vert_50ms_F5.6\G62K3-RT_run2_topoX_vert_50ms';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'no craniotoimy windows\081514 G62K3-RT 5mm\G62K3-RT_run1_step_binary_50ms_F5.6\G62K3-RT_run1_step_binary_50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = 'no craniotoimy windows\081514 G62K3-RT 5mm\G62K3-RT_run_darkness_land_50ms_F5.6\G62K3-RT_run_darkness_land_50ms';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no craniotomy 5mm window
% 
% n=n+1;
% files(n).subj = 'g62h9tt';
% files(n).expt = '081514';
% files(n).topox =  '';
% files(n).topoxdata = '';
% files(n).topoy = '';
% files(n).topoydata = '';
% files(n).topoxreverse =  '';
% files(n).topoxreversedata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '';
% files(n).stepbinarydata = 'no craniotoimy windows\081514 G62H9-TT 8mm\G62H9-tt_run1_step_binary_50ms_F5.6\G62H9-tt_run1_step_binary_50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = 'no craniotoimy windows\081514 G62H9-TT 8mm\G62H9-tt_run2_darkness_50ms_F5.6\G62H9-tt_run2_darkness_50ms';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no craniotomy 8mm window
% 
% n=n+1;
% files(n).subj = 'g62j4rt';
% files(n).expt = '081414';
% files(n).topox =  '';
% files(n).topoxdata = '';
% files(n).topoy = '';
% files(n).topoydata = '';
% files(n).topoxreverse =  '081414 G62J4RT topoX rev landscape\G62J4RT topoX rev landscape F11\G62J4RT topoX rev landscape F11maps.mat';
% files(n).topoxreversedata = '081414 G62J4RT topoX rev landscape\G62J4RT topoX rev landscape F11\G62J4RT topoX rev landscape F11';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '081414 G62J4RT topoX rev landscape\G62J4RT step binary land\G62J4RT step binary land_maps.mat';
% files(n).stepbinarydata = '081414 G62J4RT topoX rev landscape\G62J4RT step binary land\G62J4RT step binary land';
% files(n).auditory = '081414 G62J4RT topoX rev landscape\G62J4RT auditorymaps.mat';
% files(n).auditorydata = '081414 G62J4RT topoX rev landscape\G62J4RT auditory\G62J4RT auditory';
% files(n).darkness = '081414 G62J4RT topoX rev landscape\G62J4RT darknessmaps.mat';
% files(n).darknessdata = '081414 G62J4RT topoX rev landscape\G62J4RT darkness\G62J4RT darkness';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'land';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no behavior
% 
% n=n+1;
% files(n).subj = 'g62h1t';
% files(n).expt = '081214';
% files(n).topox =  '';
% files(n).topoxdata = '';
% files(n).topoy = '';
% files(n).topoydata = '';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '081214 G62H1tt\G62H1tt_run3_step_binary\G62H1tt_run3_step_binary_maps.mat';
% files(n).stepbinarydata = '081214 G62H1tt\G62H1tt_run3_step_binary\G62H1tt_run3_step_binary';
% files(n).auditory = '081214 G62H1tt\G62H1tt_run5_auditory\G62H1tt_run5_auditory_maps.mat';
% files(n).auditorydata = '081214 G62H1tt\G62H1tt_run5_auditory\G62H1tt_run5_auditory';
% files(n).darkness = '081214 G62H1tt\G62H1tt_run2_darkness\G62H1tt_run2_darkness_maps.mat';
% files(n).darknessdata = '081214 G62H1tt\G62H1tt_run2_darkness\G62H1tt_run2_darkness';
% files(n).darkness_w_masking = '081214 G62H1tt\G62H1tt_run4_darkness_w_mask\G62H1tt_run4_darkness_w_maps.mat';
% files(n).darkness_w_maskingdata = '081214 G62H1tt\G62H1tt_run4_darkness_w_mask\G62H1tt_run4_darkness_w';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no behavior  LOLA masking
% 
% 
% 

% n=n+1;
% files(n).subj = 'g62j4rt';
% files(n).expt = '070914';
% files(n).topox =  '070914 g62j.4 rt passive viewing\g62j4rt_run1_topox_fstop8_exp50\g62j4rt_run1_topox_fstop8_exp50maps.mat';
% files(n).topoxdata = '070914 g62j.4 rt passive viewing\g62j4rt_run1_topox_fstop8_exp50\g62j4rt_run1_topox_fstop8_exp50';
% files(n).topoy = '070914 g62j.4 rt passive viewing\g62j4rt_run2_topoy_fstop8_exp50\g62j4rt_run2_topoy_fstop8_exp50maps.mat';
% files(n).topoydata = '070914 g62j.4 rt passive viewing\g62j4rt_run2_topoy_fstop8_exp50\g62j4rt_run2_topoy_fstop8_exp50';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '070914 g62j.4 rt passive viewing\g62j4rt_run3_stepbinary_fstop8_exp50\g62j4rt_run3_stepbinary_fstop8_exp50maps.mat';
% files(n).stepbinarydata = '070914 g62j.4 rt passive viewing\g62j4rt_run3_stepbinary_fstop8_exp50\g62j4rt_run3_stepbinary_fstop8_exp50';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no behavior
% 
n=n+1;
files(n).subj = 'g62j5rt';
files(n).expt = '070714';
files(n).topox =  '070714 G62J5-RT passive viewing\G62J5-RT_run1_topoX_50ms_exp_Fstop11\G62J5-RT_run1_topoX_50ms_exp_Fstop11maps.mat';
files(n).topoxdata = '070714 G62J5-RT passive viewing\G62J5-RT_run1_topoX_50ms_exp_Fstop11\G62J5-RT_run1_topoX_50ms_exp_Fstop11';
files(n).topoy = '070714 G62J5-RT passive viewing\G62J5-RT_run2_topoY_50ms_exp_Fstop11\G62J5-RT_run2_topoY_50ms_exp_Fstop11maps.mat';
files(n).topoydata = '070714 G62J5-RT passive viewing\G62J5-RT_run2_topoY_50ms_exp_Fstop11\G62J5-RT_run2_topoY_50ms_exp_Fstop11';
files(n).behav = '';
files(n).behavdata = '';
files(n).grating = '';
files(n).gratingdata = '';
files(n).stepbinary = '';
files(n).stepbinarydata = '';
files(n).auditory = '';
files(n).auditorydata = '';
files(n).darkness = '';
files(n).darknessdata = '';
files(n).loom = '';
files(n).loomdata = '';
files(n).monitor = 'vert';
files(n).task = '';
files(n).spatialfreq = '';
files(n).label = 'camk2 gc6';
files(n).notes = 'good imaging session'; %no behavior
% 
n=n+1;
files(n).subj = 'g62j4tt';
files(n).expt = '070714';
files(n).topox =  '070714 G62J4-TT passive viewing\G62J4-TT_run1_topoX_50msexp_Fstop11\G62J4-TT_run1_topoX_50msexp_Fstop11maps.mat';
files(n).topoxdata = '070714 G62J4-TT passive viewing\G62J4-TT_run1_topoX_50msexp_Fstop11\G62J4-TT_run1_topoX_50msexp_Fstop11';
files(n).topoy = '070714 G62J4-TT passive viewing\G62J4-TT_run2_topoY_50msexp_Fstop11\G62J4-TT_run2_topoY_50msexp_Fstop11maps.mat';
files(n).topoydata = '070714 G62J4-TT passive viewing\G62J4-TT_run2_topoY_50msexp_Fstop11\G62J4-TT_run2_topoY_50msexp_Fstop11';
files(n).behav = '';
files(n).behavdata = '';
files(n).grating = '';
files(n).gratingdata = '';
files(n).stepbinary = '';
files(n).stepbinarydata = '';
files(n).auditory = '';
files(n).auditorydata = '';
files(n).darkness = '';
files(n).darknessdata = '';
files(n).loom = '';
files(n).loomdata = '';
files(n).monitor = 'vert';
files(n).task = '';
files(n).spatialfreq = '';
files(n).label = 'camk2 gc6';
files(n).notes = 'good imaging session'; %no behavior
% 
% n=n+1;
% files(n).subj = 'g62e12rt';
% files(n).expt = '070314';
% files(n).topox =  '070314 G62E12-RT passive viewing\G62E12-RT_run1_topoX_50ms_Fstop11\G62E12-RT_run1_topoX_50ms_Fstop11maps.mat';
% files(n).topoxdata = '070314 G62E12-RT passive viewing\G62E12-RT_run1_topoX_50ms_Fstop11\G62E12-RT_run1_topoX_50ms_Fstop11';
% files(n).topoy = '070314 G62E12-RT passive viewing\G62E12-RT_run2_topoY_50ms_Fstop11\G62E12-RT_run2_topoY_50ms_Fstop11maps.mat';
% files(n).topoydata = '070314 G62E12-RT passive viewing\G62E12-RT_run2_topoY_50ms_Fstop11\G62E12-RT_run2_topoY_50ms_Fstop11';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '070314 G62E12-RT passive viewing\G62E12-RT_run3_step_binary_50ms_Fstop11\G62E12-RT_run3_step_binary_50ms_Fstop11maps.mat';
% files(n).stepbinarydata = '070314 G62E12-RT passive viewing\G62E12-RT_run3_step_binary_50ms_Fstop11\G62E12-RT_run3_step_binary_50ms_Fstop11';
% files(n).auditory = '070314 G62E12-RT passive viewing\G62E12-RT_run5_auditory_50ms_Fstop11\G62E12-RT_run5_auditory_50ms_Fstop11maps.mat';
% files(n).auditorydata = '070314 G62E12-RT passive viewing\G62E12-RT_run5_auditory_50ms_Fstop11\G62E12-RT_run5_auditory_50ms_Fstop11';
% files(n).darkness = '070314 G62E12-RT passive viewing\G62E12-RT_run4_darkness_50ms_Fstop11\G62E12-RT_run4_auditory_50ms_Fstop11maps.mat';
% files(n).darknessdata = '070314 G62E12-RT passive viewing\G62E12-RT_run4_darkness_50ms_Fstop11\G62E12-RT_run4_auditory_50ms_Fstop11';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session';
% 
% n=n+1;
% files(n).subj = 'g62g6lt';
% files(n).expt = '070214';
% files(n).topox =  '070214 G62G6-LT passive viewing\G62G6-LT_run1_topoX_50ms_exp_Fstop11\G62G6-LT_run1_topoX_50ms_exp_Fstop11maps.mat';
% files(n).topoxdata = '070214 G62G6-LT passive viewing\G62G6-LT_run1_topoX_50ms_exp_Fstop11\G62G6-LT_run1_topoX_50ms_exp_Fstop11';
% files(n).topoy = '070214 G62G6-LT passive viewing\G62G6-LT_run2_topoY_50ms_exp_Fstop11\G62G6-LT_run2_topoY_50ms_exp_Fstop11maps.mat';
% files(n).topoydata = '070214 G62G6-LT passive viewing\G62G6-LT_run2_topoY_50ms_exp_Fstop11\G62G6-LT_run2_topoY_50ms_exp_Fstop11';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '070214 G62G6-LT passive viewing\G62G6-LT_run3_stepbinary_50ms_exp_Fstop11\G62G6-LT_run3_stepbinary_50ms_exp_Fstop11maps.mat';
% files(n).stepbinarydata = '070214 G62G6-LT passive viewing\G62G6-LT_run3_stepbinary_50ms_exp_Fstop11\G62G6-LT_run3_stepbinary_50ms_exp_Fstop11';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no behavior
% 
% 
% n=n+1;
% files(n).subj = 'g62k2rt';
% files(n).expt = '070214';
% files(n).topox =  '070217 G62K2-RT passive viewing\G62K2RT_run3_topox_fstop8_exp50ms\G62K2RT_run3_topox_fstop8_exp50msmaps.mat';
% files(n).topoxdata = '070217 G62K2-RT passive viewing\G62K2RT_run3_topox_fstop8_exp50ms\G62K2RT_run3_topox_fstop8_exp50ms';
% files(n).topoy = '070217 G62K2-RT passive viewing\G62K2RT_run4_topoy_fstop8_exp50ms\G62K2RT_run4_topoy_fstop8_exp50msmaps.mat';
% files(n).topoydata = '070217 G62K2-RT passive viewing\G62K2RT_run4_topoy_fstop8_exp50ms\G62K2RT_run4_topoy_fstop8_exp50ms';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '070217 G62K2-RT passive viewing\G62K2RT_run5_stepbinary_fstop8_exp50ms\G62K2RT_run5_stepbinary_fstop8_exp50msmaps.mat';
% files(n).stepbinarydata = '070217 G62K2-RT passive viewing\G62K2RT_run5_stepbinary_fstop8_exp50ms\G62K2RT_run5_stepbinary_fstop8_exp50ms';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no behavior
% 
% 
% n=n+1;
% files(n).subj = 'g62k1rt';
% files(n).expt = '070214';
% files(n).topox =  '070214 G62K1-RT passive viewing\G62K1-RT run3_topox_50msexp_fstop8\G62K1-RT run3_topox_50msexp_fstop8maps.mat';
% files(n).topoxdata = '070214 G62K1-RT passive viewing\G62K1-RT run3_topox_50msexp_fstop8\G62K1-RT run3_topox_50msexp_fstop8';
% files(n).topoy = '070214 G62K1-RT passive viewing\G62K1-RT run4_topoy_50msexp_fstop8\G62K1-RT run4_topoy_50msexp_fstop8maps.mat';
% files(n).topoydata = '070214 G62K1-RT passive viewing\G62K1-RT run4_topoy_50msexp_fstop8\G62K1-RT run4_topoy_50msexp_fstop8';
% files(n).behav = '';
% files(n).behavdata = '';
% files(n).grating = '';
% files(n).gratingdata = '';
% files(n).stepbinary = '070214 G62K1-RT passive viewing\G62K1-RT run5_stepbinary_50msexp_fstop8\G62K1-RT run5_stepbinary_50msexp_fstop8maps.mat';
% files(n).stepbinarydata = '070214 G62K1-RT passive viewing\G62K1-RT run5_stepbinary_50msexp_fstop8\G62K1-RT run5_stepbinary_50msexp_fstop8';
% files(n).auditory = '';
% files(n).auditorydata = '';
% files(n).darkness = '';
% files(n).darknessdata = '';
% files(n).loom = '';
% files(n).loomdata = '';
% files(n).monitor = 'vert';
% files(n).task = '';
% files(n).spatialfreq = '';
% files(n).label = 'camk2 gc6';
% files(n).notes = 'good imaging session'; %no behavior
% 
% 
