clear all;
clc;
KbName('UnifyKeyNames')
rng('shuffle');Screen('Preference', 'SkipSyncTests', 1);
%%%
lum1=127;
   lum2=80;
   LUMINNACE=127;
   Orientation1=0;
   Orientation2=90;
bar_lum=1;
size=60;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KbName('UnifyKeyNames')
% prompt={'姓名','性别（男填1，女填2）','年龄','类别'};
% dlg_line='被试信息';
% num_lines = 1;
% para=inputdlg(prompt,dlg_line,num_lines);
% mm=str2num(para{4,1});
%%
ID=input('SubName：','s');
run_num=input('Block_num:');
%%
savepath=strcat('D:\EF_Bold_task\',ID,'\');
% savepath = 'D:\D_AS\ID';
% ID=input('SubName：','s');
existornot=0;
% Cue_loc=input('Cue_loc:');

%awa=input('awareness：'); % 1: Conscious; 2: Unconscious
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TrialNum=120;
% run_num=4;
rest=45;

Screen('Preference', 'SkipSyncTests', 1);
VerticalKey=KbName('i');% '3#' left
HorizontalKey=KbName('j');% '4$' right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% screen
Screens=Screen('Screens');
ScreenNumber=max(Screens);
HideCursor
% open a black screen
Black=BlackIndex(ScreenNumber);
white=WhiteIndex(ScreenNumber);
Black=(Black+white)/2;
[w,wRect]=Screen('OpenWindow',ScreenNumber,Black);
FixationRect=CenterRect([0,0,6,6],[0,0,1280,1024]);

EscapeKey = KbName('q');
TriggerKey = KbName('s');
Text=' press I when the bar is Horizontal press J when bar in vertical;Now press S to start';

%% Main EXP
%%%%%%%%%%%fix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ground
gr_x=1000;
gr_y=1000;
%%%%%%%%%%%%%
ground=uint8(ones(gr_x,gr_y,3))*LUMINNACE;
% ground(gr_x/2:gr_x/2+2,(gr_y/2-9):(gr_y/2+11),:)=255;
% ground((gr_x/2-9):(gr_x/2+11),gr_y/2:gr_y/2+2,:)=255;
%% make fixation
% 定义图像的尺寸
%F_ground=uint8(ones(gr_x,gr_y,3))*LUMINNACE;
width = 30;
height = 30;
fix_r = width/2-2;%半径
% 定义圆的中心和半径
circle_center = [width/2, height/2];
% 定义十字的宽度
cross_width = 1;
fix_ground=uint8(ones(width,height,3))*LUMINNACE;
for fix_R=0.1:0.1:fix_r
    for t=0.1:0.1:2.1*pi;
    a=ceil(width/2+fix_R*cos(t));
    b=ceil(height/2+fix_R*sin(t));
    fix_ground(a,b,3)=0;
    fix_ground(a,b,1)=255;
    fix_ground(a,b,2)=255;
    end
end
% 填充黑色的十字
for x = 1:width
    for y = 1:height
         if (abs(x - circle_center(1)) <= cross_width/2) || (abs(y - circle_center(2)) <= cross_width/2)
                fix_ground(y, x,:) = 127; % 设置为黑色
          end
    end
end
fix_ground(circle_center(1)-2:circle_center(1)+2,circle_center(2)-2:circle_center(2)+2,3)=0;
fix_ground(circle_center(1)-2:circle_center(1)+2,circle_center(2)-2:circle_center(2)+2,1)=255;
fix_ground(circle_center(1)-2:circle_center(1)+2,circle_center(2)-2:circle_center(2)+2,2)=255;
fix_ground(circle_center(1)-2:circle_center(1)+2,circle_center(2)-2:circle_center(2)+2,3)=0;
fix_ground(circle_center(1)-2:circle_center(1)+2,circle_center(2)-2:circle_center(2)+2,1)=255;
fix_ground(circle_center(1)-2:circle_center(1)+2,circle_center(2)-2:circle_center(2)+2,2)=255;
for i=1:width
    for j=1:width
    ground(gr_x/2-10+i,gr_y/2-10+j,:)=fix_ground(i,j,:);
    end
end
%%
att=Screen('MakeTexture',w,ground);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mask
diagonal = size+20;
Uncue_hollow_size=size+16;
Cue_hollow_size=size+16;
% hollow_diagonal = size+16;
% cue_hollow_diagonal = size+14;
bar_leng=size-8;
bar_wid=2;
cue_bar_wid=4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Cue MakeTexture

midsize=(size)/2;
% wid=1;
Uncue_wid=1;%distract circle width
Cue_wid=2;%cue_distract_circle_width
R=size/2-1;%round(sqrt((size/2)^2+(size/2)^2));

bar_ground1=uint8(ones(size,size,3))*LUMINNACE;
bar_ground1((size/2-bar_leng/2)+1:(size/2+bar_leng/2),(size/2-bar_wid/2)+1:(size/2+bar_wid/2),:)=lum2;
bar_ground_L=imrotate(bar_ground1,Orientation1,'bicubic','crop');%竖直方向
bar_ground_R=imrotate(bar_ground1,Orientation2,'bicubic','crop');%水平方向
bar_ground2=uint8(ones(size,size,3))*LUMINNACE;
bar_ground2((size/2-bar_leng/2)+1:(size/2+bar_leng/2),(size/2-cue_bar_wid/2)+1:(size/2+cue_bar_wid/2),:)=bar_lum;
cue_bar_ground_L=imrotate(bar_ground2,Orientation1,'bicubic','crop');%竖直方向
cue_bar_ground_R=imrotate(bar_ground2,Orientation2,'bicubic','crop');%水平方向

%制作图片
 for i=1:size
        for j=1:size
            if bar_ground_L(i,j)<60
                bar_ground_L(i,j,:)=LUMINNACE;
            end
            %%%%%%%%%%%
            if bar_ground_R(i,j)<60
                bar_ground_R(i,j,:)=LUMINNACE;
            end
            if cue_bar_ground_L(i,j)<1
                cue_bar_ground_L(i,j,:)=LUMINNACE;
            end
            if cue_bar_ground_R(i,j)<1
                cue_bar_ground_R(i,j,:)=LUMINNACE;
            end
        end
 end
%%%%%%%%%%% target vertical and horizontal
%分为左右两边，只有一边是目标
d=0;
for j=1:2
for i=1:2
    d=d+1;
%     x=uint8(ones(size,size))*LUMINNACE;
    if j==1
        dis_lum=lum2;
        wid=Uncue_wid;
       if i==1
        x=bar_ground_R;
       else
        x=bar_ground_L;
       end
    else
        dis_lum=bar_lum;
        wid=Cue_wid;
        if i==1
        x=cue_bar_ground_R;
        else
        x=cue_bar_ground_L;
        end
    end
    start_angle=(i*6+1)*pi/6;
    for t=start_angle:0.01:start_angle+pi*2
        for c_r=(R-wid):0.01:R
            x(round(c_r*sin(t)+midsize),round(c_r*cos(t)+midsize),:)=dis_lum;
        end
    end
    Dis{d}=x;

end
end

% 镂空的对角线长度
n=0;
for j=1:2
for i=1:2
    n=n+1;
target_pic=uint8(ones(diagonal,diagonal,3))*LUMINNACE;
if j==1
    tar_lum=lum2;
    hollow_diagonal=Uncue_hollow_size;
    if i==1
    target_pic((diagonal-bar_leng)/2:(diagonal-bar_leng)/2+bar_leng,(diagonal/2-bar_wid/2):(diagonal/2+bar_wid/2),:)=tar_lum;%水平  
    else
    target_pic((diagonal-bar_wid)/2:(diagonal-bar_wid)/2+bar_wid,(diagonal/2-bar_leng/2):(diagonal/2+bar_leng/2),:)=tar_lum;%竖直
    end
else
    tar_lum=bar_lum;
    hollow_diagonal=Cue_hollow_size;
    if i==1
    target_pic((diagonal-bar_leng)/2:(diagonal-bar_leng)/2+bar_leng,(diagonal/2-cue_bar_wid/2):(diagonal/2+cue_bar_wid/2),:)=tar_lum;%水平  
    else
    target_pic((diagonal-cue_bar_wid)/2:(diagonal-cue_bar_wid)/2+bar_wid,(diagonal/2-bar_leng/2):(diagonal/2+bar_leng/2),:)=tar_lum;%竖直
    end
end

% 填充菱形并镂空

for x = 1:diagonal
    for y = 1:diagonal
        % 如果像素在大菱形内但不在小菱形内，则将其设为黑色
        if abs(x - diagonal/2) + abs(y - diagonal/2) <= diagonal/2
            if abs(x - diagonal/2) + abs(y - diagonal/2) > hollow_diagonal/2
                target_pic(x, y,:) = tar_lum;
               
            end
        end
    end
end
T{n}=target_pic;
end
end
for mm=1:run_num
%%%%%%%%%%%%%%%%%%%%
loc_order=rem(mm,2);
if loc_order==1
    Cue_loc=1;
elseif loc_order==0
    Cue_loc=2;
end
%%
n=18;
r=size/2;
angle=216/n;
Ro=390;
%%%
if Cue_loc==1
    tar_r_r=diagonal/2;%diagonal/2=40;cue on right
    tar_r_l=r;
else
    tar_r_r=r;
    tar_r_l=diagonal/2;
end
%%%%
for m=1:n
    if m<=n/2

        if m==5
        o_x(m)=round(gr_x/2+Ro*sin(angle*(m-5)/180*pi)+1)-(tar_r_r);
        o_y(m)=round(gr_y/2+Ro*cos(angle*(m-5)/180*pi)+1)-(tar_r_r);
        else
        o_x(m)=round(gr_x/2+Ro*sin(angle*(m-5)/180*pi)+1)-(r);
        o_y(m)=round(gr_y/2+Ro*cos(angle*(m-5)/180*pi)+1)-(r);
        end
    elseif m>n/2
        if m==14
        o_x(m)=round(gr_x/2+Ro*sin(angle*(n-4-m)/180*pi)+1)-(tar_r_l);
        o_y(m)=round(gr_y/2-Ro*cos(angle*(n-4-m)/180*pi)+1)-(tar_r_l);
        else
        o_x(m)=round(gr_x/2+Ro*sin(angle*(n-4-m)/180*pi)+1)-(r);
        o_y(m)=round(gr_y/2-Ro*cos(angle*(n-4-m)/180*pi)+1)-(r);
        end
    end
end
%% background
 back_ground=cell(1,TrialNum);
 Cground=cell(1,TrialNum);
dis_order=randperm(18);
tar_order=randperm(TrialNum);
for c=1:TrialNum
    Cground{c}=ground;
end

for t=1:TrialNum
    stim_type=rem(tar_order(t),4)+1;%四种次级，一致和不一致
    if stim_type==1
        dis_orien=1;
        tar_orien=1;
    elseif stim_type==2
        dis_orien=2;
        tar_orien=2;
    elseif stim_type==3
        dis_orien=1;
        tar_orien=2;
    elseif stim_type==4
        dis_orien=2;
        tar_orien=1;
    end
   for n=1:18
   if Cue_loc==1
    if n==5;
       draw_pic=T{tar_orien};
       t_r=diagonal/2;
    else
       draw_pic=Dis{dis_orien};
        t_r=r;
    end
   elseif Cue_loc==2
       if n==14;
       draw_pic=T{tar_orien};
       t_r=diagonal/2;
       else
       draw_pic=Dis{dis_orien};
        t_r=r;
       end
   end
    for i=1:2*t_r
        for j=1:2*t_r
            Cground{t}(i+o_x(n),j+o_y(n),:)=draw_pic(i,j,:);
           
        end
    end

  end
back_ground{t}=Cground{t};
end
% figure;
% imshow(back_ground{1});
% figure;
% imshow(Cground);
%% reaction img
%% setlocation 
%%%%%%%%%% target location
lo1=ones(1,TrialNum/15)*1;
lo2=ones(1,TrialNum/15)*2;
lo3=ones(1,TrialNum/15)*3;
lo4=ones(1,TrialNum/15)*4;
lo5=ones(1,2*TrialNum/15)*5;
lo6=ones(1,TrialNum/15)*6;
lo7=ones(1,TrialNum/15)*7;
lo8=ones(1,TrialNum/15)*8;
lo9=ones(1,TrialNum/15)*9;
%%%
lo10=ones(1,TrialNum/15)*10;
lo11=ones(1,TrialNum/15)*11;
lo12=ones(1,TrialNum/15)*12;
lo13=ones(1,TrialNum/15)*13;
lo14=ones(1,2*TrialNum/15)*14;
lo15=ones(1,TrialNum/15)*15;
lo16=ones(1,TrialNum/15)*16;
lo17=ones(1,TrialNum/15)*17;
lo18=ones(1,TrialNum/15)*18;
%%%%%%%%%%%%%%%%涓轰粈涔堟湁鐨勬槸4鍒楋紝鏈夌殑鏄?鍒楋紵
Select_lo=cell(1,2);
for i=1:2
    if i==1
        Select_lo{i}=[lo1 lo2 lo3 lo4 lo5 lo6 lo7 lo8 lo9 ];
    else
        Select_lo{i}=[lo10 lo11 lo12 lo13 lo14 lo15 lo16 lo17 lo18 ];
    end
end
lo=Select_lo{Cue_loc};

    result=zeros(7,TrialNum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% probe
%% make target img
target=cell(1,TrialNum);
% probe_loc=randperm(TrialNum);
for h=1:TrialNum
       stim_type2=rem(tar_order(h),4)+1;%四种次级，一致和不一致
    if stim_type2==1
        D_ori=3;%竖直方向
        T_ori=3;
    elseif stim_type2==2
       D_ori=4;%水平方向
       T_ori=4;
    elseif stim_type2==3
       D_ori=3;
       T_ori=4;
    elseif stim_type2==4
       D_ori=4;
       T_ori=3;
    end
    
%    T_ori=rem(tar_order(h),2)+3;%%3,Veryical,4 Horizontal
%    D_ori=rem(probe_loc(h),2)+3;

   fix=back_ground{h};
  
   result(1,h)=stim_type2;
   result(3,h)=T_ori;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tar_order(h)<=(2*TrialNum)/3 %80 trials been cued
     n=lo(tar_order(h));
    result(2,h)=n;%cue location
  if Cue_loc==1%%%TARGET on right
   if n==5
     probe_img=T{T_ori} ;
     C_R=diagonal;
   else
     probe_img=Dis{D_ori};
     C_R=size;
   end
  elseif Cue_loc==2%%%target on left
   if n==14
     probe_img=T{T_ori} ;
     C_R=diagonal;
   else
     probe_img=Dis{D_ori};
     C_R=size;
   end
  end
    for i=1:C_R
        for j=1:C_R
            fix(i+o_x(n),j+o_y(n),:)=probe_img(i,j,:);%娌℃湁鍋氬埌绛夊彲鑳藉惂锛熷仛鍒颁簡
        end
    end
    target{h}=fix;
else
    result(2,h)=-1;%no cue
    target{h}=fix;
end
end
%%
%%%%%%%%%%%%%%% MakeTxtures
for i=1:TrialNum
    probe(i)=Screen('MakeTexture',w,target{i});
end
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect',w,Black,wRect);
Screen('FillOval',w,[255 255 0], FixationRect);
Screen('DrawText',w,Text,20,20,[255 255 0]);
Screen('Flip',w);
%
BackGRect=Screen('Rect',att);%%锛?
[touch, secs, keyCode] = KbCheck;
touch =0;

while ~(touch && (keyCode(TriggerKey)))
    [touch, secs, keyCode] = KbCheck;
end
if keyCode(EscapeKey)
    Screen('CloseAll');
end
%% picture alone
file=dir('*bmp*');
for i=1:2
Image_pool{i}=imread(file(i).name);%1:right,2"left
end

showim=Screen('MakeTexture',w,Image_pool{Cue_loc});
Screen('DrawTexture',w,showim);
Screen('Flip',w);
%%
[K_down,~,keyCode]=KbCheck;
touch=0;
start_time=GetSecs;
while GetSecs<start_time+2%2s most
    [K_down, ~, K_code] = KbCheck;
    if K_code(TriggerKey)
    end
    if keyCode(EscapeKey)
      Screen('Closeall');
    end
end

%% pre fixation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
t0=GetSecs;
Screen('DrawTexture',w,att,BackGRect);%鍒掑畾鑼冨洿锛?
Screen('Flip',w);
while GetSecs<4.000+t0 %%% 4s
    ;
end
%%%%%%%%%%%%%%%%% main 
for trial=1:TrialNum
   %%%%%%%%%%%%% Cue ISI
    ISI_order=randi(3,1);
    ISI_time=[0.4,0.5,0.6];
    t=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);
    while GetSecs<t+ISI_time(ISI_order);  %125ms锛岋紙鍘熸潵鏄?.1锛岀粨鍚坈ue鍙?.5锛岃繖涓彉0.5锛?
        ;
    end
    %%%%%%%% Target
     t_begin=GetSecs;
    Screen('DrawTexture',w,probe(1,trial),BackGRect);%
    Screen('Flip',w);
      a=0;
    while GetSecs<0.60+t_begin  %600ms
        [keyIsDown, secs, keyCode] = KbCheck;
        if  (~a)&(keyCode(VerticalKey)|keyCode(HorizontalKey)|keyCode(EscapeKey))
            a=1;
            if keyCode(VerticalKey)
                result(4,trial)=3;%vertical
            elseif keyCode(HorizontalKey)
                result(4,trial)=4;% horizontal
            end
            if keyCode(EscapeKey)
                Screen('Closeall');
            end
            result(5,trial)=GetSecs-t_begin;
        end
        ;
    end
    %要加个条件语句，在呈现时刻按键也能记录时间。
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% response
    tt=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);

    if a==1
        b=1;
    else
        b=0;
    keyCode=zeros(1,256);
    keyIsDown=0;
    end
    while GetSecs-tt<1.5
        [keyIsDown, secs, keyCode] = KbCheck;
        if  (~b)&(keyCode(VerticalKey)|keyCode(HorizontalKey)|keyCode(EscapeKey))
            b=1;
            if keyCode(VerticalKey)
                result(4,trial)=3;%vertical
            elseif keyCode(HorizontalKey)
                result(4,trial)=4;% horizontal
            end
            if keyCode(EscapeKey)
                Screen('Closeall');
            end
            result(5,trial)=GetSecs-t_begin;
        end
    end
    %%%%%%%%%%%%%%%%%
