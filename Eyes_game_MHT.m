%% INITIALIZING EYELINk
ID='huanghuiyingqq';
% define name of EL file
if IsOctave
    edfFile = 'DEMO';
else
    edfFile = 'eye';  %name
end
useOfEyelink = 1;
gray = 0.5;
HideCursor
Experimenter='1';
dummymode=0;
screenNumber=max(Screen('Screens'));
[widthPx, heightPx]=WindowSize(screenNumber);
window=Screen('OpenWindow', screenNumber);
% initializations
el=EyelinkInitDefaults(window);

el.backgroundcolour = [gray gray gray];
el.msgfontcolour  = 255;
el.imgtitlecolour = 255;
el.targetbeep = 0;
el.calibrationtargetcolour =  255;
el.calibrationtargetsize= 1;
el.calibrationtargetwidth=0.5;
EyelinkUpdateDefaults(el);

%connection with eyetracker, opening file

if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    cleanup(useOfEyelink, edfFile);
    return;
end
i = Eyelink('Openfile', edfFile);
if i~=0
    fprintf('Cannot create EDF file ''%s'' ', edfFile);
    cleanup(useOfEyelink, edfFile);
    return;
end
if Eyelink('IsConnected')~=1 && ~dummymode
    cleanup(useOfEyelink, edfFile);
    return;
end;

%configure eye tracker
Eyelink('command', 'add_file_preamble_text ''Recorded by %s''', Experimenter);
% This command is crucial to map the gaze positions from the tracker to
% screen pixel positions to determine fixation
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, widthPx-1, heightPx-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, widthPx-1, heightPx-1);
Eyelink('command', 'calibration_type = HV5 '); %Eyelink('command', 'calibration_type = HV9');
Eyelink('command', 'generate_default_targets = YES');
% set parser (conservative saccade thresholds)
Eyelink('command', 'saccade_velocity_threshold = 35');
Eyelink('command', 'saccade_acceleration_threshold = 9500');
% set EDF file contents
% retrieve tracker version and tracker software version
[v,vs] = Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );
vsn = regexp(vs,'\d','match');
if v ==3 && str2double(vsn{1}) == 4 % if EL 1000 and tracker version 4.xx
    % remote mode possible add HTARGET ( head target)
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT,HTARGET');
    % set link data (used for gaze cursor)
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT');
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT,HTARGET');
else
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
    % set link data (used for gaze cursor)
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT');
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
end
% calibration/drift correction target
Eyelink('command', 'button_function 5 "accept_target_fixation"');

