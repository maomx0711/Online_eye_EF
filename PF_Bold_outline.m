%%%% delete outline
%鍘婚櫎鏃犳晥鏁版嵁锛涘垹闄ゅ皬浜?.15s 鍜岃秴杩?.5s鐨勶紱
clear
clc
RunNum=4;
TrialNum=120;
t1=0.1;
t2=1.5;
N=3;
subname='caowanting';
baseDir = 'D:\project total\Excitve function\Bold_EF';  % 设置数据根目录
outputDir = 'D:\project total\Excitve function\Bold_EF\ANA_BoldPF';       % 结果输出目录
subjects = {'clj','cne','cyf','fjm','gyy','hhy','hs','hss','jhl','lhx','ljq','ll','llj','llt','lmq','lmr','ltt','lxj','lys','ojy','pf','pyl','pzr','sxr','tyc','wxf','xcq','xst','yxp'...
            'zdn','zlr','zqy'}; % 被试列表
%%%%%%%%%%%%%%%%%%%%%%%%%%
for s = 1:length(subjects)
    subname=subjects{s};
for run=1:RunNum
    
        dataFile = fullfile(baseDir, subname, ...
        sprintf('Periphery_Bold_%s_%d.mat', subname, run));


    if ~exist(dataFile, 'file')
        warning('File not found: %s', dataFile);
        continue;
    end

    % 加载数据
    data = load(dataFile);
    result = data.result;  % 假设数据存储在result变量中
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ACC
vn0=0; vn1=0;vn2=0;vn3=0;vn4=0;
ivn0=0; ivn1=0;ivn2=0;ivn3=0;ivn4=0;
nvn=0;invn=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RT
RTvn0=0;RTvn1=0;RTvn2=0;RTvn3=0;RTvn4=0;
iRTvn0=0;iRTvn1=0;iRTvn2=0;iRTvn3=0;iRTvn4=0;
NRT=0;INRT=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trial=1:TrialNum
   
    if result(7,trial)==1
      if result(1,trial)==1||result(1,trial)==2
        if result(2,trial)~=-1
        if result(6,trial)==10   % PD=0          
                vn0=vn0+1;
                RTvn0(vn0,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==11   % PD=1         
                vn1=vn1+1;
                RTvn1(vn1,1)=result(5,trial);
              
        end
        %%%%%%%%%%%%
        if result(6,trial)==22   % PD=2
                vn2=vn2+1;
                RTvn2(vn2,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==33   % PD=3
                vn3=vn3+1;
                RTvn3(vn3,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==44   % PD=4
                vn4=vn4+1;
                RTvn4(vn4,1)=result(5,trial);
        end
        elseif result(2,trial)==-1;
            nvn=nvn+1;
            NRT(nvn,1)=result(5,trial);
        end
               
      elseif result(1,trial)==3||result(1,trial)==4
        if result(2,trial)~=-1
           if result(6,trial)==10   % PD=0          
                ivn0=ivn0+1;
                iRTvn0(ivn0,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==11   % PD=1         
                ivn1=ivn1+1;
                iRTvn1(ivn1,1)=result(5,trial);
              
        end
        %%%%%%%%%%%%
        if result(6,trial)==22   % PD=2
                ivn2=ivn2+1;
                iRTvn2(ivn2,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==33   % PD=3
                ivn3=ivn3+1;
                iRTvn3(ivn3,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==44   % PD=4
                ivn4=ivn4+1;
                iRTvn4(ivn4,1)=result(5,trial);
        end    
          elseif result(2,trial)==-1
            invn=invn+1;
            INRT(invn,1)=result(5,trial);
        end
     end
    end
end
    [im0(run) in0(run)]=size(iRTvn0);[im1(run) in1(run)]=size(iRTvn1);[im2(run) in2(run)]=size(iRTvn2);[im3(run) in3(run)]=size(iRTvn3);[im4(run) in4(run)]=size(iRTvn4);
    [m0(run) n0(run)]=size(RTvn0);[m1(run) n1(run)]=size(RTvn1);[m2(run) n2(run)]=size(RTvn2);[m3(run) n3(run)]=size(RTvn3);[m4(run) n4(run)]=size(RTvn4);
    [nm(run) nn(run)]=size(NRT); [inm(run) inn(run)]=size(INRT);
    %%%%%%%%%%%%%
    if run==1
        RTvn0_run(1:m0(run),1)=RTvn0(1:m0(run),1);
        RTvn1_run(1:m1(run),1)=RTvn1(1:m1(run),1);
        RTvn2_run(1:m2(run),1)=RTvn2(1:m2(run),1);
        RTvn3_run(1:m3(run),1)=RTvn3(1:m3(run),1);
        RTvn4_run(1:m4(run),1)=RTvn4(1:m4(run),1);
        NRT_run(1:nm(run),1)=NRT(1:nm(run),1);

        %%%%%%%%%
        RTivn0_run(1:im0(run),1)=iRTvn0(1:im0(run),1);
        RTivn1_run(1:im1(run),1)=iRTvn1(1:im1(run),1);
        RTivn2_run(1:im2(run),1)=iRTvn2(1:im2(run),1);
        RTivn3_run(1:im3(run),1)=iRTvn3(1:im3(run),1);
        RTivn4_run(1:im4(run),1)=iRTvn4(1:im4(run),1);
        INRT_run(1:inm(run),1)=INRT(1:inm(run),1);
    elseif run>1
        RTvn0_run(sum(m0(1:run-1))+1:sum(m0(1:run)),1)=RTvn0(1:m0(run),1);
        RTvn1_run(sum(m1(1:run-1))+1:sum(m1(1:run)),1)=RTvn1(1:m1(run),1);
        RTvn2_run(sum(m2(1:run-1))+1:sum(m2(1:run)),1)=RTvn2(1:m2(run),1);
        RTvn3_run(sum(m3(1:run-1))+1:sum(m3(1:run)),1)=RTvn3(1:m3(run),1);
        RTvn4_run(sum(m4(1:run-1))+1:sum(m4(1:run)),1)=RTvn4(1:m4(run),1);
        NRT_run(sum(nm(1:run-1))+1:sum(nm(1:run)),1)=NRT(1:nm(run),1);
        %%%%%%
        RTivn0_run(sum(im0(1:run-1))+1:sum(im0(1:run)),1)=iRTvn0(1:im0(run),1);
        RTivn1_run(sum(im1(1:run-1))+1:sum(im1(1:run)),1)=iRTvn1(1:im1(run),1);
        RTivn2_run(sum(im2(1:run-1))+1:sum(im2(1:run)),1)=iRTvn2(1:im2(run),1);
        RTivn3_run(sum(im3(1:run-1))+1:sum(im3(1:run)),1)=iRTvn3(1:im3(run),1);
        RTivn4_run(sum(im4(1:run-1))+1:sum(im4(1:run)),1)=iRTvn4(1:im4(run),1);
        INRT_run(sum(inm(1:run-1))+1:sum(inm(1:run)),1)=INRT(1:inm(run),1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sum run
[rm0 rn0]=size(RTvn0_run);[rm1 rn1]=size(RTvn1_run);[rm2 rn2]=size(RTvn2_run);[rm3 rn3]=size(RTvn3_run);[rm4 rn4]=size(RTvn4_run);
[irm0 irn0]=size(RTivn0_run);[irm1 irn1]=size(RTivn1_run);[irm2 irn2]=size(RTivn2_run);[irm3 irn3]=size(RTivn3_run);[irm4 irn4]=size(RTivn4_run);
[nrm nrn]=size(NRT_run);[inrm inrn]=size(INRT_run);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h0=0;h1=0;h2=0;h3=0;h4=0;
ih0=0;ih1=0;ih2=0;ih3=0;ih4=0;
nh=0;
inh=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 200ms to1500ms
for k=1:rm0
    if RTvn0_run(k,1) > t1 & RTvn0_run(k,1)< t2
        h0=h0+1;
        RTvn0_new(h0,1)=RTvn0_run(k,1);
    end
end
for k=1:rm1
    if RTvn1_run(k,1) > t1 & RTvn1_run(k,1)< t2
        h1=h1+1;
        RTvn1_new(h1,1)=RTvn1_run(k,1);
    end
end
for k=1:rm2
    if RTvn2_run(k,1) > t1 & RTvn2_run(k,1)<t2
        h2=h2+1;
        RTvn2_new(h2,1)=RTvn2_run(k,1);
    end
end
for k=1:rm3
    if RTvn3_run(k,1) > t1 & RTvn3_run(k,1)<t2
        h3=h3+1;
        RTvn3_new(h3,1)=RTvn3_run(k,1);
    end
end
for k=1:rm4
    if RTvn4_run(k,1) > t1 & RTvn4_run(k,1)<t2
        h4=h4+1;
        RTvn4_new(h4,1)=RTvn4_run(k,1);
    end
end
for k=1:nrm
    if NRT_run(k,1) > t1 & NRT_run(k,1)<t2
        nh=nh+1;
        NRT_new(nh,1)=NRT_run(k,1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% invalid
for k=1:irm0
    if RTivn0_run(k,1) > t1 & RTivn0_run(k,1)< t2
        ih0=ih0+1;
        RTivn0_new(ih0,1)=RTivn0_run(k,1);
    end
end
for k=1:irm1
    if RTivn1_run(k,1) > t1 & RTivn1_run(k,1)< t2
        ih1=ih1+1;
        RTivn1_new(ih1,1)=RTivn1_run(k,1);
    end
end
for k=1:irm2
    if RTivn2_run(k,1) > t1 & RTivn2_run(k,1)<t2
        ih2=ih2+1;
        RTivn2_new(ih2,1)=RTivn2_run(k,1);
    end
end
for k=1:irm3
    if RTivn3_run(k,1) > t1 & RTivn3_run(k,1)<t2
        ih3=ih3+1;
        RTivn3_new(ih3,1)=RTivn3_run(k,1);
    end
end
for k=1:irm4
    if RTivn4_run(k,1) > t1 & RTivn4_run(k,1)<t2
        ih4=ih4+1;
        RTivn4_new(ih4,1)=RTivn4_run(k,1);
    end
end
for k=1:inrm
    if INRT_run(k,1) > t1 & INRT_run(k,1)<t2
        inh=inh+1;
        INRT_new(inh,1)=INRT_run(k,1);
    end
end
%%%%%%%%%%%%%%%%%%%%%
[mm0 nn0]=size(RTvn0_new);[mm1 nn1]=size(RTvn1_new);[mm2 nn2]=size(RTvn2_new);[mm3 nn3]=size(RTvn3_new);[mm4 nn4]=size(RTvn4_new);
[imm0 inn0]=size(RTivn0_new);[imm1 inn1]=size(RTivn1_new);[imm2 inn2]=size(RTivn2_new);[imm3 inn3]=size(RTivn3_new);[imm4 inn4]=size(RTivn4_new);
[nmm nnn]=size(NRT_new);[inmm innn]=size(INRT_new);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mean
RT0=mean(RTvn0_new);RT1=mean(RTvn1_new);RT2=mean(RTvn2_new);RT3=mean(RTvn3_new);RT4=mean(RTvn4_new);
iRT0=mean(RTivn0_new);iRT1=mean(RTivn1_new);iRT2=mean(RTivn2_new);iRT3=mean(RTivn3_new);iRT4=mean(RTivn4_new);
NRT=mean(NRT_new);INRT=mean(INRT_new);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% std
std0=std(RTvn0_new);std1=std(RTvn1_new);std2=std(RTvn2_new);std3=std(RTvn3_new);std4=std(RTvn4_new);
istd0=std(RTivn0_new);istd1=std(RTivn1_new);istd2=std(RTivn2_new);istd3=std(RTivn3_new);istd4=std(RTivn4_new);
nstd=std(NRT_new);instd=std(INRT_new);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hh0=0;hh1=0;hh2=0;hh3=0;hh4=0;
ihh0=0;ihh1=0;ihh2=0;ihh3=0;ihh4=0;
nhh=0;inhh=0;
%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:mm0
    if RTvn0_new(k,1) >= RT0-N* std0 & RTvn0_new(k,1) <= RT0+N* std0
        hh0=hh0+1;
        RTvn0_new2(hh0,1)=RTvn0_new(k,1);
    end
end
for k=1:mm1
    if RTvn1_new(k,1) >= RT1-N* std1 & RTvn1_new(k,1) <= RT1+N* std1
        hh1=hh1+1;
        RTvn1_new2(hh1,1)=RTvn1_new(k,1);
    end
end
for k=1:mm2
    if RTvn2_new(k,1) >= RT2-N* std2 & RTvn2_new(k,1) <= RT2+N* std2
        hh2=hh2+1;
        RTvn2_new2(hh2,1)=RTvn2_new(k,1);
    end
end
for k=1:mm3
    if RTvn3_new(k,1) >= RT3-N* std3 & RTvn3_new(k,1) <= RT3+N* std3
        hh3=hh3+1;
        RTvn3_new2(hh3,1)=RTvn3_new(k,1);
    end
end
for k=1:mm4
    if RTvn4_new(k,1) >= RT4-N* std4 & RTvn4_new(k,1) <= RT4+N* std4
        hh4=hh4+1;
        RTvn4_new2(hh4,1)=RTvn4_new(k,1);
    end
end
for k=1:nmm
    if NRT_new(k,1) >= NRT-N* nstd & NRT_new(k,1) <= NRT+N* nstd
        nhh=nhh+1;
        NRT_new2(nhh,1)=NRT_new(k,1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:imm0
    if RTivn0_new(k,1) >= iRT0-N* istd0 & RTivn0_new(k,1) <= iRT0+N* istd0
        ihh0=ihh0+1;
        RTivn0_new2(ihh0,1)=RTivn0_new(k,1);
    end
end
for k=1:imm1
    if RTivn1_new(k,1) >= iRT1-N* istd1 & RTivn1_new(k,1) <= iRT1+N* istd1
        ihh1=ihh1+1;
        RTivn1_new2(ihh1,1)=RTivn1_new(k,1);
    end
end
for k=1:imm2
    if RTivn2_new(k,1) >= iRT2-N* istd2 & RTivn2_new(k,1) <= iRT2+N* istd2
        ihh2=ihh2+1;
        RTivn2_new2(ihh2,1)=RTivn2_new(k,1);
    end
end
for k=1:imm3
    if RTivn3_new(k,1) >= iRT3-N* istd3 & RTivn3_new(k,1) <= iRT3+N* istd3
        ihh3=ihh3+1;
        RTivn3_new2(ihh3,1)=RTivn3_new(k,1);
    end
end
for k=1:imm4
    if RTivn4_new(k,1) >= iRT4-N* istd4 & RTivn4_new(k,1) <= iRT4+N* istd4
        ihh4=ihh4+1;
        RTivn4_new2(ihh4,1)=RTivn4_new(k,1);
    end
end
for k=1:inmm
    if INRT_new(k,1) >= INRT-N* instd & INRT_new(k,1) <= INRT+N* instd
        inhh=inhh+1;
        INRT_new2(inhh,1)=INRT_new(k,1);
    end
end
RT0=mean(RTvn0_new2);
RT1=mean(RTvn1_new2);
RT2=mean(RTvn2_new2);
RT3=mean(RTvn3_new2);
RT4=mean(RTvn4_new2);
NRT=mean(NRT_new2);

AE0=(NRT-mean(RTvn0_new2))*1000;
AE1=(NRT-mean(RTvn1_new2))*1000;
AE2=(NRT-mean(RTvn2_new2))*1000;
AE3=(NRT-mean(RTvn3_new2))*1000;
AE4=(NRT-mean(RTvn4_new2))*1000;
AE=[AE0 AE1 AE2 AE3 AE4];
%%%%
iRT0=mean(RTivn0_new2);
iRT1=mean(RTivn1_new2);
iRT2=mean(RTivn2_new2);
iRT3=mean(RTivn3_new2);
iRT4=mean(RTivn4_new2);
iNRT=mean(INRT_new2);

iAE0=(iNRT-mean(RTivn0_new2))*1000;
iAE1=(iNRT-mean(RTivn1_new2))*1000;
iAE2=(iNRT-mean(RTivn2_new2))*1000;
iAE3=(iNRT-mean(RTivn3_new2))*1000;
iAE4=(iNRT-mean(RTivn4_new2))*1000;

iAE=[iAE0 iAE1 iAE2 iAE3 iAE4];

O_AE0=(RT0)*1000;
O_AE1=(RT1)*1000;
O_AE2=(RT2)*1000;
O_AE3=(RT3)*1000;
O_AE4=(RT4)*1000;
O_NAE=(NRT)*1000;

O_iAE0=(iRT0)*1000;
O_iAE1=(iRT1)*1000;
O_iAE2=(iRT2)*1000;
O_iAE3=(iRT3)*1000;
O_iAE4=(iRT4)*1000;
O_iNAE=(iNRT)*1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%鍒犲幓鏁版嵁鐨勬瘮渚?
ACC0=hh0/(8*4)*100;
ACC1=hh1/32*100;
ACC2=hh2/32*100;
ACC3=hh3/32*100;
ACC4=hh4/32*100;
ACC=[ACC0 ACC1 ACC2 ACC3 ACC4];

AR0=ACC0/AE0;
AR1=ACC1/AE1;
AR2=ACC2/AE2;
AR3=ACC3/AE3;
AR4=ACC4/AE4;

AR=[AR0 AR1 AR2 AR3 AR4];
%%%
iACC0=ihh0/(8*4)*100;
iACC1=ihh1/32*100;
iACC2=ihh2/32*100;
iACC3=ihh3/32*100;
iACC4=ihh4/32*100;
iACC=[iACC0 iACC1 iACC2 iACC3 iACC4];

iAR0=iACC0/iAE0;
iAR1=iACC1/iAE1;
iAR2=iACC2/iAE2;
iAR3=iACC3/iAE3;
iAR4=iACC4/iAE4;

iAR=[iAR0 iAR1 iAR2 iAR3 iAR4];
REmoveRate=[(sum(m0)-hh0)/sum(m0)*100 (sum(m1)-hh1)/sum(m1)*100 (sum(m2)-hh2)/sum(m2)*100 (sum(m3)-hh3)/sum(m3)*100 (sum(m4)-hh4)/sum(m4)*100 (sum(nm)-nhh)/sum(nm)];
iREmoveRate=[(sum(im0)-ihh0)/sum(im0)*100 (sum(im1)-ihh1)/sum(im1)*100 (sum(im2)-ihh2)/sum(im2)*100 (sum(im3)-ihh3)/sum(im3)*100 (sum(im4)-ihh4)/sum(im4)*100 (sum(inm)-inhh)/sum(inm)];
%%%%%%restore
    
    Fixsubresult.AE0=AE0;
    Fixsubresult.AE1=AE1;
    Fixsubresult.AE2=AE2;
    Fixsubresult.AE3=AE3;
    Fixsubresult.AE4=AE4;
    Fixsubresult.ACC0=ACC0;
    Fixsubresult.ACC1=ACC1;
    Fixsubresult.ACC2=ACC2;
    Fixsubresult.ACC3=ACC3;
    Fixsubresult.ACC4=ACC4;
    Fixsubresult.AR0=AR0;
    Fixsubresult.AR1=AR1;
    Fixsubresult.AR2=AR2;
    Fixsubresult.AR3=AR3;
    Fixsubresult.AR4=AR4;
    Fixsubresult.OAE0=O_AE0;
    Fixsubresult.OAE1=O_AE1;
    Fixsubresult.OAE2=O_AE2;
    Fixsubresult.OAE3=O_AE3;
    Fixsubresult.OAE4=O_AE4;
    Fixsubresult.ONAE=O_NAE;
    Fixsubresult.iAE0=iAE0;
    Fixsubresult.iAE1=iAE1;
    Fixsubresult.iAE2=iAE2;
    Fixsubresult.iAE3=iAE3;
    Fixsubresult.iAE4=iAE4;
    Fixsubresult.iACC0=iACC0;
    Fixsubresult.iACC1=iACC1;
    Fixsubresult.iACC2=iACC2;
    Fixsubresult.iACC3=iACC3;
    Fixsubresult.iACC4=iACC4;
    Fixsubresult.iAR0=iAR0;
    Fixsubresult.iAR1=iAR1;
    Fixsubresult.iAR2=iAR2;
    Fixsubresult.iAR3=iAR3;
    Fixsubresult.iAR4=iAR4;
    Fixsubresult.OiAE0=O_iAE0;
    Fixsubresult.OiAE1=O_iAE1;
    Fixsubresult.OiAE2=O_iAE2;
    Fixsubresult.OiAE3=O_iAE3;
    Fixsubresult.OiAE4=O_iAE4;
    Fixsubresult.OiNAE=O_iNAE; 
    Fixsubresult.REmoveRate=REmoveRate;
    Fixsubresult.iREmoveRate=iREmoveRate;
    Fixsubresult.sub=subname;
  
    
    
    columnheader={'AE0','AE1','AE2','AE3','AE4','ACC0','ACC1','ACC2','ACC3','ACC4','AR0','AR1','AR2','AR3','AR4','OAE0','OAE1','OAE2','OAE3','OAE4','ONAE','iAE0','iAE1','iAE2','iAE3','iAE4','iACC0','iACC1','iACC2','iACC3','iACC4','iAR0','iAR1','iAR2','iAR3','iAR4','OiAE0','OiAE1','OiAE2','OiAE3','OiAE4','OiNAE','REmoveRate','iREmoveRate','sub'};
 %% 转换数据为表格格式
% 第一张表
dataCell = [columnheader; struct2cell(Fixsubresult)'];
dataTable1 = cell2table(dataCell(2:end,:), 'VariableNames', dataCell(1,:));

 matFile = fullfile(outputDir, sprintf('Bold_PF_%s__fixsubresult.mat', subname));
excelFile = fullfile(outputDir, sprintf('Bold_PF_%s_report.xlsx', subname));
writetable(dataTable1, excelFile, 'Sheet', '主要指标', 'Range', 'A1');
save(matFile,'Fixsubresult')
end