%     if result(3,trial)~=result(4,trial)
%             myBeep = ppMakeBeep(0.05,440,0.05);
%             sound(myBeep.y,myBeep.Fs);
%    end
    %%%%%%%%%%%%%%%%% ITI
    t=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);
    while GetSecs<rand(1)*(1-0.5)+0.5+t  %0.5-1s(0.5鍒?绉掞級
        ;
    end
    %%rest
    if rem(trial,rest)==0
        ae=floor(trial/rest);
        be=sprintf('%d',ae);
        Restcue=strcat('Please close your eyes and rest for a while!',be);
        Screen('FillRect',w,Black,wRect);
        Screen('DrawText',w,Restcue,1280/2-250,1024/2-8,[255 255 0]);
        Screen('Flip',w);

        while ~(touch && (keyCode(TriggerKey)))
            [touch, secs, keyCode] = KbCheck;
        end
        if keyCode(EscapeKey)
            Screen('CloseAll');
        end
        t_rest=GetSecs;
        Screen('DrawTexture',w,att,BackGRect);
        Screen('Flip',w);
        while GetSecs<4.000+t_rest %%%4s
            ;
        end
    end
end
  
%% data analysize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD0-PD4
for trial=1:TrialNum
    if Cue_loc==1
    if result(2,trial)==1 || result(2,trial)==9 
        result(6,trial)=44; %%% PD=4
    elseif result(2,trial)==2 || result(2,trial)==8 
        result(6,trial)=33;  %%% PD=3
    elseif result(2,trial)==3 || result(2,trial)==7 
        result(6,trial)=22;  %%% PD=2
    elseif result(2,trial)==4 || result(2,trial)==6 
        result(6,trial)=11;   %%% PD=1
    elseif result(2,trial)==5 
        result(6,trial)=10;  %%% PD=0;
    end
    elseif Cue_loc==2
    if result(2,trial)==10 || result(2,trial)==18
        result(6,trial)=44; %%% PD=4
    elseif result(2,trial)==11 || result(2,trial)==17 
        result(6,trial)=33;  %%% PD=3
    elseif result(2,trial)==12 || result(2,trial)==16 
        result(6,trial)=22;  %%% PD=2
    elseif result(2,trial)==13 || result(2,trial)==15 
        result(6,trial)=11;   %%% PD=1
    elseif result(2,trial)==14 
        result(6,trial)=10;  %%% PD=0;
    end
    end
end
%%

%%%%%%%%%%%%%%%%%%%%%%% ACC
for trial=1:TrialNum
    if result(3,trial)==result(4,trial)
        result(7,trial)=1; %%%%% correct
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ACC
vn0=0; vn1=0;vn2=0;vn3=0;vn4=0;
icvn0=0; icvn1=0;icvn2=0;icvn3=0;icvn4=0;
nvn=0;icnvn=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RT
RTvn0=0;RTvn1=0;RTvn2=0;RTvn3=0;RTvn4=0;
ICRTvn0=0;ICRTvn1=0;ICRTvn2=0;ICRTvn3=0;ICRTvn4=0;
RTnvn=0;ICRTnvn=0;
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
            RTnvn(nvn,1)=result(5,trial);
        end
               
      elseif result(1,trial)==3||result(1,trial)==4
        if result(2,trial)~=-1
           if result(6,trial)==10   % PD=0          
                icvn0=icvn0+1;
                ICRTvn0(icvn0,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==11   % PD=1         
                icvn1=icvn1+1;
                ICRTvn1(icvn1,1)=result(5,trial);
              
        end
        %%%%%%%%%%%%
        if result(6,trial)==22   % PD=2
                icvn2=icvn2+1;
                ICRTvn2(icvn2,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==33   % PD=3
                icvn3=icvn3+1;
                ICRTvn3(icvn3,1)=result(5,trial);
        end
        %%%%%%%%%%%%
        if result(6,trial)==44   % PD=4
                icvn4=icvn4+1;
                ICRTvn4(icvn4,1)=result(5,trial);
        end    
          elseif result(2,trial)==-1
            icnvn=icnvn+1;
            ICRTnvn(icnvn,1)=result(5,trial);
        end
     end
    end
end
RT0=mean(RTvn0);RT1=mean(RTvn1);RT2=mean(RTvn2);RT3=mean(RTvn3);RT4=mean(RTvn4);
ICRT0=mean(ICRTvn0);ICRT1=mean(ICRTvn1);ICRT2=mean(ICRTvn2);ICRT3=mean(ICRTvn3);ICRT4=mean(ICRTvn4);
NRT=mean(RTnvn);
ICNRT=mean(ICRTnvn);
%%%%%%%%
O_AE0=(RT0)*1000;
O_AE1=(RT1)*1000;
O_AE2=(RT2)*1000;
O_AE3=(RT3)*1000;
O_AE4=(RT4)*1000;
O_NAE=(NRT)*1000;

O_ICAE0=(ICRT0)*1000;
O_ICAE1=(ICRT1)*1000;
O_ICAE2=(ICRT2)*1000;
O_ICAE3=(ICRT3)*1000;
O_ICAE4=(ICRT4)*1000;
O_ICNAE=(ICNRT)*1000;

AE0=(NRT-RT0)*1000;
AE1=(NRT-RT1)*1000;
AE2=(NRT-RT2)*1000;
AE3=(NRT-RT3)*1000;
AE4=(NRT-RT4)*1000;

ICAE0=(ICNRT-ICRT0)*1000;
ICAE1=(ICNRT-ICRT1)*1000;
ICAE2=(ICNRT-ICRT2)*1000;
ICAE3=(ICNRT-ICRT3)*1000;
ICAE4=(ICNRT-ICRT4)*1000;

AE_sum=[AE0 AE1 AE2 AE3 AE4];
O_ICAE_sum=[O_ICAE0 O_ICAE1 O_ICAE2 O_ICAE3 O_ICAE4 O_ICNAE];
O_AE_sum=[O_AE0 O_AE1 O_AE2 O_AE3 O_AE4 O_NAE];
ICAE_sum=[ICAE0 ICAE1 ICAE2 ICAE3 ICAE4];
%% ACC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v0=0; v1=0;v2=0;v3=0;v4=0;
icv0=0; icv1=0;icv2=0;icv3=0;icv4=0;
nv=0;icnv=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trial=1:TrialNum
    %%%%%%%%%%%%%%%%%%%%%%
 if result(1,trial)==1||result(1,trial)==2
     if result(2,trial)~=-1
    if result(6,trial)==10 
            v0=v0+result(7,trial);   
    end  
    %%%%
    if result(6,trial)==11
            v1=v1+result(7,trial);
    end
    %%%%
    if result(6,trial)==22
            v2=v2+result(7,trial);
    end
    %%%%
    if result(6,trial)==33
     
            v3=v3+result(7,trial);
    end
    %%%%
    if result(6,trial)==44
          v4=v4+result(7,trial);
    end
     elseif result(2,trial)==-1;
        nv=nv+result(7,trial);
    end
 elseif result(1,trial)==3||result(1,trial)==4
     if result(2,trial)~=-1
     if result(6,trial)==10 
            icv0=icv0+result(7,trial);   
    end  
    %%%%
    if result(6,trial)==11
            icv1=icv1+result(7,trial);
    end
    %%%%
    if result(6,trial)==22
            icv2=icv2+result(7,trial);
    end
    %%%%
    if result(6,trial)==33
     
            icv3=icv3+result(7,trial);
    end
    %%%%
    if result(6,trial)==44
          icv4=icv4+result(7,trial);
    end
     elseif result(2,trial)==-1
        icnv=icnv+result(7,trial);
    end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ACC
ACC_PD0=v0/(TrialNum/15)*100;
ACC_PD1=v1/(TrialNum/15)*100;
ACC_PD2=v2/(TrialNum/15)*100;
ACC_PD3=v3/(TrialNum/15)*100;
ACC_PD4=v4/(TrialNum/15)*100;
ACCM=(ACC_PD0+ACC_PD1+ACC_PD2+ACC_PD3+ACC_PD4)/5;
NACC=nv/(TrialNum/6)*100;

ICACC_PD0=icv0/(TrialNum/15)*100;
ICACC_PD1=icv1/(TrialNum/15)*100;
ICACC_PD2=icv2/(TrialNum/15)*100;
ICACC_PD3=icv3/(TrialNum/15)*100;
ICACC_PD4=icv4/(TrialNum/15)*100;
ICACCM=(ICACC_PD0+ICACC_PD1+ICACC_PD2+ICACC_PD3+ICACC_PD4)/5;
ICNACC=icnv/(TrialNum/6)*100;

All_ACC=sum(result(7,:))/(TrialNum)*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Block=num2str(mm); 
% if Cue_loc==1
%     Cloc='R'
% else
%     Cloc='L'
% end

FileName=['Periphery_Bold' '_' ID '_' Block];
sts.ALL_ACC=All_ACC;
sts.NACC=NACC;
sts.ICNACC=ICNACC;
% sts.CACC=CACC;
% sts.ICACC=ICACC;
sts.ACCM=ACCM;
sts.ICACCM=ICACCM;
sts.AE=AE_sum;
sts.ICAE=ICAE_sum;
sts.OAE=O_AE_sum;
sts.OICAE=O_ICAE_sum;
sts.result=result;
Name=['Bold_PT_Analysis_result' '_' ID '_' Block];
if ~exist(strcat(savepath, FileName,'.mat'),'file')
        save([savepath, FileName],  'result')
    else
        existornot=1;
end
    save([savepath, FileName],  'result');
    save([savepath, Name], 'sts');
end
ShowCursor;
Screen('CloseAll')