%enter Eyetracker camera setup mode, calibration and validation
EyelinkDoTrackerSetup(el);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Amain_grating%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runNum=3;
lum1=127;
   lum2=80;
   LUMINANCE=127;
   Orientation1=45;
   Orientation2=-Orientation1;
   bar_leng=32;
   bar_wid=2;
   bar_luminance=192;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %awa=input('awareness�?); % 1: Conscious; 2: Unconscious
awa=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TrialNum=80;%�?��run总试�?
result=zeros(9,TrialNum);
Screen('Preference', 'SkipSyncTests', 1);
leftKey=KbName('n');% '3#' up
rightKey=KbName('m');% '4$' down
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get screen
Screens=Screen('Screens');
ScreenNumber=max(Screens);
HideCursor
% open a black screen
Black=BlackIndex(ScreenNumber);
white=WhiteIndex(ScreenNumber);
Black=(Black+white)/2;
[w,wRect]=Screen('OpenWindow',ScreenNumber,Black);
FixationRect=CenterRect([0,0,8,8],[0,0,1280,1024]);

EscapeKey = KbName('q');
TriggerKey = KbName('s');
Text='Waiting for the trigger to start...';
%%% Main EXP
%%%%%%%%%%%fix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ground
gr_x=660;
gr_y=660;
%%%%%%%%%%%%%
ground=uint8(ones(gr_x,gr_y,3))*LUMINANCE;
ground(gr_x/2:gr_x/2+2,(gr_y/2-9):(gr_y/2+11),:)=255;
ground((gr_x/2-9):(gr_x/2+11),gr_y/2:gr_y/2+2,:)=255;
att=Screen('MakeTexture',w,ground);

size=60;

wid=2;
R=size/2-wid+1;

n=18;
r=size/2;
angle=90*3/n;
Ro=294;

for m=1:n
    if m<=n/2
        o_x(m)=round(gr_x/2+Ro*sin(angle*(m-5)/180*pi)+1)-(r);
        o_y(m)=round(gr_y/2+Ro*cos(angle*(m-5)/180*pi)+1)-(r);
    elseif m>n/2
        o_x(m)=round(gr_x/2+Ro*sin(angle*(n-4-m)/180*pi)+1)-(r);
        o_y(m)=round(gr_y/2-Ro*cos(angle*(n-4-m)/180*pi)+1)-(r);
    end
end
R=size/2-wid+1;
midsize=(size+1)/2;

    files=dir('*bmp*');
    for i= 1:length(files)
        Image_pool{i}=imread(files(i).name);
    end
 len=length(files);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cue stimuli
low_order=randperm(TrialNum);
cue=cell(1,TrialNum);
for pp=1:TrialNum
    Cground=ground;
    
    %%%%% make cue different
     x=uint8(ones(size,size,3));
     low_image=uint8(ones(size,size,3));
     low_tar1=uint8(ones(size,size,3));
     low_tar2=uint8(ones(size,size,3));
     if pp<=TrialNum/4
         ci=1;
     elseif TrialNum/4< pp <=TrialNum/2
         ci=2;
     end
     low_i=rem(low_order(pp),2)+1;
     if low_i==1
         low_y=randsample(11:15,1);
         low_image=Image_pool{low_y};
     elseif low_i==2
         low_y=randsample(16:20,1);
         low_image=Image_pool{low_y};
     end
     Low_T{low_i}=low_image;
    if ci==1
     y=randsample(1:5,1);
     x=Image_pool{y};
    elseif ci==2
        y=randsample(6:10,1);
        x=Image_pool{y};
    end
    
    T{ci}=x;
    %%%%%%%%%%%% target orientation
%     orien=rem(pp,2)+1;
%     low_orien=rem(low_order(pp),2)+1;
    %%%%%%%%%%%%%%% distuctor oriention
%     dislo=randperm(n);
%     for i=1:n
%         ta(i)=rem(dislo(i),4)+1;
%     end
    %%%%%%%%%%%%%%%%% cue，为�?��有四类cue�?
     cc=rem(pp,4)+1;
    %%%%%%%%%%%%%%%%%%%%%%% make textures
%         if orien==1
%             low_orien=1;%����������
%         else
%             low_orien=2;
%         end
    if pp<=TrialNum/2%%%%%%% cue present；cc=1�?且前40个试次，左边线索，后40个是右边。cc=3�?的属于无线索？无线索没有定义�?
        if cc<=2
            kk=5;
            low_kk=14;
        elseif cc>2
            kk=14;
            low_kk=5;
        end

       for i=1:2*r
            for j=1:2*r
                Cground(i+o_x(kk),j+o_y(kk),:)=T{ci}(i,j,:);
                Cground(i+o_x(low_kk),j+o_y(low_kk),:)=Low_T{low_i}(i,j,:);
               
             end
       end
    elseif pp>TrialNum/2
        low_tar1=Image_pool{randsample(11:15,1)};
        low_tar2=Image_pool{randsample(16:20,1)};
        if cc<=2
            kk=5;
            low_kk=14;
        elseif cc>2
            kk=14;
            low_kk=5;
        end
        for i=1:2*r
            for j=1:2*r
                Cground(i+o_x(kk),j+o_y(kk),:)=low_tar1(i,j,:);
                Cground(i+o_x(low_kk),j+o_y(low_kk),:)=low_tar2(i,j,:);
             end
       end
    end
   
   
    cue{pp}=Cground;
end
    
%%%%%%%%%%%%%%% MakeTxtures
for i=1:TrialNum
    Cpic(i)=Screen('MakeTexture',w,cue{i});
end
%%%%%%%%%% target location
%%%%%%%%%% target location
lo1=ones(1,4)*1;
lo2=ones(1,4)*2;
lo3=ones(1,4)*3;
lo4=ones(1,4)*4;
lo5=ones(1,8)*5;
lo6=ones(1,4)*6;
lo7=ones(1,4)*7;
lo8=ones(1,4)*8;
lo9=ones(1,4)*9;
lo10=ones(1,4)*10;
lo11=ones(1,4)*11;
lo12=ones(1,4)*12;
lo13=ones(1,4)*13;
lo14=ones(1,8)*14;
lo15=ones(1,4)*15;
lo16=ones(1,4)*16;
lo17=ones(1,4)*17;
lo18=ones(1,4)*18;
%%%%%%%%%%%%%%%%为什么有的是4列，有的�?列？
lo=[lo1 lo2 lo3 lo4 lo5 lo6 lo7 lo8 lo9 lo10 lo11 lo12 lo13 lo14 lo15 lo16 lo17 lo18];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% probe


for h=1:TrialNum
    orie=rem(h,2)+1; %%%%%% orientation
%     bar_pool{1}=imread('cir1.jpg');
%     bar_pool{2}=imread('cir2.jpg');
%     switch orie
%         case 1
%             bar=bar_pool{1};%up
%         case 2
%            bar=bar_pool{2};%down
%     end
%    size=60;
     switch orie
        case 1
            Orientation=Orientation2;
        case 2
            Orientation=Orientation1;
     end
    
    gabor=Producegabor(60,Orientation,18,rand(1),0.5,15);
    
       
%     gabor_ground=repmat(gabor,[1,1,3]);
%     pic=double(loca);
%     bar_ground(pic,1)=0;
%     bar_ground(pic,2)=1;
%     bar_ground(pic,3)=0;
%    
    bar_ground=im2uint8(gabor);  
 
    
    for i=1:(2*r)
    for j=1:(2*r)
        Distance=sqrt((i-r-1)^2+(j-r-1)^2);
        if Distance>r
            bar_ground(i,j,:)=LUMINANCE;  
            bar=bar_ground;
        end
    end
    end
    fix=ground;%cuetexture as background
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:size
        for j=1:size
            fix(i+o_x(lo(h)),j+o_y(lo(h)),:)=bar(i,j,:);%没有做到等可能吧？做到了
        end
    end
    target{h}=fix;
end


%%%%%%%%%%%%%%% MakeTxtures
for i=1:TrialNum
    probe(i)=Screen('MakeTexture',w,target{i});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% stimu order
order=(1:1:TrialNum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect',w,Black,wRect);
Screen('FillOval',w,[255 255 0], FixationRect);
Screen('DrawText',w,Text,20,20,[255 255 0]);
Screen('Flip',w);
%
BackGRect=Screen('Rect',att);%%�?
[touch, secs, keyCode] = KbCheck;
touch =0;

while ~(touch && (keyCode(TriggerKey)))
    [touch, secs, keyCode] = KbCheck;
end
if keyCode(EscapeKey)
    Screen('CloseAll');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%picture alone
switch runNum
    case 1
  for i=1:len
        showt=GetSecs;
showim(i)=Screen('MakeTexture',w,Image_pool{i});
Screen('DrawTexture',w,showim(i));
Screen('Flip',w)

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
  end
end
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%再次呈现�?��屏幕
Screen('FillOval',w,[255 255 0], FixationRect);
Screen('DrawText',w,Text,20,20,[255 255 0]);
Screen('Flip',w);
[touch, secs, keyCode] = KbCheck;
touch =0;

while ~(touch && (keyCode(TriggerKey)))
    [touch, secs, keyCode] = KbCheck;
end
if keyCode(EscapeKey)
    Screen('CloseAll');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% pre fixation
t0=GetSecs;
Screen('DrawTexture',w,att,BackGRect);%划定范围�?
Screen('Flip',w);
while GetSecs<4.000+t0 %%% 4s
    ;
end
%%%%%%%%%%%%%%%%% main 
for trial=1:TrialNum
    result(1,trial)=order(1,trial);
    result(2,trial)=rem(order(1,trial),4)+1; %%%%%% <=2 cue present
    result(3,trial)=rem(order(1,trial),2)+1; %%%%%% 1: up; 2: down
     if order(1,trial)<=TrialNum/2
        if trial<=TrialNum/4
            result(9,trial)=2;%game stims
        end
        if TrialNum/4<trial<=TrialNum/2
            result(9,trial)=1;%game neutral stims
        end
     else 
            result(9,trial)=0;%无提示刺�?
   end
   
    t_begin=GetSecs;
     % start recording
    Eyelink('Message', 'calibration number %d', trial);
    Eyelink('Command', 'set_idle_mode');
    Eyelink('Command', 'clear_screen %d', 0);
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.05);
    Eyelink('StartRecording');
    %%%++++++++++++++++++++++++++++++++++++++++++++++++++
    %%%%%%%%%%%%cue
    Screen('DrawTexture',w,Cpic(order(1,trial)),BackGRect);%
    Screen('Flip',w);
    while GetSecs<0.10+t_begin  %100ms
        ;
    end
    %%%%%%%%%%%% mask
%     if result(2,trial)<=2&&result(2,trial)>0
%         t=GetSecs;
%         Screen('DrawTexture',w,mask,BackGRect);
%         Screen('Flip',w);
%         while GetSecs<0.1000+t  %100ms
%             ;
%         end
%      else
%         ;
%     end
    %%%%%%%%%%%%% ISI
    t=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);
    while GetSecs<0.15+t  %125ms，（原来�?.1，结合cue�?.5，这个变0.5�?
        ;
    end
    %%%%%%%%%%% probe
    tt=GetSecs;
    t=GetSecs;
    Screen('DrawTexture',w,probe(order(1,trial)),BackGRect);
    Screen('Flip',w);
    while GetSecs<0.0500+t  %50ms
        ;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% response
%  t=GetSecs;
%     Screen('DrawTexture',w,Cpic(order(1,trial)),BackGRect);%
%     Screen('Flip',w);
%     while GetSecs<0.425000+t  %475ms
%         ;
%     end
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);
    keyCode=zeros(1,256);
    keyIsDown=0;
    a=0;
    while GetSecs-t_begin<2.0000
        [keyIsDown, secs, keyCode] = KbCheck;
        if  (~a)&(keyCode(leftKey)|keyCode(rightKey)|keyCode(EscapeKey))
            a=1;
            if keyCode(leftKey)
                result(4,trial)=1;% up,left
            elseif keyCode(rightKey)
                result(4,trial)=2;% down,right
            end
            if keyCode(EscapeKey)
                Screen('Closeall');
            end
            result(5,trial)=GetSecs-tt;
        end
    end
    %%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%% ISI
    t=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);
    while GetSecs<rand(1)*(1-0.5)+0.5+t  %0.5-1s(0.5�?秒）
        ;
    end
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
Eyelink('StopRecording');
Eyelink('CloseFile');
fprintf('Receiving data file ''%s''\n', edfFile );
status=Eyelink('ReceiveFile');
if status > 0
    fprintf('ReceiveFile status %d\n', status);
end
if 2==exist(edfFile, 'file')
    fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
end
%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sum_time=GetSecs-t0
ShowCursor;
Screen('CloseAll');
% ENDING
% cleaning up and sending file to your computer at the end of your
% experiment

Eyelink('Command' , 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');
%download data file
try
    fprintf('Receiving data file ''%s''\n', edfFile );
    status=Eyelink('ReceiveFile');
    if status > 0
        fprintf('ReceiveFile status %d\n', status);
        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
    end
    if 2==exist(edfFile, 'file')
        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
    end
catch
    fprintf('Problem receiving data file ''%s''\n', edfFile );
end
Eyelink('Shutdown');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD0-PD4
for trial=1:TrialNum
    if result(1,trial)<=4 | result(1,trial)<=40 & result(1,trial)>36 | result(1,trial)>40 & result(1,trial)<=44 | result(1,trial)<=80 & result(1,trial)>76
        result(6,trial)=44; %%% PD=4
    elseif result(1,trial)>4 & result(1,trial)<=8 | result(1,trial)<=36 & result(1,trial)>32 | result(1,trial)>44 & result(1,trial)<=48 | result(1,trial)<=76 & result(1,trial)>72
        result(6,trial)=33;  %%% PD=3
    elseif result(1,trial)>8 & result(1,trial)<=12 | result(1,trial)<=32 & result(1,trial)>28 | result(1,trial)>48 & result(1,trial)<=52 | result(1,trial)<=72 & result(1,trial)>68
        result(6,trial)=22;  %%% PD=2
    elseif result(1,trial)>12 & result(1,trial)<=16 | result(1,trial)<=28 & result(1,trial)>24 | result(1,trial)>52 & result(1,trial)<=56 | result(1,trial)<=68 & result(1,trial)>64
        result(6,trial)=11;   %%% PD=1
    elseif result(1,trial)>16 & result(1,trial)<=24 | result(1,trial)>56 & result(1,trial)<=64
        result(6,trial)=10;  %%% PD=0;
    end
end
%%%%%%%%%%%%%%%%%%%%%%% cue valid and invalid
for trial=1:TrialNum
    if result(2,trial)<=2%%%%% cue present
        result(8,trial)=1;
    elseif result(2,trial)>2 %%%% cue absent
        result(8,trial)=2;
    end
end
%%%%%%%%%%%%%%%%%%%%%%% ACC
for trial=1:TrialNum
    if result(3,trial)==result(4,trial)
        result(7,trial)=1; %%%%% correct
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ACC
vn0=0; vn1=0;vn2=0;vn3=0;vn4=0;
GNvn0=0;GNvn1=0;GNvn2=0;GNvn3=0;GNvn4=0;
gvn0=0;gvn1=0;gvn2=0;gvn3=0;gvn4=0;
ivn0=0; ivn1=0;ivn2=0;ivn3=0;ivn4=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RT
RTvn0=0;RTvn1=0;RTvn2=0;RTvn3=0;RTvn4=0;
RTGNvn0=0;RTGNvn1=0;RTGNvn2=0;RTGNvn3=0;RTGNvn4=0;
RTgvn0=0;RTgvn1=0;RTgvn2=0;RTgvn3=0;RTgvn4=0;
RTivn0=0;RTivn1=0;RTivn2=0;RTivn3=0;RTivn4=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trial=1:TrialNum
    if result(7,trial)==1
        if result(6,trial)==10   % PD=0
            if result(8,trial)==1
                vn0=vn0+1;
                RTvn0(vn0,1)=result(5,trial);
                if result(9,trial)==1
                    GNvn0=GNvn0+1;
                    RTGNvn0(GNvn0,1)=result(5,trial);
                end
               if result(9,trial)==2
                    gvn0=gvn0+1;
                    RTgvn0(gvn0,1)=result(5,trial);
                end
            elseif result(8,trial)==2
                ivn0=ivn0+1;
                RTivn0(ivn0,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==11   % PD=1
            if result(8,trial)==1
                vn1=vn1+1;
                RTvn1(vn1,1)=result(5,trial);
                if result(9,trial)==1
                    GNvn1=GNvn1+1;
                    RTGNvn1(GNvn1,1)=result(5,trial);
                end
                if result(9,trial)==2
                    gvn1=gvn1+1;
                    RTgvn1(gvn1,1)=result(5,trial);
                end
            elseif result(8,trial)==2
                ivn1=ivn1+1;
                RTivn1(ivn1,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==22   % PD=2
            if result(8,trial)==1
                vn2=vn2+1;
                RTvn2(vn2,1)=result(5,trial);
                if result(9,trial)==1
                    GNvn2=GNvn2+1;
                    RTGNvn2(GNvn2,1)=result(5,trial);
                end
                if result(9,trial)==2
                    gvn2=gvn2+1;
                    RTgvn2(gvn2,1)=result(5,trial);
                end
            elseif result(8,trial)==2
                ivn2=ivn2+1;
                RTivn2(ivn2,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==33   % PD=3
            if result(8,trial)==1
                vn3=vn3+1;
                RTvn3(vn3,1)=result(5,trial);
                if result(9,trial)==1
                    GNvn3=GNvn3+1;
                    RTGNvn3(GNvn3,1)=result(5,trial);
                end
                if result(9,trial)==2
                    gvn3=gvn3+1;
                    RTgvn3(gvn3,1)=result(5,trial);
                end
            elseif result(8,trial)==2
                ivn3=ivn3+1;
                RTivn3(ivn3,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==44   % PD=4
            if result(8,trial)==1
                vn4=vn4+1;
                RTvn4(vn4,1)=result(5,trial);
                if result(9,trial)==1
                    GNvn4=GNvn4+1;
                    RTGNvn4(GNvn4,1)=result(5,trial);
                end
                if result(9,trial)==2
                    gvn4=gvn4+1;
                    RTgvn4(gvn4,1)=result(5,trial);
                end
            elseif result(8,trial)==2
                ivn4=ivn4+1;
                RTivn4(ivn4,1)=result(5,trial);
            end
        end
    end
end
RT0=mean(RTvn0);RT1=mean(RTvn1);RT2=mean(RTvn2);RT3=mean(RTvn3);RT4=mean(RTvn4);
GNRT0=mean(RTGNvn0);GNRT1=mean(RTGNvn1);GNRT2=mean(RTGNvn2);GNRT3=mean(RTGNvn3);GNRT4=mean(RTGNvn4);%game neutral 
gRT0=mean(RTgvn0);gRT1=mean(RTgvn1);gRT2=mean(RTgvn2);gRT3=mean(RTgvn3);gRT4=mean(RTgvn4);%gaming
iRT0=mean(RTivn0);iRT1=mean(RTivn1);iRT2=mean(RTivn2);iRT3=mean(RTivn3);iRT4=mean(RTivn4);
AE0=(iRT0-RT0)*1000;
AE1=(iRT1-RT1)*1000;
AE2=(iRT2-RT2)*1000;
AE3=(iRT3-RT3)*1000;
AE4=(iRT4-RT4)*1000;

GNAE0=(iRT0-GNRT0)*1000;
GNAE1=(iRT1-GNRT1)*1000;
GNAE2=(iRT2-GNRT2)*1000;
GNAE3=(iRT3-GNRT3)*1000;
GNAE4=(iRT4-GNRT4)*1000;

gAE0=(iRT0-gRT0)*1000;
gAE1=(iRT1-gRT1)*1000;
gAE2=(iRT2-gRT2)*1000;
gAE3=(iRT3-gRT3)*1000;
gAE4=(iRT4-gRT4)*1000;
AE_sum=[AE0 AE1 AE2 AE3 AE4];
GNAE_sum=[GNAE0 GNAE1 GNAE2 GNAE3 GNAE4];
gAE_sum=[gAE0 gAE1 gAE2 gAE3 gAE4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v0=0; v1=0;v2=0;v3=0;v4=0;
GNv0=0;GNv1=0;GNv2=0;GNv3=0;GNv4=0;
gv0=0;gv1=0;gv2=0;gv3=0;gv4=0;
iv0=0; iv1=0;iv2=0;iv3=0;iv4=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trial=1:TrialNum
    %%%%%%%%%%%%%%%%%%%%%%
    if result(6,trial)==10
        if result(8,trial)==1
            v0=v0+result(7,trial);
            if result(9,trial)==1
                GNv0=GNv0+result(7,trial);
            end
            if result(9,trial)==2
                gv0=gv0+result(7,trial);
            end
        end  
 
        %%%%
        if result(8,trial)==2
            iv0=iv0+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==11
        if result(8,trial)==1
            v1=v1+result(7,trial);
            if result(9,trial)==1
                GNv1=GNv1+result(7,trial);
            end
            if result(9,trial)==2
                gv1=gv1+result(7,trial);
            end
        end
        %%%%
        if result(8,trial)==2
            iv1=iv1+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==22
        if result(8,trial)==1
            v2=v2+result(7,trial);
            if result(9,trial)==1
                GNv2=GNv2+result(7,trial);
            end
            if result(9,trial)==2
            gv2=gv2+result(7,trial);
            end
        end
        %%%%
        if result(8,trial)==2
            iv2=iv2+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==33
        if result(8,trial)==1
            v3=v3+result(7,trial);
            if result(9,trial)==1
                GNv3=GNv3+result(7,trial);
            end
            if result(9,trial)==2
                gv3=gv3+result(7,trial);
            end
        end
  
        %%%%
        if result(8,trial)==2
            iv3=iv3+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==44
        if result(8,trial)==1
            v4=v4+result(7,trial);
            if result(9,trial)==1
                GNv4=GNv4+result(7,trial);
            elseif result(9,trial)==2
                gv4=gv4+result(7,trial);
            end
        end
        %%%%
       if result(8,trial)==2
            iv4=iv4+result(7,trial);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ACC
VACC_PD0=v0/8*100;
VACC_PD1=v1/8*100;
VACC_PD2=v2/8*100;
VACC_PD3=v3/8*100;
VACC_PD4=v4/8*100;
VACCM=(VACC_PD0+VACC_PD1+VACC_PD2+VACC_PD3+VACC_PD4)/5;
GNVACC_PD0=GNv0/4*100;
GNVACC_PD1=GNv1/4*100;
GNVACC_PD2=GNv2/4*100;
GNVACC_PD3=GNv3/4*100;
GNVACC_PD4=GNv4/4*100;
GNVACCM=(GNVACC_PD0+GNVACC_PD1+GNVACC_PD2+GNVACC_PD3+GNVACC_PD4)/5;

gVACC_PD0=gv0/4*100;
gVACC_PD1=gv1/4*100;
gVACC_PD2=gv2/4*100;
gVACC_PD3=gv3/4*100;
gVACC_PD4=gv4/4*100;
gVACCM=(gVACC_PD0+gVACC_PD1+gVACC_PD2+gVACC_PD3+gVACC_PD4)/5;

IVACC_PD0=iv0/8*100;
IVACC_PD1=iv1/8*100;
IVACC_PD2=iv2/8*100;
IVACC_PD3=iv3/8*100;
IVACC_PD4=iv4/8*100;
IVACCM=(IVACC_PD0+IVACC_PD1+IVACC_PD2+IVACC_PD3+IVACC_PD4)/5;
ACCM=[VACC_PD0 VACC_PD1 VACC_PD2 VACC_PD3 VACC_PD4;IVACC_PD0 IVACC_PD1 IVACC_PD2 IVACC_PD3 IVACC_PD4; VACC_PD0-IVACC_PD0 VACC_PD1-IVACC_PD1 VACC_PD2-IVACC_PD2 VACC_PD3-IVACC_PD3 VACC_PD4-IVACC_PD4];
ACC=sum(result(7,:))/TrialNum*100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Block=num2str(runNum); AWA=num2str(awa);
FileName=['GaMHT_Bar' '_' ID '_' Block];
sts.AE=AE_sum;
sts.GNAE=GNAE_sum;
sts.gAE=gAE_sum;
sts.VACC=VACCM;
sts.GNACC=GNVACCM;
sts.gACC=gVACCM;
sts.IVACCM=IVACCM;
sts.ACCM=ACCM;
sts.ACC=ACC;
sts.result=result;
Name=['GaAnalysis_result' '_' ID '_' Block];
save (Name,'sts');
save(FileName, 'result');